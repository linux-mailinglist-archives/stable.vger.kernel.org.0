Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1045F54168C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376950AbiFGUx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378825AbiFGUwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3626552;
        Tue,  7 Jun 2022 11:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E8D461696;
        Tue,  7 Jun 2022 18:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE448C385A2;
        Tue,  7 Jun 2022 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627392;
        bh=kyppX3RtOX+tPA3S0lL6Sx+Sk8H5k9jY1fHS1FvaZCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikbPEBebswI6Ui7TAO3YYRZ6jBRDsVXOjAsATy8zDR3m7GExjk4mevQgs2497eUtM
         OjY6dMEuPscT2shiaEgasIkqVXeWY8+uLfBN7zorUfR0z5FlAKQJ0OESue3oU6e6qx
         N/Xk1nqC1qM9ccDYGgiLMTAIjGUDJdq10G2fcAqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.17 722/772] iommu/dma: Fix iova map result check bug
Date:   Tue,  7 Jun 2022 19:05:14 +0200
Message-Id: <20220607165010.315631866@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

commit a3884774d731f03d3a3dd4fb70ec2d9341ceb39d upstream.

The data type of the return value of the iommu_map_sg_atomic
is ssize_t, but the data type of iova size is size_t,
e.g. one is int while the other is unsigned int.

When iommu_map_sg_atomic return value is compared with iova size,
it will force the signed int to be converted to unsigned int, if
iova map fails and iommu_map_sg_atomic return error code is less
than 0, then (ret < iova_len) is false, which will to cause not
do free iova, and the master can still successfully get the iova
of map fail, which is not expected.

Therefore, we need to check the return value of iommu_map_sg_atomic
in two cases according to whether it is less than 0.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.15.*
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20220507085204.16914-1-yf.wang@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -772,6 +772,7 @@ static struct page **__iommu_dma_alloc_n
 	unsigned int count, min_size, alloc_sizes = domain->pgsize_bitmap;
 	struct page **pages;
 	dma_addr_t iova;
+	ssize_t ret;
 
 	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
 	    iommu_deferred_attach(dev, domain))
@@ -809,8 +810,8 @@ static struct page **__iommu_dma_alloc_n
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	if (iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot)
-			< size)
+	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
 	sgt->sgl->dma_address = iova;
@@ -1207,7 +1208,7 @@ static int iommu_dma_map_sg(struct devic
 	 * implementation - it knows better than we do.
 	 */
 	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
-	if (ret < iova_len)
+	if (ret < 0 || ret < iova_len)
 		goto out_free_iova;
 
 	return __finalise_sg(dev, sg, nents, iova);


