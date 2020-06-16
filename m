Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D275B1FB7AC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgFPPsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbgFPPsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122C321475;
        Tue, 16 Jun 2020 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322498;
        bh=31K/xXAjmx9ivj+GVlLUEC+9mIQeg4WPdAZ970qHfUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUwaG9AGeRVmtBZg112eP7ekZpt05tEr/Kc7tgHrPKzqFbyqnQ1i+983zoMzzSbUx
         bk+tow5QfDvZxUW4Rh/6ID17lQNYI0feiXAmTEOWDpwtk24fqiztgXKb4Xrm6ExX2H
         1p9/8AyOFu9mCmhXkxd6Ok27iYSLiBNz88QguD2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.7 126/163] media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size
Date:   Tue, 16 Jun 2020 17:35:00 +0200
Message-Id: <20200616153112.850479071@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 0d9668721311607353d4861e6c32afeb272813dc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/common/videobuf2/videobuf2-dma-contig.c |   20 +-----------------
 include/media/videobuf2-dma-contig.h                  |    2 -
 2 files changed, 3 insertions(+), 19 deletions(-)

--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -726,9 +726,8 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops)
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
@@ -737,21 +736,6 @@ int vb2_dma_contig_set_max_seg_size(stru
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
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -25,7 +25,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2
 }
 
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
-void vb2_dma_contig_clear_max_seg_size(struct device *dev);
+static inline void vb2_dma_contig_clear_max_seg_size(struct device *dev) { }
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
 


