Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA35246B39
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbgHQPvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbgHQPuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F0520657;
        Mon, 17 Aug 2020 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679454;
        bh=e9Rxt8dGvwp9PMOOJfLvDUzKt3V8QEgABawfLsCWcbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1qZrEPfjG9t8XCGA58rKnuFA+IyWWBw+pqcQjDqiXJkfmcCVLMXHWbbD/gGgakzQ
         /KA5xjVFGCIjOLFo4pYeEiQOJgIwtF/oJlmnnE51KZiqnyw06cooKBmc3j9gNlSujp
         JQkQuITqvDqZJC5unLqZk0rzIeU65AIvFmc+SULY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+cabfa4b5b05ff6be4ef0@syzkaller.appspotmail.com
Subject: [PATCH 5.7 216/393] go7007: add sanity checking for endpoints
Date:   Mon, 17 Aug 2020 17:14:26 +0200
Message-Id: <20200817143830.104540931@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 137641287eb40260783a4413847a0aef06023a6c ]

A malicious USB device may lack endpoints the driver assumes to exist
Accessing them leads to NULL pointer accesses. This patch introduces
sanity checking.

Reported-and-tested-by: syzbot+cabfa4b5b05ff6be4ef0@syzkaller.appspotmail.com

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 866b8695d67e8 ("Staging: add the go7007 video driver")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index f889c9d740cd1..dbf0455d5d50d 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1132,6 +1132,10 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		go->hpi_ops = &go7007_usb_onboard_hpi_ops;
 	go->hpi_context = usb;
 
+	ep = usb->usbdev->ep_in[4];
+	if (!ep)
+		return -ENODEV;
+
 	/* Allocate the URB and buffer for receiving incoming interrupts */
 	usb->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (usb->intr_urb == NULL)
@@ -1141,7 +1145,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	if (usb->intr_urb->transfer_buffer == NULL)
 		goto allocfail;
 
-	ep = usb->usbdev->ep_in[4];
 	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
 		usb_fill_bulk_urb(usb->intr_urb, usb->usbdev,
 			usb_rcvbulkpipe(usb->usbdev, 4),
@@ -1263,9 +1266,13 @@ static int go7007_usb_probe(struct usb_interface *intf,
 
 	/* Allocate the URBs and buffers for receiving the video stream */
 	if (board->flags & GO7007_USB_EZUSB) {
+		if (!usb->usbdev->ep_in[6])
+			goto allocfail;
 		v_urb_len = 1024;
 		video_pipe = usb_rcvbulkpipe(usb->usbdev, 6);
 	} else {
+		if (!usb->usbdev->ep_in[1])
+			goto allocfail;
 		v_urb_len = 512;
 		video_pipe = usb_rcvbulkpipe(usb->usbdev, 1);
 	}
@@ -1285,6 +1292,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	/* Allocate the URBs and buffers for receiving the audio stream */
 	if ((board->flags & GO7007_USB_EZUSB) &&
 	    (board->main_info.flags & GO7007_BOARD_HAS_AUDIO)) {
+		if (!usb->usbdev->ep_in[8])
+			goto allocfail;
 		for (i = 0; i < 8; ++i) {
 			usb->audio_urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
 			if (usb->audio_urbs[i] == NULL)
-- 
2.25.1



