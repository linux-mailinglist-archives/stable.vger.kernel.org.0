Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07933A03CA
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhFHTWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237954AbhFHTSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1B861001;
        Tue,  8 Jun 2021 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178295;
        bh=9J1/dpukLuQWMaWW5TRWh50vVzgLt5AVietmdb8el2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPeUv+hzfos06G3tDHDeneQSXnHtZjlRbHWzFRzDq7IBwdY0XtCb8Vbcx8zbzVc9B
         dyEPqEuVYAvvE/JsRPmVQ87yGoCSxtSCYPuzpVJ4jRsRiNwaJTPtQtA2F6Z3Q53+yq
         EEO99lvJaO8TEgtRDMv53PdSNznrLEcJrQ4FGs+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Yanjie <zhouyanjie@wanyeetech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huang Pei <huangpei@loongson.cn>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 122/161] Revert "MIPS: make userspace mapping young by default"
Date:   Tue,  8 Jun 2021 20:27:32 +0200
Message-Id: <20210608175949.567896171@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 50c25ee97cf6ab011542167ab590c17012cea4ed upstream.

This reverts commit f685a533a7fab35c5d069dcd663f59c8e4171a75.

The MIPS cache flush logic needs to know whether the mapping was already
established to decide how to flush caches.  This is done by checking the
valid bit in the PTE.  The commit above breaks this logic by setting the
valid in the PTE in new mappings, which causes kernel crashes.

Link: https://lkml.kernel.org/r/20210526094335.92948-1-tsbogend@alpha.franken.de
Fixes: f685a533a7f ("MIPS: make userspace mapping young by default")
Reported-by: Zhou Yanjie <zhouyanjie@wanyeetech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Huang Pei <huangpei@loongson.cn>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/cache.c    |   30 ++++++++++++++----------------
 include/linux/pgtable.h |    8 ++++++++
 mm/memory.c             |    4 ++++
 3 files changed, 26 insertions(+), 16 deletions(-)

--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -157,31 +157,29 @@ unsigned long _page_cachable_default;
 EXPORT_SYMBOL(_page_cachable_default);
 
 #define PM(p)	__pgprot(_page_cachable_default | (p))
-#define PVA(p)	PM(_PAGE_VALID | _PAGE_ACCESSED | (p))
 
 static inline void setup_protection_map(void)
 {
 	protection_map[0]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[1]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[2]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[3]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[4]  = PVA(_PAGE_PRESENT);
-	protection_map[5]  = PVA(_PAGE_PRESENT);
-	protection_map[6]  = PVA(_PAGE_PRESENT);
-	protection_map[7]  = PVA(_PAGE_PRESENT);
+	protection_map[1]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[2]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[3]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[4]  = PM(_PAGE_PRESENT);
+	protection_map[5]  = PM(_PAGE_PRESENT);
+	protection_map[6]  = PM(_PAGE_PRESENT);
+	protection_map[7]  = PM(_PAGE_PRESENT);
 
 	protection_map[8]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[9]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[10] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
+	protection_map[9]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[10] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
 				_PAGE_NO_READ);
-	protection_map[11] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
-	protection_map[12] = PVA(_PAGE_PRESENT);
-	protection_map[13] = PVA(_PAGE_PRESENT);
-	protection_map[14] = PVA(_PAGE_PRESENT);
-	protection_map[15] = PVA(_PAGE_PRESENT);
+	protection_map[11] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
+	protection_map[12] = PM(_PAGE_PRESENT);
+	protection_map[13] = PM(_PAGE_PRESENT);
+	protection_map[14] = PM(_PAGE_PRESENT | _PAGE_WRITE);
+	protection_map[15] = PM(_PAGE_PRESENT | _PAGE_WRITE);
 }
 
-#undef _PVA
 #undef PM
 
 void cpu_cache_init(void)
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -432,6 +432,14 @@ static inline void ptep_set_wrprotect(st
  * To be differentiate with macro pte_mkyoung, this macro is used on platforms
  * where software maintains page access bit.
  */
+#ifndef pte_sw_mkyoung
+static inline pte_t pte_sw_mkyoung(pte_t pte)
+{
+	return pte;
+}
+#define pte_sw_mkyoung	pte_sw_mkyoung
+#endif
+
 #ifndef pte_savedwrite
 #define pte_savedwrite pte_write
 #endif
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2896,6 +2896,7 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
+		entry = pte_sw_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 		/*
@@ -3561,6 +3562,7 @@ static vm_fault_t do_anonymous_page(stru
 	__SetPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
+	entry = pte_sw_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
@@ -3745,6 +3747,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
 	if (prefault && arch_wants_old_prefaulted_pte())
 		entry = pte_mkold(entry);
+	else
+		entry = pte_sw_mkyoung(entry);
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);


