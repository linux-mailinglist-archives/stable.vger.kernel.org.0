Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C88206325
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389321AbgFWUSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389624AbgFWUSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 639882080C;
        Tue, 23 Jun 2020 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943482;
        bh=BArVR45chIw1X4upIIFTauSanWQ6flRGPdm8KKvSDbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWLQMZVxz0nMfdtr5zFUTWD36vtw5JRMED0Qvqr2nalSW0ZhZ17YU8GRnF2CtKc2K
         YFh/M5LTjcu+XIredrVS41k2yWLVmbVuCffWOn4G7sUuKnbBzo8DqITHA/N/CE5VnZ
         bPF+DCYmncA6JHkvanCwjDrv2tMSYnq5NnVHgJoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Barry Song <song.bao.hua@hisilicon.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Roman Gushchin <guro@fb.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 410/477] arm64: mm: reserve hugetlb CMA after numa_init
Date:   Tue, 23 Jun 2020 21:56:47 +0200
Message-Id: <20200623195426.909259529@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>

[ Upstream commit 618e07865b7453d02410c1f3407c2d78a670eabb ]

hugetlb_cma_reserve() is called at the wrong place. numa_init has not been
done yet. so all reserved memory will be located at node0.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200617215828.25296-1-song.bao.hua@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/init.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index e42727e3568ea..3f90101674687 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -458,11 +458,6 @@ void __init arm64_memblock_init(void)
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 
 	dma_contiguous_reserve(arm64_dma32_phys_limit);
-
-#ifdef CONFIG_ARM64_4K_PAGES
-	hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-#endif
-
 }
 
 void __init bootmem_init(void)
@@ -478,6 +473,16 @@ void __init bootmem_init(void)
 	min_low_pfn = min;
 
 	arm64_numa_init();
+
+	/*
+	 * must be done after arm64_numa_init() which calls numa_init() to
+	 * initialize node_online_map that gets used in hugetlb_cma_reserve()
+	 * while allocating required CMA size across online nodes.
+	 */
+#ifdef CONFIG_ARM64_4K_PAGES
+	hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+#endif
+
 	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
 	 * done after the fixed reservations.
-- 
2.25.1



