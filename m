Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7F2F4C2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfE3ElX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbfE3DM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:26 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D787218B6;
        Thu, 30 May 2019 03:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185945;
        bh=gs5R8LLX3qSwO7Dx4y9hcIyLtjyrMZRGY5AoORF1j+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4t7o8qid7m68NrTK+l0+tK8hgj4/9a5AFN2PSQ47SzV+QVHJ2e1mG9PNd8cK1MdE
         FtH5YqI2cW0HSfeSYH8nt1un5lovpiKWlduTMsVbEtr1TK8zpS4fCdVwOgKECOR6pZ
         FKJBOcQaqCeq2ZV7XJuSoMzI2BgYN4pygipORByY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 354/405] media: gspca: do not resubmit URBs when streaming has stopped
Date:   Wed, 29 May 2019 20:05:52 -0700
Message-Id: <20190530030558.553604000@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e6f8bd59c28f758feea403a70d6c3ef28c50959f ]

When streaming is stopped all URBs are killed, but in fill_frame and in
bulk_irq this results in an attempt to resubmit the killed URB. That is
not what you want and causes spurious kernel messages.

So check if streaming has stopped before resubmitting.

Also check against gspca_dev->streaming rather than vb2_start_streaming_called()
since vb2_start_streaming_called() will return true when in stop_streaming,
but gspca_dev->streaming is set to false when stop_streaming is called.

Fixes: 6992effe5344 ("gspca: Kill all URBs before releasing any of them")

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/gspca.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 128935f2a217e..4d7517411cc2d 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -314,6 +314,8 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 	}
 
 resubmit:
+	if (!gspca_dev->streaming)
+		return;
 	/* resubmit the URB */
 	st = usb_submit_urb(urb, GFP_ATOMIC);
 	if (st < 0)
@@ -330,7 +332,7 @@ static void isoc_irq(struct urb *urb)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 
 	gspca_dbg(gspca_dev, D_PACK, "isoc irq\n");
-	if (!vb2_start_streaming_called(&gspca_dev->queue))
+	if (!gspca_dev->streaming)
 		return;
 	fill_frame(gspca_dev, urb);
 }
@@ -344,7 +346,7 @@ static void bulk_irq(struct urb *urb)
 	int st;
 
 	gspca_dbg(gspca_dev, D_PACK, "bulk irq\n");
-	if (!vb2_start_streaming_called(&gspca_dev->queue))
+	if (!gspca_dev->streaming)
 		return;
 	switch (urb->status) {
 	case 0:
@@ -367,6 +369,8 @@ static void bulk_irq(struct urb *urb)
 				urb->actual_length);
 
 resubmit:
+	if (!gspca_dev->streaming)
+		return;
 	/* resubmit the URB */
 	if (gspca_dev->cam.bulk_nurbs != 0) {
 		st = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.20.1



