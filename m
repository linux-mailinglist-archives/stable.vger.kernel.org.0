Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1D45E53F
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357955AbhKZClM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245108AbhKZCjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D8D861214;
        Fri, 26 Nov 2021 02:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894029;
        bh=qLE1sVRzJypqraWu05K6YqnHauSd7DGbUmMaCeixQhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmOamxuDPzUELf8MUbjWa7y3dejW60qmBhxaENnKukWsaKxiNtwEmNsot+ym10Mqz
         svFPNLEUQeXIt+8UcnKINwuL5qfADXzg53aOufdQ2QbNBfQ4AjXdzmKH4Iysxp54iF
         tcAKsKc9chuMiaHqu7P+mcUHFUU51MSNLSQQtIXKDJkQ1DudcVtfpuwLqPjMzi8f7d
         jlSbKMazw1vtGMckUOr0qmyYafHz5lmZ2SnS91Oeq9eAuU1jUbMJ+psA5eB53DJID8
         /pPH7ZavOvbGTRJoBEaJC0x5poOUecNBbxK/RhaycJKf3V/C8CAmUjBSQDJ64TVYis
         n0va6S33ZoImg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, leobras.c@gmail.com,
        fbarrat@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 03/28] powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"
Date:   Thu, 25 Nov 2021 21:33:18 -0500
Message-Id: <20211126023343.442045-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 2d33f5504490a9d90924476dbccd4a5349ee1ad0 ]

This reverts commit 54fc3c681ded9437e4548e2501dc1136b23cfa9a
which does not allow 1:1 mapping even for the system RAM which
is usually possible.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211108040320.3857636-2-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index e4198700ed1a3..245f1f8df6563 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1034,15 +1034,6 @@ static phys_addr_t ddw_memory_hotplug_max(void)
 	phys_addr_t max_addr = memory_hotplug_max();
 	struct device_node *memory;
 
-	/*
-	 * The "ibm,pmemory" can appear anywhere in the address space.
-	 * Assuming it is still backed by page structs, set the upper limit
-	 * for the huge DMA window as MAX_PHYSMEM_BITS.
-	 */
-	if (of_find_node_by_type(NULL, "ibm,pmemory"))
-		return (sizeof(phys_addr_t) * 8 <= MAX_PHYSMEM_BITS) ?
-			(phys_addr_t) -1 : (1ULL << MAX_PHYSMEM_BITS);
-
 	for_each_node_by_type(memory, "memory") {
 		unsigned long start, size;
 		int n_mem_addr_cells, n_mem_size_cells, len;
-- 
2.33.0

