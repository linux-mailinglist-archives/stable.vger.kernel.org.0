Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4442E436B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407049AbgL1Pdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407308AbgL1NxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46D1422AAA;
        Mon, 28 Dec 2020 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163557;
        bh=6oPqxRX3iyoDLdjqjGPCEyIyaWuKW6O8UfrLMjPjGPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CibTSpu31dbgohkw/9F6riMkS3XEsMd7CpL6mUN9m868+Id/cPXbJC9nT6z8xt1VM
         LXxEg0vNIN1HiH8piGRGKX9Gw0svAY3vkKSBMBgY6S8+lbv2/TQB49N8Cs81j00b5Q
         83MjP/F9+MhIrVHBjQGeGfCVIgerekqdF7foc99c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 327/453] media: ipu3-cio2: Validate mbus format in setting subdev format
Date:   Mon, 28 Dec 2020 13:49:23 +0100
Message-Id: <20201228124952.947697197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit a86cf9b29e8b12811cf53c4970eefe0c1d290476 upstream.

Validate media bus code, width and height when setting the subdev format.

This effectively reworks how setting subdev format is implemented in the
driver.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1269,6 +1269,9 @@ static int cio2_subdev_set_fmt(struct v4
 			       struct v4l2_subdev_format *fmt)
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
+	struct v4l2_mbus_framefmt *mbus;
+	u32 mbus_code = fmt->format.code;
+	unsigned int i;
 
 	/*
 	 * Only allow setting sink pad format;
@@ -1277,18 +1280,26 @@ static int cio2_subdev_set_fmt(struct v4
 	if (fmt->pad == CIO2_PAD_SOURCE)
 		return cio2_subdev_get_fmt(sd, cfg, fmt);
 
-	mutex_lock(&q->subdev_lock);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		mbus = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+	else
+		mbus = &q->subdev_fmt;
+
+	fmt->format.code = formats[0].mbus_code;
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
-	} else {
-		/* It's the sink, allow changing frame size */
-		q->subdev_fmt.width = fmt->format.width;
-		q->subdev_fmt.height = fmt->format.height;
-		q->subdev_fmt.code = fmt->format.code;
-		fmt->format = q->subdev_fmt;
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
+		if (formats[i].mbus_code == fmt->format.code) {
+			fmt->format.code = mbus_code;
+			break;
+		}
 	}
 
+	fmt->format.width = min_t(u32, fmt->format.width, CIO2_IMAGE_MAX_WIDTH);
+	fmt->format.height = min_t(u32, fmt->format.height,
+				   CIO2_IMAGE_MAX_LENGTH);
+
+	mutex_lock(&q->subdev_lock);
+	*mbus = fmt->format;
 	mutex_unlock(&q->subdev_lock);
 
 	return 0;


