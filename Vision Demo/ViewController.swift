//
//  ViewController.swift
//  Vision Demo
//
//  Created by Tim Richardson on 19/07/2017.
//  Copyright © 2017 TRCO. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var peopleImageView: UIImageView!
    private let peopleImage = UIImage(named: "people")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleImageView.image = peopleImage
        
        if let image = peopleImage.cgImage {
            let imageRequestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: completionHandler)
            
            try? imageRequestHandler.perform([faceDetectionRequest])
        }
    }
    
    func completionHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else { return }
        addFaceRectangles(forObservations: observations)
    }
    
    func addFaceRectangles(forObservations observations: [VNFaceObservation]) {
        let imageRect = AVMakeRect(aspectRatio: peopleImage.size, insideRect: peopleImageView.bounds)
        observations.map { $0.faceShapeLayer(in: imageRect) }.forEach(peopleImageView.layer.addSublayer)
    }
}

private extension VNFaceObservation {
    func faceShapeLayer(in imageRect:CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = faceRect(in: imageRect)
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 3
        return layer
    }
    
    // Thanks to @NilStack for this piece of code from the article: https://medium.com/compileswift/swift-world-whats-new-in-ios-11-vision-456ba4156bad
    func faceRect(in imageRect:CGRect) -> CGRect {
        let w = boundingBox.size.width * imageRect.width
        let h = boundingBox.size.height * imageRect.height
        let x = boundingBox.origin.x * imageRect.width
        let y = imageRect.maxY - (boundingBox.origin.y * imageRect.height) - h
        return CGRect(x: x , y: y, width: w, height: h)
    }
}
