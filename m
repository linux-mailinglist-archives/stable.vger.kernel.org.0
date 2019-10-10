Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1EAD25D3
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387706AbfJJIiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387635AbfJJIiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6E620B7C;
        Thu, 10 Oct 2019 08:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696729;
        bh=7ICmKWHcVsxa7fjU9//oUnyZkEX5xHC61tndE/5jLus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAMDi4lFgVBRQs4zophgeUB1/Uoztx86N0RZDTuJ0BT0GygFwzx50G+NPtN6J51kn
         dJ+sm9Rmb/2bnVwxgPdcqT6Jo8ZAxdtJJyscuE4jsP41EHg0w+MtWvg9chVEeusz7I
         XFWbSvm2BAsx45KAXrFyvGuVovh9yX5R9afwci7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 030/148] powerpc/kasan: Fix parallel loading of modules.
Date:   Thu, 10 Oct 2019 10:34:51 +0200
Message-Id: <20191010083612.957788488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 45ff3c55958542c3b76075d59741297b8cb31cbb upstream.

Parallel loading of modules may lead to bad setup of shadow page table
entries.

First, lets align modules so that two modules never share the same
shadow page.

Second, ensure that two modules cannot allocate two page tables for
the same PMD entry at the same time. This is done by using
init_mm.page_table_lock in the same way as __pte_alloc_kernel()

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c97284f912128cbc3f2fe09d68e90e65fb3e6026.1565361876.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/kasan/kasan_init_32.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -5,6 +5,7 @@
 #include <linux/kasan.h>
 #include <linux/printk.h>
 #include <linux/memblock.h>
+#include <linux/moduleloader.h>
 #include <linux/sched/task.h>
 #include <linux/vmalloc.h>
 #include <asm/pgalloc.h>
@@ -46,7 +47,19 @@ static int __ref kasan_init_shadow_page_
 			kasan_populate_pte(new, PAGE_READONLY);
 		else
 			kasan_populate_pte(new, PAGE_KERNEL_RO);
-		pmd_populate_kernel(&init_mm, pmd, new);
+
+		smp_wmb(); /* See comment in __pte_alloc */
+
+		spin_lock(&init_mm.page_table_lock);
+			/* Has another populated it ? */
+		if (likely((void *)pmd_page_vaddr(*pmd) == kasan_early_shadow_pte)) {
+			pmd_populate_kernel(&init_mm, pmd, new);
+			new = NULL;
+		}
+		spin_unlock(&init_mm.page_table_lock);
+
+		if (new && slab_is_available())
+			pte_free_kernel(&init_mm, new);
 	}
 	return 0;
 }
@@ -137,7 +150,11 @@ void __init kasan_init(void)
 #ifdef CONFIG_MODULES
 void *module_alloc(unsigned long size)
 {
-	void *base = vmalloc_exec(size);
+	void *base;
+
+	base = __vmalloc_node_range(size, MODULE_ALIGN, VMALLOC_START, VMALLOC_END,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
+				    NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!base)
 		return NULL;


