Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250A72A83F1
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKEQtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:49:07 -0500
Received: from www.linuxtv.org ([130.149.80.248]:45180 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgKEQtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:49:07 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kaiRe-00GMuY-33; Thu, 05 Nov 2020 16:49:06 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 05 Nov 2020 16:39:56 +0000
Subject: [git:media_tree/master] media: ipu3-cio2: Validate mbus format in setting subdev format
To:     linuxtv-commits@linuxtv.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kaiRe-00GMuY-33@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ipu3-cio2: Validate mbus format in setting subdev format
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Thu Oct 8 21:33:26 2020 +0200

Validate media bus code, width and height when setting the subdev format.

This effectively reworks how setting subdev format is implemented in the
driver.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

---

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index b3a08196e08c..72095f8a4d46 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1257,6 +1257,9 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_format *fmt)
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
+	struct v4l2_mbus_framefmt *mbus;
+	u32 mbus_code = fmt->format.code;
+	unsigned int i;
 
 	/*
 	 * Only allow setting sink pad format;
@@ -1265,18 +1268,26 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->pad == CIO2_PAD_SOURCE)
 		return cio2_subdev_get_fmt(sd, cfg, fmt);
 
-	mutex_lock(&q->subdev_lock);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		mbus = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+	else
+		mbus = &q->subdev_fmt;
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
-	} else {
-		/* It's the sink, allow changing frame size */
-		q->subdev_fmt.width = fmt->format.width;
-		q->subdev_fmt.height = fmt->format.height;
-		q->subdev_fmt.code = fmt->format.code;
-		fmt->format = q->subdev_fmt;
+	fmt->format.code = formats[0].mbus_code;
+
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
