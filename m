Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556CF6A09E1
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjBWNKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbjBWNKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:10:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277655679C
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48FC461705
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E30CC433D2;
        Thu, 23 Feb 2023 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157831;
        bh=W7EjpS12SgHwg9K5ZJim6bPmgiLsUOwq1yUclKif894=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUbtJ3Gto5RP+tJl4zukx708Rdj1Yb9ctwK9fmUcIlu+tJgVClqLcMRPT/Ucl/HcK
         cvUCurVSDeSwCxER7imrfV1zCH0y1kVUID8Gxlu4B1jaj010gAg9W0hpdxTE3I9F3i
         Y6Np9kq0VlL3GrbOemA8ah0W1nJCDde4iPOcm0/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/18] dma-mapping: add generic helpers for mapping sgtable objects
Date:   Thu, 23 Feb 2023 14:06:46 +0100
Message-Id: <20230223130425.748248216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit d9d200bcebc1f6e56f0178cbb8db9953e8cc9a11 ]

struct sg_table is a common structure used for describing a memory
buffer. It consists of a scatterlist with memory pages and DMA addresses
(sgl entry), as well as the number of scatterlist entries: CPU pages
(orig_nents entry) and DMA mapped pages (nents entry).

It turned out that it was a common mistake to misuse nents and orig_nents
entries, calling DMA-mapping functions with a wrong number of entries or
ignoring the number of mapped entries returned by the dma_map_sg
function.

To avoid such issues, let's introduce a common wrappers operating
directly on the struct sg_table objects, which take care of the proper
use of the nents and orig_nents entries.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: d37c120b7312 ("drm/etnaviv: don't truncate physical page address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-mapping.h | 80 +++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4d450672b7d66..87cbae4b051f1 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -612,6 +612,86 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 	return dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
+/**
+ * dma_map_sgtable - Map the given buffer for DMA
+ * @dev:	The device for which to perform the DMA operation
+ * @sgt:	The sg_table object describing the buffer
+ * @dir:	DMA direction
+ * @attrs:	Optional DMA attributes for the map operation
+ *
+ * Maps a buffer described by a scatterlist stored in the given sg_table
+ * object for the @dir DMA operation by the @dev device. After success the
+ * ownership for the buffer is transferred to the DMA domain.  One has to
+ * call dma_sync_sgtable_for_cpu() or dma_unmap_sgtable() to move the
+ * ownership of the buffer back to the CPU domain before touching the
+ * buffer by the CPU.
+ *
+ * Returns 0 on success or -EINVAL on error during mapping the buffer.
+ */
+static inline int dma_map_sgtable(struct device *dev, struct sg_table *sgt,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+	int nents;
+
+	nents = dma_map_sg_attrs(dev, sgt->sgl, sgt->orig_nents, dir, attrs);
+	if (nents <= 0)
+		return -EINVAL;
+	sgt->nents = nents;
+	return 0;
+}
+
+/**
+ * dma_unmap_sgtable - Unmap the given buffer for DMA
+ * @dev:	The device for which to perform the DMA operation
+ * @sgt:	The sg_table object describing the buffer
+ * @dir:	DMA direction
+ * @attrs:	Optional DMA attributes for the unmap operation
+ *
+ * Unmaps a buffer described by a scatterlist stored in the given sg_table
+ * object for the @dir DMA operation by the @dev device. After this function
+ * the ownership of the buffer is transferred back to the CPU domain.
+ */
+static inline void dma_unmap_sgtable(struct device *dev, struct sg_table *sgt,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+	dma_unmap_sg_attrs(dev, sgt->sgl, sgt->orig_nents, dir, attrs);
+}
+
+/**
+ * dma_sync_sgtable_for_cpu - Synchronize the given buffer for CPU access
+ * @dev:	The device for which to perform the DMA operation
+ * @sgt:	The sg_table object describing the buffer
+ * @dir:	DMA direction
+ *
+ * Performs the needed cache synchronization and moves the ownership of the
+ * buffer back to the CPU domain, so it is safe to perform any access to it
+ * by the CPU. Before doing any further DMA operations, one has to transfer
+ * the ownership of the buffer back to the DMA domain by calling the
+ * dma_sync_sgtable_for_device().
+ */
+static inline void dma_sync_sgtable_for_cpu(struct device *dev,
+		struct sg_table *sgt, enum dma_data_direction dir)
+{
+	dma_sync_sg_for_cpu(dev, sgt->sgl, sgt->orig_nents, dir);
+}
+
+/**
+ * dma_sync_sgtable_for_device - Synchronize the given buffer for DMA
+ * @dev:	The device for which to perform the DMA operation
+ * @sgt:	The sg_table object describing the buffer
+ * @dir:	DMA direction
+ *
+ * Performs the needed cache synchronization and moves the ownership of the
+ * buffer back to the DMA domain, so it is safe to perform the DMA operation.
+ * Once finished, one has to call dma_sync_sgtable_for_cpu() or
+ * dma_unmap_sgtable().
+ */
+static inline void dma_sync_sgtable_for_device(struct device *dev,
+		struct sg_table *sgt, enum dma_data_direction dir)
+{
+	dma_sync_sg_for_device(dev, sgt->sgl, sgt->orig_nents, dir);
+}
+
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, 0)
 #define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
-- 
2.39.0



