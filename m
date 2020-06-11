Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE11F6CF8
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgFKRqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 13:46:23 -0400
Received: from www.linuxtv.org ([130.149.80.248]:39682 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgFKRqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 13:46:23 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2020 13:46:22 EDT
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jjQqY-008qsA-IG; Thu, 11 Jun 2020 17:18:34 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 11 Jun 2020 17:20:55 +0000
Subject: [git:media_tree/master] media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size
To:     linuxtv-commits@linuxtv.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jjQqY-008qsA-IG@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size
Author:  Tomi Valkeinen <tomi.valkeinen@ti.com>
Date:    Wed May 27 10:23:34 2020 +0200

Commit 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd ("driver core: platform:
Initialize dma_parms for platform devices") in v5.7-rc5 causes
vb2_dma_contig_clear_max_seg_size() to kfree memory that was not
allocated by vb2_dma_contig_set_max_seg_size().

The assumption in vb2_dma_contig_set_max_seg_size() seems to be that
dev->dma_parms is always NULL when the driver is probed, and the case
where dev->dma_parms has bee initialized by someone else than the driver
(by calling vb2_dma_contig_set_max_seg_size) will cause a failure.

All the current users of these functions are platform devices, which now
always have dma_parms set by the driver core. To fix the issue for v5.7,
make vb2_dma_contig_set_max_seg_size() return an error if dma_parms is
NULL to be on the safe side, and remove the kfree code from
vb2_dma_contig_clear_max_seg_size().

For v5.8 we should remove the two functions and move the
dma_set_max_seg_size() calls into the drivers.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: 9495b7e92f71 ("driver core: platform: Initialize dma_parms for platform devices")
Cc: stable@vger.kernel.org
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 .../media/common/videobuf2/videobuf2-dma-contig.c    | 20 ++------------------
 include/media/videobuf2-dma-contig.h                 |  2 +-
 2 files changed, 3 insertions(+), 19 deletions(-)

---

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index d3a3ee5b597b..f4b4a7c135eb 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -726,9 +726,8 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
 {
 	if (!dev->dma_parms) {
-		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
-		if (!dev->dma_parms)
-			return -ENOMEM;
+		dev_err(dev, "Failed to set max_seg_size: dma_parms is NULL\n");
+		return -ENODEV;
 	}
 	if (dma_get_max_seg_size(dev) < size)
 		return dma_set_max_seg_size(dev, size);
@@ -737,21 +736,6 @@ int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
 
-/*
- * vb2_dma_contig_clear_max_seg_size() - release resources for DMA parameters
- * @dev:	device for configuring DMA parameters
- *
- * This function releases resources allocated to configure DMA parameters
- * (see vb2_dma_contig_set_max_seg_size() function). It should be called from
- * device drivers on driver remove.
- */
-void vb2_dma_contig_clear_max_seg_size(struct device *dev)
-{
-	kfree(dev->dma_parms);
-	dev->dma_parms = NULL;
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_clear_max_seg_size);
-
 MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 5604818d137e..5be313cbf7d7 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -25,7 +25,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 }
 
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
-void vb2_dma_contig_clear_max_seg_size(struct device *dev);
+static inline void vb2_dma_contig_clear_max_seg_size(struct device *dev) { }
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
 
