Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4C1EB4B6
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 06:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgFBEuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 00:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 00:50:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01B292074B;
        Tue,  2 Jun 2020 04:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591073399;
        bh=cF8mFnJNnFXH6gyVB4dngiasBsWMui9K/xSBX3ycG4w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zfAkb5McSIrKPDNEvbb9lNNxfiprMRVESuJW7nzIUSqHmfzx9F7ofGQC1QVO4jL+i
         Bt8pj7w00DPpmlPNXmA4p422MwtMZd1EHPGSYjkRe3cQc6mAcLipQUIF13g2As7oOB
         bQY4mjMEWCRfBz24YozuKg+jbcdIpqJZKOKC1Vi8=
Date:   Mon, 01 Jun 2020 21:49:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, cai@lca.pw,
        dave.hansen@linux.intel.com, jbeulich@suse.com, linux-mm@kvack.org,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, steven.price@arm.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 084/128] x86: mm: ptdump: calculate effective
 permissions correctly
Message-ID: <20200602044958.Lj5UG4EAO%akpm@linux-foundation.org>
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>
Subject: x86: mm: ptdump: calculate effective permissions correctly

Patch series "Fix W+X debug feature on x86"

Jan alerted me[1] that the W+X detection debug feature was broken in x86
by my change[2] to switch x86 to use the generic ptdump infrastructure.

Fundamentally the approach of trying to move the calculation of effective
permissions into note_page() was broken because note_page() is only called
for 'leaf' entries and the effective permissions are passed down via the
internal nodes of the page tree.  The solution I've taken here is to
create a new (optional) callback which is called for all nodes of the page
tree and therefore can calculate the effective permissions.

Secondly on some configurations (32 bit with PAE) "unsigned long" is not
large enough to store the table entries.  The fix here is simple - let's
just use a u64.

[1] https://lore.kernel.org/lkml/d573dc7e-e742-84de-473d-f971142fa319@suse.com/
[2] 2ae27137b2db ("x86: mm: convert dump_pagetables to use walk_page_range")


This patch (of 2):

By switching the x86 page table dump code to use the generic code the
effective permissions are no longer calculated correctly because the
note_page() function is only called for *leaf* entries.  To calculate the
actual effective permissions it is necessary to observe the full hierarchy
of the page tree.

Introduce a new callback for ptdump which is called for every entry and
can therefore update the prot_levels array correctly.  note_page() can
then simply access the appropriate element in the array.

[steven.price@arm.com: make the assignment conditional on val != 0]
  Link: http://lkml.kernel.org/r/430c8ab4-e7cd-6933-dde6-087fac6db872@arm.com
Link: http://lkml.kernel.org/r/20200521152308.33096-1-steven.price@arm.com
Link: http://lkml.kernel.org/r/20200521152308.33096-2-steven.price@arm.com
Fixes: 2ae27137b2db ("x86: mm: convert dump_pagetables to use walk_page_range")
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: Jan Beulich <jbeulich@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/dump_pagetables.c |   33 +++++++++++++++++++-------------
 include/linux/ptdump.h        |    1 
 mm/ptdump.c                   |   17 +++++++++++++++-
 3 files changed, 37 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/dump_pagetables.c~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/arch/x86/mm/dump_pagetables.c
@@ -249,10 +249,22 @@ static void note_wx(struct pg_state *st,
 		  (void *)st->start_address);
 }
 
-static inline pgprotval_t effective_prot(pgprotval_t prot1, pgprotval_t prot2)
+static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 {
-	return (prot1 & prot2 & (_PAGE_USER | _PAGE_RW)) |
-	       ((prot1 | prot2) & _PAGE_NX);
+	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	pgprotval_t prot = val & PTE_FLAGS_MASK;
+	pgprotval_t effective;
+
+	if (level > 0) {
+		pgprotval_t higher_prot = st->prot_levels[level - 1];
+
+		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
+			    ((higher_prot | prot) & _PAGE_NX);
+	} else {
+		effective = prot;
+	}
+
+	st->prot_levels[level] = effective;
 }
 
 /*
@@ -270,16 +282,10 @@ static void note_page(struct ptdump_stat
 	struct seq_file *m = st->seq;
 
 	new_prot = val & PTE_FLAGS_MASK;
-
-	if (level > 0) {
-		new_eff = effective_prot(st->prot_levels[level - 1],
-					 new_prot);
-	} else {
-		new_eff = new_prot;
-	}
-
-	if (level >= 0)
-		st->prot_levels[level] = new_eff;
+	if (!val)
+		new_eff = 0;
+	else
+		new_eff = st->prot_levels[level];
 
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
@@ -374,6 +380,7 @@ static void ptdump_walk_pgd_level_core(s
 	struct pg_state st = {
 		.ptdump = {
 			.note_page	= note_page,
+			.effective_prot = effective_prot,
 			.range		= ptdump_ranges
 		},
 		.level = -1,
--- a/include/linux/ptdump.h~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/include/linux/ptdump.h
@@ -14,6 +14,7 @@ struct ptdump_state {
 	/* level is 0:PGD to 4:PTE, or -1 if unknown */
 	void (*note_page)(struct ptdump_state *st, unsigned long addr,
 			  int level, unsigned long val);
+	void (*effective_prot)(struct ptdump_state *st, int level, u64 val);
 	const struct ptdump_range *range;
 };
 
--- a/mm/ptdump.c~x86-mm-ptdump-calculate-effective-permissions-correctly
+++ a/mm/ptdump.c
@@ -36,6 +36,9 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 0, pgd_val(val));
+
 	if (pgd_leaf(val))
 		st->note_page(st, addr, 0, pgd_val(val));
 
@@ -53,6 +56,9 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 1, p4d_val(val));
+
 	if (p4d_leaf(val))
 		st->note_page(st, addr, 1, p4d_val(val));
 
@@ -70,6 +76,9 @@ static int ptdump_pud_entry(pud_t *pud,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 2, pud_val(val));
+
 	if (pud_leaf(val))
 		st->note_page(st, addr, 2, pud_val(val));
 
@@ -87,6 +96,8 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 		return note_kasan_page_table(walk, addr);
 #endif
 
+	if (st->effective_prot)
+		st->effective_prot(st, 3, pmd_val(val));
 	if (pmd_leaf(val))
 		st->note_page(st, addr, 3, pmd_val(val));
 
@@ -97,8 +108,12 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
+	pte_t val = READ_ONCE(*pte);
+
+	if (st->effective_prot)
+		st->effective_prot(st, 4, pte_val(val));
 
-	st->note_page(st, addr, 4, pte_val(READ_ONCE(*pte)));
+	st->note_page(st, addr, 4, pte_val(val));
 
 	return 0;
 }
_
