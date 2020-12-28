Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223D52E432A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407053AbgL1Pdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407285AbgL1NxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C9721D94;
        Mon, 28 Dec 2020 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163555;
        bh=8W7/UbKT4IKzBx2mjAVno5Z6ewQ4qx+xBS0ILnnNQFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLErrBNiGI9yeBVeBAJeq8pd7POFeCjyuDBxFHQQQTMfZ8amGqCXXdj4phDa1YuTk
         dpmo3QYxG948WlzsB5yJGg/vC8Gk34Espc4r47KGTPA9QRPUQ5sDAlJaIi6K66WmuB
         shXpGtTI1S6ozBSozeBO5L5Z6WoOTeyIBW6HHP8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 326/453] media: ipu3-cio2: Serialise access to pad format
Date:   Mon, 28 Dec 2020 13:49:22 +0100
Message-Id: <20201228124952.897283258@linuxfoundation.org>
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

commit 55a6c6b2be3d6670bf5772364d8208bd8dc17da4 upstream.

Pad format can be accessed from user space. Serialise access to it.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |   11 +++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h |    1 +
 2 files changed, 12 insertions(+)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1245,11 +1245,15 @@ static int cio2_subdev_get_fmt(struct v4
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
 
@@ -1273,6 +1277,8 @@ static int cio2_subdev_set_fmt(struct v4
 	if (fmt->pad == CIO2_PAD_SOURCE)
 		return cio2_subdev_get_fmt(sd, cfg, fmt);
 
+	mutex_lock(&q->subdev_lock);
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
 	} else {
@@ -1283,6 +1289,8 @@ static int cio2_subdev_set_fmt(struct v4
 		fmt->format = q->subdev_fmt;
 	}
 
+	mutex_unlock(&q->subdev_lock);
+
 	return 0;
 }
 
@@ -1541,6 +1549,7 @@ static int cio2_queue_init(struct cio2_d
 
 	/* Initialize miscellaneous variables */
 	mutex_init(&q->lock);
+	mutex_init(&q->subdev_lock);
 
 	/* Initialize formats to default values */
 	fmt = &q->subdev_fmt;
@@ -1659,6 +1668,7 @@ fail_vdev_media_entity:
 fail_subdev_media_entity:
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
 fail_fbpt:
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 
 	return r;
@@ -1672,6 +1682,7 @@ static void cio2_queue_exit(struct cio2_
 	v4l2_device_unregister_subdev(&q->subdev);
 	media_entity_cleanup(&q->subdev.entity);
 	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
+	mutex_destroy(&q->subdev_lock);
 	mutex_destroy(&q->lock);
 }
 
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -332,6 +332,7 @@ struct cio2_queue {
 
 	/* Subdev, /dev/v4l-subdevX */
 	struct v4l2_subdev subdev;
+	struct mutex subdev_lock; /* Serialise acces to subdev_fmt field */
 	struct media_pad subdev_pads[CIO2_PADS];
 	struct v4l2_mbus_framefmt subdev_fmt;
 	atomic_t frame_sequence;


