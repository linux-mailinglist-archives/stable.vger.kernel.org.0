Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8332A83F6
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgKEQtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:49:12 -0500
Received: from www.linuxtv.org ([130.149.80.248]:45754 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgKEQtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:49:12 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kaiRe-00GMuv-5l; Thu, 05 Nov 2020 16:49:06 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 05 Nov 2020 16:39:17 +0000
Subject: [git:media_tree/master] media: ipu3-cio2: Serialise access to pad format
To:     linuxtv-commits@linuxtv.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kaiRe-00GMuv-5l@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ipu3-cio2: Serialise access to pad format
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Thu Oct 8 21:29:38 2020 +0200

Pad format can be accessed from user space. Serialise access to it.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 11 +++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h |  1 +
 2 files changed, 12 insertions(+)

---

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index afa472026ba4..b3a08196e08c 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1233,11 +1233,15 @@ static int cio2_subdev_get_fmt(struct v4l2_subdev *sd,
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
 
+	mutex_lock(&q->subdev_lock);
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 	else
 		fmt->format = q->subdev_fmt;
 
+	mutex_unlock(&q->subdev_lock);
+
 	return 0;
 }
 
@@ -1261,6 +1265,8 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->pad == CIO2_PAD_SOURCE)
 		return cio2_subdev_get_fmt(sd, cfg, fmt);
 
+	mutex_lock(&q->subdev_lock);
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
 	} else {
@@ -1271,6 +1277,8 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 		fmt->format = q->subdev_fmt;
 	}
 
+	mutex_unlock(&q->subdev_lock);
+
 	return 0;
 }
 
@@ -1529,6 +1537,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
 
 	/* Initialize miscellaneous variables */
 	mutex_init(&q->lock);
+	mutex_init(&q->subdev_lock);
 
 	/* Initialize formats to default values */
 	fmt = &q->subdev_fmt;
@@ -1645,6 +1654,7 @@ fail_vdev_media_entity:
 fail_subdev_media_entity:
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
 fail_fbpt:
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 
 	return r;
@@ -1657,6 +1667,7 @@ static void cio2_queue_exit(struct cio2_device *cio2, struct cio2_queue *q)
 	v4l2_device_unregister_subdev(&q->subdev);
 	media_entity_cleanup(&q->subdev.entity);
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 }
 
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 549b08f88f0c..146492383aa5 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -335,6 +335,7 @@ struct cio2_queue {
 
 	/* Subdev, /dev/v4l-subdevX */
 	struct v4l2_subdev subdev;
+	struct mutex subdev_lock; /* Serialise acces to subdev_fmt field */
 	struct media_pad subdev_pads[CIO2_PADS];
 	struct v4l2_mbus_framefmt subdev_fmt;
 	atomic_t frame_sequence;
