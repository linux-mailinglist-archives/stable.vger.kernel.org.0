Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E449106A6B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfKVKek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfKVKej (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:34:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D20F620656;
        Fri, 22 Nov 2019 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418879;
        bh=OQxAjtgjoRmh71w/KKY3w4GztgCDEsVjgMRHOe26tms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcCkX9auO3ynNaFL2CSkGsaya1rA0UJNJ/jqooNZAuSdP2FUn+nl+nF0f4RcTSgvg
         yL9sQiqHTOkHzmLapVMzLCORa3+TGUTP4I2BCRRN9XpoVA8DLynXCvlDPTUbrPCHH8
         uEl83pgteNNFtB+g1nefTTxYF7TVhbhsXO3H2Sp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 084/159] usb: gadget: uvc: Only halt video streaming endpoint in bulk mode
Date:   Fri, 22 Nov 2019 11:27:55 +0100
Message-Id: <20191122100806.327002706@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 8dbf9c7abefd5c1434a956d5c6b25e11183061a3 ]

When USB requests for video data fail to be submitted, the driver
signals a problem to the host by halting the video streaming endpoint.
This is only valid in bulk mode, as isochronous transfers have no
handshake phase and can't thus report a stall. The usb_ep_set_halt()
call returns an error when using isochronous endpoints, which we happily
ignore, but some UDCs complain in the kernel log. Fix this by only
trying to halt the endpoint in bulk mode.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Tested-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 540917f54506a..d6bab12b0b47d 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -136,7 +136,9 @@ static int uvcg_video_ep_queue(struct uvc_video *video, struct usb_request *req)
 	ret = usb_ep_queue(video->ep, req, GFP_ATOMIC);
 	if (ret < 0) {
 		printk(KERN_INFO "Failed to queue request (%d).\n", ret);
-		usb_ep_set_halt(video->ep);
+		/* Isochronous endpoints can't be halted. */
+		if (usb_endpoint_xfer_bulk(video->ep->desc))
+			usb_ep_set_halt(video->ep);
 	}
 
 	return ret;
-- 
2.20.1



