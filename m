Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7DC541E70
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352733AbiFGWcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382072AbiFGW3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:29:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE9227237D;
        Tue,  7 Jun 2022 12:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377A0B823D8;
        Tue,  7 Jun 2022 19:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881D4C385A5;
        Tue,  7 Jun 2022 19:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629813;
        bh=esTM9CTG9/DjUAGs0V6KSfVymumew+ALHoZY1k8oq6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3O9tML2WgKQHTOpZBGYaedjhrsqRR3jtTLdxX7TwcyksNZkkH9PA7LnaLupWIDAQ
         ryJH+XdlNjXldooLISZ1uODgTUDuP+HvOriS9baOOR6D3rdwXJu1ne+doSLBt+If1I
         r5cvdEkdRNKWR4Lj+R3xN3KtBMjxKx2j9biSQLpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.18 826/879] iommu/dma: Fix iova map result check bug
Date:   Tue,  7 Jun 2022 19:05:44 +0200
Message-Id: <20220607165026.829945432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -776,6 +776,7 @@ static struct page **__iommu_dma_alloc_n
 	unsigned int count, min_size, alloc_sizes = domain->pgsize_bitmap;
 	struct page **pages;
 	dma_addr_t iova;
+	ssize_t ret;
 
 	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
 	    iommu_deferred_attach(dev, domain))
@@ -813,8 +814,8 @@ static struct page **__iommu_dma_alloc_n
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	if (iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot)
-			< size)
+	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
 	sgt->sgl->dma_address = iova;
@@ -1209,7 +1210,7 @@ static int iommu_dma_map_sg(struct devic
 	 * implementation - it knows better than we do.
 	 */
 	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
-	if (ret < iova_len)
+	if (ret < 0 || ret < iova_len)
 		goto out_free_iova;
 
 	return __finalise_sg(dev, sg, nents, iova);


