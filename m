Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B894493CF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfFQVZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729704AbfFQVZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C58520657;
        Mon, 17 Jun 2019 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806730;
        bh=fAdnBziSJffBYuKkdBsMDxs4Ewy2DtT/7aKScd6MlMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rABUamYi/fgyR8G6nFxht1hSa7VewI/iA4uHG6CDrFJAh88t4ZyvpdaCWjUNyd8vc
         dDtSXLhAWXiTOCHvMgt2rEP/FSF4TvBEUU5MvAW8jTie7oKLquTju1go4LA7NKXLgB
         32tJF5GMqZDOpqwLzZaUvU6fxyMB2VZGgqWLlOXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/75] arm64/mm: Inhibit huge-vmap with ptdump
Date:   Mon, 17 Jun 2019 23:09:49 +0200
Message-Id: <20190617210754.255442955@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



