Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7401234A259
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 08:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCZHIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 03:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhCZHIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 03:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2661361A18;
        Fri, 26 Mar 2021 07:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616742511;
        bh=sXwnIprZmMIrKB+DPfRa+LIKSbjh/O8/0Y1/QqdE1D4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ehcQV1iK6S4JP9ab9aG2S5wByeNFeaXvgKMB24/bg7gqvvc/mUucSnpJyscNrCU9Z
         LW6OpBaNcUb9CHuEY0Boi4GmZK0rsFpEMuIGBZbC7cGG3biBa5Fu4PPX98XXTjTSqQ
         3X7WGn1Q1Q1D+G5UxAefC020iyInRq8/nwHQLy60=
Date:   Fri, 26 Mar 2021 08:08:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Drung <bdrung@posteo.de>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Adam Goode <agoode@google.com>
Subject: Re: [PATCH] media: uvcvideo: Fix pixel format change for Elgato Cam
 Link 4K
Message-ID: <YF2IaxPZxJ4J/V6K@kroah.com>
References: <20210325213458.51309-1-bdrung@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325213458.51309-1-bdrung@posteo.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 10:34:59PM +0100, Benjamin Drung wrote:
> The Elgato Cam Link 4K HDMI video capture card reports to support three
> different pixel formats, where the first format depends on the connected
> HDMI device.
> 
> ```
> $ v4l2-ctl -d /dev/video0 --list-formats-ext
> ioctl: VIDIOC_ENUM_FMT
> 	Type: Video Capture
> 
> 	[0]: 'NV12' (Y/CbCr 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> 	[1]: 'NV12' (Y/CbCr 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> 	[2]: 'YU12' (Planar YUV 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> ```
> 
> Changing the pixel format to anything besides the first pixel format
> does not work:
> 
> ```
> v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
> Format Video Capture:
> 	Width/Height      : 3840/2160
> 	Pixel Format      : 'NV12' (Y/CbCr 4:2:0)
> 	Field             : None
> 	Bytes per Line    : 3840
> 	Size Image        : 12441600
> 	Colorspace        : sRGB
> 	Transfer Function : Rec. 709
> 	YCbCr/HSV Encoding: Rec. 709
> 	Quantization      : Default (maps to Limited Range)
> 	Flags             :
> ```
> 
> User space applications like VLC might show an error message on the
> terminal in that case:
> 
> ```
> libv4l2: error set_fmt gave us a different result than try_fmt!
> ```
> 
> Depending on the error handling of the user space applications, they
> might display a distorted video, because they use the wrong pixel format
> for decoding the stream.
> 
> The Elgato Cam Link 4K responds to the USB video probe
> VS_PROBE_CONTROL/VS_COMMIT_CONTROL with a malformed data structure: The
> second byte contains bFormatIndex (instead of being the second byte of
> bmHint). The first byte is always zero. The third byte is always 1.
> 
> The firmware bug was reported to Elgato on 2020-12-01 and it was
> forwarded by the support team to the developers as feature request.
> There is no firmware update available since then. The latest firmware
> for Elgato Cam Link 4K as of 2021-03-23 has MCU 20.02.19 and FPGA 67.
> 
> Therefore add a quirk to correct the malformed data structure.
> 
> The quirk was successfully tested with VLC, OBS, and Chromium using
> different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
> 1920x1080), and frame rates (29.970 and 59.940 fps).
> 
> Signed-off-by: Benjamin Drung <bdrung@posteo.de>
> ---
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
