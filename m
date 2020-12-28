Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6322E6551
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgL1Ncn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbgL1Ncm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DE82072C;
        Mon, 28 Dec 2020 13:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162321;
        bh=mjH3s++s2NZwACRh8No1gLtdj/M3SLyh40brublCB9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdeWo2LZubX6670Za4rYrWk8PqSIBEff+o8wLdQrTllze0wZNa22LWone9qlYUsPK
         dM53gdCgbj9gkB3jDsNaqy/qiSaaGgrSuN43ThI+sYhm8eXitGt+YsqcXDFNgHke21
         G1167nVrGdYZ5uhcTF/Xa/jkKcDvojtnKKK5Y+tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 264/346] media: ipu3-cio2: Validate mbus format in setting subdev format
Date:   Mon, 28 Dec 2020 13:49:43 +0100
Message-Id: <20201228124932.526808559@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
@@ -1271,6 +1271,9 @@ static int cio2_subdev_set_fmt(struct v4
 			       struct v4l2_subdev_format *fmt)
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
+	struct v4l2_mbus_framefmt *mbus;
+	u32 mbus_code = fmt->format.code;
+	unsigned int i;
 
 	/*
 	 * Only allow setting sink pad format;
@@ -1279,18 +1282,26 @@ static int cio2_subdev_set_fmt(struct v4
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


