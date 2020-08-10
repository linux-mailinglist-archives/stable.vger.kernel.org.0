Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70DB240888
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgHJPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgHJPUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621AB2065D;
        Mon, 10 Aug 2020 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072831;
        bh=9S8YiSc3vW1bhf2xH176cs4MfoTmSUmDo6XkcRs+yRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00tdQgL/IFvnmnx94OukjjEEnEww8+SRvkLPFb+72wl0DN5+l4tNMg5KKrPvrf0eK
         4h5ML2yAig/dawBPY99xpXVxl7UDKZ8C8tQ0EMFckbqA0/9GYW6x+7JYHyg5TRWMgm
         /0G+7/AjhMIbLUdJ88D/iDWysJVcUhBnwzhT6it4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.8 33/38] powerpc/kasan: Fix shadow pages allocation failure
Date:   Mon, 10 Aug 2020 17:19:23 +0200
Message-Id: <20200810151805.545372811@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 41ea93cf7ba4e0f0cc46ebfdda8b6ff27c67bc91 upstream.

Doing kasan pages allocation in MMU_init is too early, kernel doesn't
have access yet to the entire memory space and memblock_alloc() fails
when the kernel is a bit big.

Do it from kasan_init() instead.

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Fixes: d2a91cef9bbd ("powerpc/kasan: Fix shadow pages allocation failure")
Cc: stable@vger.kernel.org
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208181
Link: https://lore.kernel.org/r/63048fcea8a1c02f75429ba3152f80f7853f87fc.1593690707.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/kasan/kasan_init_32.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -120,11 +120,24 @@ static void __init kasan_unmap_early_sha
 void __init kasan_mmu_init(void)
 {
 	int ret;
+
+	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
+	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
+
+		if (ret)
+			panic("kasan: kasan_init_shadow_page_tables() failed");
+	}
+}
+
+void __init kasan_init(void)
+{
 	struct memblock_region *reg;
 
 	for_each_memblock(memory, reg) {
 		phys_addr_t base = reg->base;
 		phys_addr_t top = min(base + reg->size, total_lowmem);
+		int ret;
 
 		if (base >= top)
 			continue;
@@ -134,18 +147,6 @@ void __init kasan_mmu_init(void)
 			panic("kasan: kasan_init_region() failed");
 	}
 
-	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
-	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
-		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
-
-		if (ret)
-			panic("kasan: kasan_init_shadow_page_tables() failed");
-	}
-
-}
-
-void __init kasan_init(void)
-{
 	kasan_remap_early_shadow_ro();
 
 	clear_page(kasan_early_shadow_page);


