Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BB12F040
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfE3DSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbfE3DSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:00 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1E224755;
        Thu, 30 May 2019 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186280;
        bh=x5VhJwigPDOHBAwqUH1tDZvuT045Kx3Kovey9QFR+7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llvlxvi/v//2D8pdZBnnewDyEZLebObjT5BZvthCqZXH7aVHMeepshsZKnQov7yfZ
         l1Kif3Vz1O4cSMMjeVwH8/STe5NBAjSm2lJoG/8A5oaimN4Zx1CuFBjwqWiHrQh8sd
         6EYSc7RzC5Wn1b3ALYmQGZcY1FP+ERV+FxggA3LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 222/276] media: gspca: Kill URBs on USB device disconnect
Date:   Wed, 29 May 2019 20:06:20 -0700
Message-Id: <20190530030538.990409984@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b9ea7c2b57a0c9c3341fc6db039d1f7971a432e ]

In order to prevent ISOC URBs from being infinitely resubmitted,
the driver's USB disconnect handler must kill all the in-flight URBs.

While here, change the URB packet status message to a debug level,
to avoid spamming the console too much.

This commit fixes a lockup caused by an interrupt storm coming
from the URB completion handler.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/gspca.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 405a6a76d820f..fd4a1456b6ca2 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -294,7 +294,7 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 		/* check the packet status and length */
 		st = urb->iso_frame_desc[i].status;
 		if (st) {
-			pr_err("ISOC data error: [%d] len=%d, status=%d\n",
+			gspca_dbg(gspca_dev, D_PACK, "ISOC data error: [%d] len=%d, status=%d\n",
 			       i, len, st);
 			gspca_dev->last_packet_type = DISCARD_PACKET;
 			continue;
@@ -1630,6 +1630,8 @@ void gspca_disconnect(struct usb_interface *intf)
 
 	mutex_lock(&gspca_dev->usb_lock);
 	gspca_dev->present = false;
+	destroy_urbs(gspca_dev);
+	gspca_input_destroy_urb(gspca_dev);
 
 	vb2_queue_error(&gspca_dev->queue);
 
-- 
2.20.1



