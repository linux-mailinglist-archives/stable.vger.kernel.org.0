Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382163100BA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBDXaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 18:30:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhBDX37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 18:29:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l7o3f-004HTA-Vw; Fri, 05 Feb 2021 00:29:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Subject: [PATCH] media: pwc-if: Use USB controller device when mapping DMA buffer
Date:   Fri,  5 Feb 2021 00:28:51 +0100
Message-Id: <20210204232851.1020416-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a WARN_ON_ONCE(!dev->dma_mask) in dma_map_page_attrs().
The PWC driver does not perform DMA operations itself. The USB bus
controller does. Hence the mapping should be performed for that
device. The bus controller has the DMA mask set, since it actually
interacts with the hardware, where as the PWC driver does not.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

I don't hang out in the media subsystem mailing list, being a network
hacker. So i don't know the local customs here.

This patch is based on git://linuxtv.org/media_tree.git branch fixes.
Please let me know if it needs rebasing to somewhere else.

I did not do a git bisect. I do know v5.9 works, v5.10 regressed. I
cannot give an exact Fixes: tag as a result. It would be nice to get
it into stable for 5.10, but it does not need to go any further back.

drivers/media/usb/pwc/pwc-if.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 61869636ec61..406cc0268c7b 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -461,7 +461,7 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 		urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
-		urb->transfer_buffer = pwc_alloc_urb_buffer(&udev->dev,
+		urb->transfer_buffer = pwc_alloc_urb_buffer(udev->bus->controller,
 							    urb->transfer_buffer_length,
 							    &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
@@ -515,6 +515,7 @@ static void pwc_iso_stop(struct pwc_device *pdev)
 
 static void pwc_iso_free(struct pwc_device *pdev)
 {
+	struct usb_device *udev = pdev->udev;
 	int i;
 
 	/* Freeing ISOC buffers one by one */
@@ -524,7 +525,7 @@ static void pwc_iso_free(struct pwc_device *pdev)
 		if (urb) {
 			PWC_DEBUG_MEMORY("Freeing URB\n");
 			if (urb->transfer_buffer)
-				pwc_free_urb_buffer(&urb->dev->dev,
+				pwc_free_urb_buffer(udev->bus->controller,
 						    urb->transfer_buffer_length,
 						    urb->transfer_buffer,
 						    urb->transfer_dma);
-- 
2.30.0

