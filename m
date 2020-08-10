Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3792E240A43
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgHJPju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgHJPYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6285422D0B;
        Mon, 10 Aug 2020 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073059;
        bh=FbtP47wd6gzV5EuJoa/g18rqPUV+zFw4F8vtAMVqD6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCxDf6NXCaDI3ECig9NPLXSFk5pzTuBkTioDJzUA8LXTHNu3PyY/CiTrYdm2jGRLN
         JEWqHULXg0jsRhwWxMM5EpYK2dS4o744Cy9bhNIyDbgGdU6hZl4+A4BKI8ROkSuvCH
         /3Q3R13Oqe4V2C3eePalv8AkD9sLTpXM3z777dSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 53/79] Revert "powerpc/kasan: Fix shadow pages allocation failure"
Date:   Mon, 10 Aug 2020 17:21:12 +0200
Message-Id: <20200810151814.869408006@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit b506923ee44ae87fc9f4de16b53feb313623e146 upstream.

This reverts commit d2a91cef9bbdeb87b7449fdab1a6be6000930210.

This commit moved too much work in kasan_init(). The allocation
of shadow pages has to be moved for the reason explained in that
patch, but the allocation of page tables still need to be done
before switching to the final hash table.

First revert the incorrect commit, following patch redoes it
properly.

Fixes: d2a91cef9bbd ("powerpc/kasan: Fix shadow pages allocation failure")
Cc: stable@vger.kernel.org
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208181
Link: https://lore.kernel.org/r/3667deb0911affbf999b99f87c31c77d5e870cd2.1593690707.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/kasan.h      |    2 ++
 arch/powerpc/mm/init_32.c             |    2 ++
 arch/powerpc/mm/kasan/kasan_init_32.c |    4 +---
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/kasan.h
+++ b/arch/powerpc/include/asm/kasan.h
@@ -27,10 +27,12 @@
 
 #ifdef CONFIG_KASAN
 void kasan_early_init(void);
+void kasan_mmu_init(void);
 void kasan_init(void);
 void kasan_late_init(void);
 #else
 static inline void kasan_init(void) { }
+static inline void kasan_mmu_init(void) { }
 static inline void kasan_late_init(void) { }
 #endif
 
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -170,6 +170,8 @@ void __init MMU_init(void)
 	btext_unmap();
 #endif
 
+	kasan_mmu_init();
+
 	setup_kup();
 
 	/* Shortly after that, the entire linear mapping will be available */
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -131,7 +131,7 @@ static void __init kasan_unmap_early_sha
 	flush_tlb_kernel_range(k_start, k_end);
 }
 
-static void __init kasan_mmu_init(void)
+void __init kasan_mmu_init(void)
 {
 	int ret;
 	struct memblock_region *reg;
@@ -159,8 +159,6 @@ static void __init kasan_mmu_init(void)
 
 void __init kasan_init(void)
 {
-	kasan_mmu_init();
-
 	kasan_remap_early_shadow_ro();
 
 	clear_page(kasan_early_shadow_page);


