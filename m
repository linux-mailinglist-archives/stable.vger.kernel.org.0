Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F2627C4BE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgI2LQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbgI2LP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:15:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6AA2208FE;
        Tue, 29 Sep 2020 11:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378129;
        bh=YTi2DVDTYY9Gzpuq/f0hpUTUJ4WQ85KgDRz9QQ36yCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ydv5p0QodU3V6YXhH+TD4GyT/xni9lofKqu7/GWa/h81hhW9SzZI2PX/+rHZlahjK
         lCmUW+RpVmubQwa/R//YvgFlA+OP4pP9EHDOAs0uDnAX72sksT/BHYUck0/iYWLI+l
         n0rHTglW00eKatjzawHdSSDEHpVGbv9F0YHhD5v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Josef=20M=C3=B6llers?= <josef.moellers@suse.com>
Subject: [PATCH 4.14 072/166] media: go7007: Fix URB type for interrupt handling
Date:   Tue, 29 Sep 2020 12:59:44 +0200
Message-Id: <20200929105938.817574636@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a3ea410cac41b19a5490aad7fe6d9a9a772e646e ]

Josef reported that his old-and-good Plextor ConvertX M402U video
converter spews lots of WARNINGs on the recent kernels, and it turned
out that the device uses a bulk endpoint for interrupt handling just
like 2250 board.

For fixing it, generalize the check with the proper verification of
the endpoint instead of hard-coded board type check.

Fixes: 7e5219d18e93 ("[media] go7007: Fix 2250 urb type")
Reported-and-tested-by: Josef Möllers <josef.moellers@suse.com>
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1162583
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206427

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index ed9bcaf08d5ec..ddfaabd4c0813 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1052,6 +1052,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	struct go7007_usb *usb;
 	const struct go7007_usb_board *board;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_host_endpoint *ep;
 	unsigned num_i2c_devs;
 	char *name;
 	int video_pipe, i, v_urb_len;
@@ -1147,7 +1148,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	if (usb->intr_urb->transfer_buffer == NULL)
 		goto allocfail;
 
-	if (go->board_id == GO7007_BOARDID_SENSORAY_2250)
+	ep = usb->usbdev->ep_in[4];
+	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
 		usb_fill_bulk_urb(usb->intr_urb, usb->usbdev,
 			usb_rcvbulkpipe(usb->usbdev, 4),
 			usb->intr_urb->transfer_buffer, 2*sizeof(u16),
-- 
2.25.1



