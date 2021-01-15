Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F82F7B1D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732330AbhAOM54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733284AbhAOMd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF7923339;
        Fri, 15 Jan 2021 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714021;
        bh=QdGBz/Vky3oN2/OTnll2QfPUiJqMytbFuaokbv5SXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zC57HeNnnGwz2MmmRS9v7tgBrBfYI21aQ4qR9tUA/2HtftFMBZ0TkBVRC/vxReCBP
         amGkW9z2FfPozP1J4BqE4fB1MYcMbBUjgvptdiO+XQ38gJEf9KOMb7LEqRmUIan/fw
         K+mIDVBG/Ke22irTYAiq9PHe6E/2IWbm+kepydh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/62] vfio iommu: Add dma available capability
Date:   Fri, 15 Jan 2021 13:27:24 +0100
Message-Id: <20210115121958.517746065@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 7d6e1329652ed971d1b6e0e7bea66fba5044e271 ]

The following functional changes were needed for backport:
- vfio_iommu_type1_get_info doesn't exist, call
  vfio_iommu_dma_avail_build_caps from vfio_iommu_type1_ioctl.
- As further fallout from this, vfio_iommu_dma_avail_build_caps must
  acquire and release the iommu mutex lock.  To do so, the return value is
  stored in a local variable as in vfio_iommu_iova_build_caps.

Upstream commit description:
Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
added the ability to limit the number of memory backed DMA mappings.
However on s390x, when lazy mapping is in use, we use a very large
number of concurrent mappings.  Let's provide the current allowable
number of DMA mappings to userspace via the IOMMU info chain so that
userspace can take appropriate mitigation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 15 +++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3b31e83a92155..bc6ba41686fa3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2303,6 +2303,24 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_dma_avail_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_dma_avail cap_dma_avail;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	cap_dma_avail.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL;
+	cap_dma_avail.header.version = 1;
+
+	cap_dma_avail.avail = iommu->dma_avail;
+
+	ret = vfio_info_add_capability(caps, &cap_dma_avail.header,
+				       sizeof(cap_dma_avail));
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2349,6 +2367,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
+
+		if (!ret)
+			ret = vfio_iommu_dma_avail_build_caps(iommu, &caps);
+
 		if (ret)
 			return ret;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead0..cabc93118f9c8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -748,6 +748,21 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+/*
+ * The DMA available capability allows to report the current number of
+ * simultaneously outstanding DMA mappings that are allowed.
+ *
+ * The structure below defines version 1 of this capability.
+ *
+ * avail: specifies the current number of outstanding DMA mappings allowed.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
+
+struct vfio_iommu_type1_info_dma_avail {
+	struct	vfio_info_cap_header header;
+	__u32	avail;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.27.0



