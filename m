Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662B92A83F4
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgKEQtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:49:11 -0500
Received: from www.linuxtv.org ([130.149.80.248]:45866 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbgKEQtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:49:11 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kaiRe-00GMvI-8F; Thu, 05 Nov 2020 16:49:06 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 05 Nov 2020 16:38:49 +0000
Subject: [git:media_tree/master] media: ipu3-cio2: Return actual subdev format
To:     linuxtv-commits@linuxtv.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kaiRe-00GMvI-8F@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ipu3-cio2: Return actual subdev format
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Thu Oct 8 21:06:28 2020 +0200

Return actual subdev format on ipu3-cio2 subdev pads. The earlier
implementation was based on an infinite recursion that exhausted the
stack.

Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

---

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 4e598e937dfe..afa472026ba4 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1232,29 +1232,11 @@ static int cio2_subdev_get_fmt(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_format *fmt)
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
-	struct v4l2_subdev_format format;
-	int ret;
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
-		return 0;
-	}
-
-	if (fmt->pad == CIO2_PAD_SINK) {
-		format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL,
-				       &format);
-
-		if (ret)
-			return ret;
-		/* update colorspace etc */
-		q->subdev_fmt.colorspace = format.format.colorspace;
-		q->subdev_fmt.ycbcr_enc = format.format.ycbcr_enc;
-		q->subdev_fmt.quantization = format.format.quantization;
-		q->subdev_fmt.xfer_func = format.format.xfer_func;
-	}
-
-	fmt->format = q->subdev_fmt;
+	else
+		fmt->format = q->subdev_fmt;
 
 	return 0;
 }
