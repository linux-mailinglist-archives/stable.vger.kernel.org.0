Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04692B6430
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733051AbgKQNiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733045AbgKQNiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23484246AB;
        Tue, 17 Nov 2020 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620296;
        bh=050kAai3rGkvt0932R2moPRhv1QradTBEV+TlPQtElA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jNLsVseTVv2Bvv/WmJBtp4rgE354jndcxtvGSl9pzpvN8cuVzYMdBgEJvd7E7VhO
         3WkZ3jnSH64aoIJ4keS04T/rzRNp2wab+QmWWiu47XgPxJVfVVkhcklCwY730Tvdzq
         vZsJPRh1nZx/85EryWC+FDWemH0JIQBmNbl/vob4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 172/255] arm64/mm: Validate hotplug range before creating linear mapping
Date:   Tue, 17 Nov 2020 14:05:12 +0100
Message-Id: <20201117122147.296989748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 58284a901b426e6130672e9f14c30dfd5a9dbde0 ]

During memory hotplug process, the linear mapping should not be created for
a given memory range if that would fall outside the maximum allowed linear
range. Else it might cause memory corruption in the kernel virtual space.

Maximum linear mapping region is [PAGE_OFFSET..(PAGE_END -1)] accommodating
both its ends but excluding PAGE_END. Max physical range that can be mapped
inside this linear mapping range, must also be derived from its end points.

This ensures that arch_add_memory() validates memory hot add range for its
potential linear mapping requirements, before creating it with
__create_pgd_mapping().

Fixes: 4ab215061554 ("arm64: Add memory hotplug support")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/1605252614-761-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 75df62fea1b68..a834e7fb0e250 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1433,11 +1433,28 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
 	free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
 }
 
+static bool inside_linear_region(u64 start, u64 size)
+{
+	/*
+	 * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
+	 * accommodating both its ends but excluding PAGE_END. Max physical
+	 * range which can be mapped inside this linear mapping range, must
+	 * also be derived from its end points.
+	 */
+	return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
+	       (start + size - 1) <= __pa(PAGE_END - 1);
+}
+
 int arch_add_memory(int nid, u64 start, u64 size,
 		    struct mhp_params *params)
 {
 	int ret, flags = 0;
 
+	if (!inside_linear_region(start, size)) {
+		pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
+		return -EINVAL;
+	}
+
 	if (rodata_full || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
-- 
2.27.0



