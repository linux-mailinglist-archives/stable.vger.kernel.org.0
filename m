Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C6498B05
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346663AbiAXTJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiAXTHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:07:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8612C061392;
        Mon, 24 Jan 2022 11:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75A7B6090C;
        Mon, 24 Jan 2022 19:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501F9C340E5;
        Mon, 24 Jan 2022 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050897;
        bh=yHlKqiWYbJ3A9vWSHABg/J4O7uW1sFkJ2uhDLitDFL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIcgbhXTZkFqCYxaRTDwiGi5BFKCo2uuoI77z3fKXWXDfe1nzoCGibeMnYpj46JXZ
         khnztYd+VD+JcqAeqW5kFICIN6sF1GTuy7k09G8uSURbJ6gIFpnKLx8f1z5nIUI5Pt
         5kdnUCWqRtl9tx/81Zf54z6A/nHWIdnp5jHINC7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 146/157] Revert "gup: document and work around "COW can break either way" issue"
Date:   Mon, 24 Jan 2022 19:43:56 +0100
Message-Id: <20220124183937.393297919@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 9bbd42e79720122334226afad9ddcac1c3e6d373, which
was commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.  The
backport was incorrect and incomplete:

* It forced the write flag on in the generic __get_user_pages_fast(),
  whereas only get_user_pages_fast() was supposed to do that.
* It only fixed the generic RCU-based implementation used by arm,
  arm64, and powerpc.  Before Linux 4.13, several other architectures
  had their own implementations: mips, s390, sparc, sh, and x86.

This will be followed by a (hopefully) correct backport.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c         |   48 ++++++++----------------------------------------
 mm/huge_memory.c |    7 ++++---
 2 files changed, 12 insertions(+), 43 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -61,22 +61,13 @@ static int follow_pfn_pte(struct vm_area
 }
 
 /*
- * FOLL_FORCE or a forced COW break can write even to unwritable pte's,
- * but only after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE can write to even unwritable pte's, but only
+ * after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) || ((flags & FOLL_COW) && pte_dirty(pte));
-}
-
-/*
- * A (separate) COW fault might break the page the other way and
- * get_user_pages() would return the page from what is now the wrong
- * VM. So we need to force a COW break at GUP time even for reads.
- */
-static inline bool should_force_cow_break(struct vm_area_struct *vma, unsigned int flags)
-{
-	return is_cow_mapping(vma->vm_flags) && (flags & FOLL_GET);
+	return pte_write(pte) ||
+		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -586,18 +577,12 @@ static long __get_user_pages(struct task
 			if (!vma || check_vma_flags(vma, gup_flags))
 				return i ? : -EFAULT;
 			if (is_vm_hugetlb_page(vma)) {
-				if (should_force_cow_break(vma, foll_flags))
-					foll_flags |= FOLL_WRITE;
 				i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						foll_flags);
+						gup_flags);
 				continue;
 			}
 		}
-
-		if (should_force_cow_break(vma, foll_flags))
-			foll_flags |= FOLL_WRITE;
-
 retry:
 		/*
 		 * If we have a pending SIGKILL, don't keep faulting pages and
@@ -1518,10 +1503,6 @@ static int gup_pud_range(pgd_t pgd, unsi
 /*
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
  * the regular GUP. It will only return non-negative values.
- *
- * Careful, careful! COW breaking can go either way, so a non-write
- * access can get ambiguous page results. If you call this function without
- * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -1551,12 +1532,6 @@ int __get_user_pages_fast(unsigned long
 	 *
 	 * We do not adopt an rcu_read_lock(.) here as we also want to
 	 * block IPIs that come from THPs splitting.
-	 *
-	 * NOTE! We allow read-only gup_fast() here, but you'd better be
-	 * careful about possible COW pages. You'll get _a_ COW page, but
-	 * not necessarily the one you intended to get depending on what
-	 * COW event happens after this. COW may break the page copy in a
-	 * random direction.
 	 */
 
 	local_irq_save(flags);
@@ -1567,22 +1542,15 @@ int __get_user_pages_fast(unsigned long
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			break;
-		/*
-		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
-		 * because get_user_pages() may need to cause an early COW in
-		 * order to avoid confusing the normal COW routines. So only
-		 * targets that are already writable are safe to do by just
-		 * looking at the page tables.
-		 */
 		if (unlikely(pgd_huge(pgd))) {
-			if (!gup_huge_pgd(pgd, pgdp, addr, next, 1,
+			if (!gup_huge_pgd(pgd, pgdp, addr, next, write,
 					  pages, &nr))
 				break;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
-					 PGDIR_SHIFT, next, 1, pages, &nr))
+					 PGDIR_SHIFT, next, write, pages, &nr))
 				break;
-		} else if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
+		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_restore(flags);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1135,12 +1135,13 @@ out_unlock:
 }
 
 /*
- * FOLL_FORCE or a forced COW break can write even to unwritable pmd's,
- * but only after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE can write to even unwritable pmd's, but only
+ * after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) || ((flags & FOLL_COW) && pmd_dirty(pmd));
+	return pmd_write(pmd) ||
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,


