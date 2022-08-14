Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6630592379
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiHNQWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240790AbiHNQVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:21:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E737140BA;
        Sun, 14 Aug 2022 09:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE024B80B37;
        Sun, 14 Aug 2022 16:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99612C433B5;
        Sun, 14 Aug 2022 16:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660493987;
        bh=YhTyq8ztHRIzhCyqOa/NH29eSjBtsSbe0iDoCiRMWzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WROZvLWPbEYgPuUVIbZU1xgzC5SxpZ4un809HN7d5t+RZ7DYaNwdeL/c28OeTN1cN
         BppG0NIuMwiDb5QPAJwrerogDJ6x1EghhshI8+fKe3Z64Ug6U58JMIVpCLXzjLPsxr
         b0xSgV/jEL6/N+Yn6XeLfU0ou66kYU7uSegxjQN0XZ5wMft+KjHfJ6EfniCvAk0n7R
         nvE+y4IgLAeA9NPCvAEff2AcFg8BpGkRa+/ZIneEJv+YTWU5dJTKSeii0+44s4hyZw
         g5TdzOdsHRh14EpwnwQ/CJ4s7uqDOFQuQs6anJPiHTPYkjSdX+QULrssJ6EWNiSHLM
         fPJnVKdiHo4YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, hch@infradead.org,
        m.szyprowski@samsung.com, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 02/48] swiotlb: panic if nslabs is too small
Date:   Sun, 14 Aug 2022 12:18:55 -0400
Message-Id: <20220814161943.2394452-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 0bf28fc40d89b1a3e00d1b79473bad4e9ca20ad1 ]

Panic on purpose if nslabs is too small, in order to sync with the remap
retry logic.

In addition, print the number of bytes for tlb alloc failure.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index cb50f8d38360..03af7c3bee71 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -242,6 +242,9 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	if (swiotlb_force_disable)
 		return;
 
+	if (nslabs < IO_TLB_MIN_SLABS)
+		panic("%s: nslabs = %lu too small\n", __func__, nslabs);
+
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
 	 * allow to pick a location everywhere for hypervisors with guest
@@ -254,7 +257,8 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	else
 		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
 	if (!tlb) {
-		pr_warn("%s: failed to allocate tlb structure\n", __func__);
+		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
+			__func__, bytes);
 		return;
 	}
 
-- 
2.35.1

