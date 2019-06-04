Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29A35343
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfFDXYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfFDXYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E054D206C1;
        Tue,  4 Jun 2019 23:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690642;
        bh=xOZ0woNZrYIRIQxXatR0bT/VmUvx27He7Ir6yZ9K4ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4l1kx45VawjCLyEJxsgi121B1RbJOkhcfkcX9cbR04YiDDO2IinfT//vFS4PCIYu
         t2UjHOukHaSjUSEt/AGFjIK6cREI/VNzURlzCDc/+7enDhhYfg/d/MJ9rLOf2Rf4ow
         OPb0h5OJg4+PAWTWexWNw3A2cPPPsk5eEuSCLCUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 16/36] arm64/mm: Inhibit huge-vmap with ptdump
Date:   Tue,  4 Jun 2019 19:23:11 -0400
Message-Id: <20190604232333.7185-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232333.7185-1-sashal@kernel.org>
References: <20190604232333.7185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 7ba36eccb3f83983a651efd570b4f933ecad1b5c ]

The arm64 ptdump code can race with concurrent modification of the
kernel page tables. At the time this was added, this was sound as:

* Modifications to leaf entries could result in stale information being
  logged, but would not result in a functional problem.

* Boot time modifications to non-leaf entries (e.g. freeing of initmem)
  were performed when the ptdump code cannot be invoked.

* At runtime, modifications to non-leaf entries only occurred in the
  vmalloc region, and these were strictly additive, as intermediate
  entries were never freed.

However, since commit:

  commit 324420bf91f6 ("arm64: add support for ioremap() block mappings")

... it has been possible to create huge mappings in the vmalloc area at
runtime, and as part of this existing intermediate levels of table my be
removed and freed.

It's possible for the ptdump code to race with this, and continue to
walk tables which have been freed (and potentially poisoned or
reallocated). As a result of this, the ptdump code may dereference bogus
addresses, which could be fatal.

Since huge-vmap is a TLB and memory optimization, we can disable it when
the runtime ptdump code is in use to avoid this problem.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 324420bf91f60582 ("arm64: add support for ioremap() block mappings")
Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 8080c9f489c3..0fa558176fb1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -921,13 +921,18 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 
 int __init arch_ioremap_pud_supported(void)
 {
-	/* only 4k granule supports level 1 block mappings */
-	return IS_ENABLED(CONFIG_ARM64_4K_PAGES);
+	/*
+	 * Only 4k granule supports level 1 block mappings.
+	 * SW table walks can't handle removal of intermediate entries.
+	 */
+	return IS_ENABLED(CONFIG_ARM64_4K_PAGES) &&
+	       !IS_ENABLED(CONFIG_ARM64_PTDUMP_DEBUGFS);
 }
 
 int __init arch_ioremap_pmd_supported(void)
 {
-	return 1;
+	/* See arch_ioremap_pud_supported() */
+	return !IS_ENABLED(CONFIG_ARM64_PTDUMP_DEBUGFS);
 }
 
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
-- 
2.20.1

