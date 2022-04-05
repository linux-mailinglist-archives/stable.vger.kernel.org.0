Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39544F398D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiDELfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353117AbiDEKFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D02BD8A4;
        Tue,  5 Apr 2022 02:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFDCE6157A;
        Tue,  5 Apr 2022 09:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092FCC385A2;
        Tue,  5 Apr 2022 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152456;
        bh=QCpKzlNwlObKkxLGcinrVRS09WvbB5PF54HVVjtAuto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2u5bGMMvk+K2n8oTjHUTFdtWuPWcXnDtV3/g8RGm9F8/aky9sJ4sXJbtzlPtauvt9
         MGPbEWRDJom6v6PlmesLFUlAkxRQTJvx46vXhQ2BX/zYkyVIzHpjEXWbpDXYMzXpRo
         nEzNNF/8LJaet3y0LAG9WBseSAvbxT+eTsHkixro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 781/913] powerpc: Add set_memory_{p/np}() and remove set_memory_attr()
Date:   Tue,  5 Apr 2022 09:30:43 +0200
Message-Id: <20220405070403.245800723@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit f222ab83df92acf72691a2021e1f0d99880dcdf1 upstream.

set_memory_attr() was implemented by commit 4d1755b6a762 ("powerpc/mm:
implement set_memory_attr()") because the set_memory_xx() couldn't
be used at that time to modify memory "on the fly" as explained it
the commit.

But set_memory_attr() uses set_pte_at() which leads to warnings when
CONFIG_DEBUG_VM is selected, because set_pte_at() is unexpected for
updating existing page table entries.

The check could be bypassed by using __set_pte_at() instead,
as it was the case before commit c988cfd38e48 ("powerpc/32:
use set_memory_attr()") but since commit 9f7853d7609d ("powerpc/mm:
Fix set_memory_*() against concurrent accesses") it is now possible
to use set_memory_xx() functions to update page table entries
"on the fly" because the update is now atomic.

For DEBUG_PAGEALLOC we need to clear and set back _PAGE_PRESENT.
Add set_memory_np() and set_memory_p() for that.

Replace all uses of set_memory_attr() by the relevant set_memory_xx()
and remove set_memory_attr().

Fixes: c988cfd38e48 ("powerpc/32: use set_memory_attr()")
Cc: stable@vger.kernel.org
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
Reviewed-by: Russell Currey <ruscur@russell.cc>
Depends-on: 9f7853d7609d ("powerpc/mm: Fix set_memory_*() against concurrent accesses")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/cda2b44b55c96f9ac69fa92e68c01084ec9495c5.1640344012.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/set_memory.h |   12 +++++++++-
 arch/powerpc/mm/pageattr.c            |   39 +++++-----------------------------
 arch/powerpc/mm/pgtable_32.c          |   24 +++++++++-----------
 3 files changed, 28 insertions(+), 47 deletions(-)

--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -6,6 +6,8 @@
 #define SET_MEMORY_RW	1
 #define SET_MEMORY_NX	2
 #define SET_MEMORY_X	3
+#define SET_MEMORY_NP	4	/* Set memory non present */
+#define SET_MEMORY_P	5	/* Set memory present */
 
 int change_memory_attr(unsigned long addr, int numpages, long action);
 
@@ -29,6 +31,14 @@ static inline int set_memory_x(unsigned
 	return change_memory_attr(addr, numpages, SET_MEMORY_X);
 }
 
-int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
+static inline int set_memory_np(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_NP);
+}
+
+static inline int set_memory_p(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_P);
+}
 
 #endif
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -48,6 +48,12 @@ static int change_page_attr(pte_t *ptep,
 	case SET_MEMORY_X:
 		pte = pte_mkexec(pte);
 		break;
+	case SET_MEMORY_NP:
+		pte_update(&init_mm, addr, ptep, _PAGE_PRESENT, 0, 0);
+		break;
+	case SET_MEMORY_P:
+		pte_update(&init_mm, addr, ptep, 0, _PAGE_PRESENT, 0);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -96,36 +102,3 @@ int change_memory_attr(unsigned long add
 	return apply_to_existing_page_range(&init_mm, start, size,
 					    change_page_attr, (void *)action);
 }
-
-/*
- * Set the attributes of a page:
- *
- * This function is used by PPC32 at the end of init to set final kernel memory
- * protection. It includes changing the maping of the page it is executing from
- * and data pages it is using.
- */
-static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
-{
-	pgprot_t prot = __pgprot((unsigned long)data);
-
-	spin_lock(&init_mm.page_table_lock);
-
-	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-
-	spin_unlock(&init_mm.page_table_lock);
-
-	return 0;
-}
-
-int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
-{
-	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
-	unsigned long sz = numpages * PAGE_SIZE;
-
-	if (numpages <= 0)
-		return 0;
-
-	return apply_to_existing_page_range(&init_mm, start, sz, set_page_attr,
-					    (void *)pgprot_val(prot));
-}
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -138,10 +138,12 @@ void mark_initmem_nx(void)
 	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
 				 PFN_DOWN((unsigned long)_sinittext);
 
-	if (v_block_mapped((unsigned long)_sinittext))
+	if (v_block_mapped((unsigned long)_sinittext)) {
 		mmu_mark_initmem_nx();
-	else
-		set_memory_attr((unsigned long)_sinittext, numpages, PAGE_KERNEL);
+	} else {
+		set_memory_nx((unsigned long)_sinittext, numpages);
+		set_memory_rw((unsigned long)_sinittext, numpages);
+	}
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
@@ -155,18 +157,14 @@ void mark_rodata_ro(void)
 		return;
 	}
 
-	numpages = PFN_UP((unsigned long)_etext) -
-		   PFN_DOWN((unsigned long)_stext);
-
-	set_memory_attr((unsigned long)_stext, numpages, PAGE_KERNEL_ROX);
 	/*
-	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
-	 * to cover NOTES and EXCEPTION_TABLE.
+	 * mark .text and .rodata as read only. Use __init_begin rather than
+	 * __end_rodata to cover NOTES and EXCEPTION_TABLE.
 	 */
 	numpages = PFN_UP((unsigned long)__init_begin) -
-		   PFN_DOWN((unsigned long)__start_rodata);
+		   PFN_DOWN((unsigned long)_stext);
 
-	set_memory_attr((unsigned long)__start_rodata, numpages, PAGE_KERNEL_RO);
+	set_memory_ro((unsigned long)_stext, numpages);
 
 	// mark_initmem_nx() should have already run by now
 	ptdump_check_wx();
@@ -182,8 +180,8 @@ void __kernel_map_pages(struct page *pag
 		return;
 
 	if (enable)
-		set_memory_attr(addr, numpages, PAGE_KERNEL);
+		set_memory_p(addr, numpages);
 	else
-		set_memory_attr(addr, numpages, __pgprot(0));
+		set_memory_np(addr, numpages);
 }
 #endif /* CONFIG_DEBUG_PAGEALLOC */


