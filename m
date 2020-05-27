Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49221E3BDC
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgE0IXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:23:49 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56940 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgE0IXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:23:49 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04R8NhfD055005;
        Wed, 27 May 2020 03:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590567823;
        bh=GyTLg1Md2fYLJ6g5xaEEx7UWj2p3nMkQ9a8MM4uR48U=;
        h=From:To:CC:Subject:Date;
        b=sE29BLQ+N9saDCTgZSfSg3ULjDAe4yAjvivJa6mD/EPicuCXm43YPGY0j/i002rhA
         4UVpw9YOZZPeT1Lxo+x0s+KvOeh5kDHB/qQ1dO6S5FIc/DA26B1OkTYC66aQcHBf52
         o+4S25WdmoGvBM+qhZLLVi1WocFzeEudHyTLzxKI=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04R8Nhfv098062
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 03:23:43 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 03:23:43 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 03:23:43 -0500
Received: from deskari.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04R8NfcE106256;
        Wed, 27 May 2020 03:23:41 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCHv2] media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size
Date:   Wed, 27 May 2020 11:23:34 +0300
Message-ID: <20200527082334.20774-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Changes in v2:
* vb2_dma_contig_clear_max_seg_size to empty static inline
* Added cc: stable and fixes tag

 .../common/videobuf2/videobuf2-dma-contig.c   | 20 ++-----------------
 include/media/videobuf2-dma-contig.h          |  2 +-
 2 files changed, 3 insertions(+), 19 deletions(-)

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
 
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

