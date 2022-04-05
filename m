Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875624F3A21
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379183AbiDELka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354452AbiDEKOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C2269CF7;
        Tue,  5 Apr 2022 03:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C76E6B81C8B;
        Tue,  5 Apr 2022 10:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9CC385A2;
        Tue,  5 Apr 2022 09:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152800;
        bh=/MJv/HabMeOOpo77f3rdPIfuw68ubruu6J3fo5Cw0l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voA7g3ChMYy3zZ5auKW6pp10bxNptr7lt68VpgA/86hxiz0uZ7pyJY4fp/hDDOVdk
         fV5cbJhwqi/Xu8fh9kAMtdnU9adh6cCPpP7ol3Zae1PnLDH77LrD9v5TN8UoMGBCny
         jdnEgz+x4gbTn41WT+c3rc7m4+l9dsllzEnOMm2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 905/913] iommu/dma: Skip extra sync during unmap w/swiotlb
Date:   Tue,  5 Apr 2022 09:32:47 +0200
Message-Id: <20220405070406.946278545@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

commit ee9d4097cc145dcaebedf6b113d17c91c21333a0 upstream.

Calling the iommu_dma_sync_*_for_cpu functions during unmap can cause
two copies out of the swiotlb buffer. Do the arch sync directly in
__iommu_dma_unmap_swiotlb instead to avoid this. This makes the call to
iommu_dma_sync_sg_for_cpu for untrusted devices in iommu_dma_unmap_sg no
longer necessary, so move that invocation later in the function.

Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20210929023300.335969-4-stevensd@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -521,6 +521,9 @@ static void __iommu_dma_unmap_swiotlb(st
 	if (WARN_ON(!phys))
 		return;
 
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) && !dev_is_dma_coherent(dev))
+		arch_sync_dma_for_cpu(phys, size, dir);
+
 	__iommu_dma_unmap(dev, dma_addr, size);
 
 	if (unlikely(is_swiotlb_buffer(dev, phys)))
@@ -871,8 +874,6 @@ static dma_addr_t iommu_dma_map_page(str
 static void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		iommu_dma_sync_single_for_cpu(dev, dma_handle, size, dir);
 	__iommu_dma_unmap_swiotlb(dev, dma_handle, size, dir, attrs);
 }
 
@@ -1089,14 +1090,14 @@ static void iommu_dma_unmap_sg(struct de
 	struct scatterlist *tmp;
 	int i;
 
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		iommu_dma_sync_sg_for_cpu(dev, sg, nents, dir);
-
 	if (dev_is_untrusted(dev)) {
 		iommu_dma_unmap_sg_swiotlb(dev, sg, nents, dir, attrs);
 		return;
 	}
 
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		iommu_dma_sync_sg_for_cpu(dev, sg, nents, dir);
+
 	/*
 	 * The scatterlist segments are mapped into a single
 	 * contiguous IOVA allocation, so this is incredibly easy.


