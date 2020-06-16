Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9C41FB6A5
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgFPPjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730871AbgFPPjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD75320B1F;
        Tue, 16 Jun 2020 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321951;
        bh=1jXbA26MxRfopv0lYFTpHGBWpxrKbe6TNcB8FmPTZ2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiqU2rBWb3AFSr8obX86MPVmUezL2Za/zXsV6bAAcWOHQvA/uR+xCKRLKysPG9dh6
         gTOeNQXjwLDCOrDJYaqVCPKv/biMFHkbdf+mFPRdVtdCdwda681mrOrwygR8RfdZUs
         MLrRm2OyIjIH0038Jk0VzXEAMuv705rSlfmql/Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 048/134] powerpc/ptdump: Properly handle non standard page size
Date:   Tue, 16 Jun 2020 17:33:52 +0200
Message-Id: <20200616153103.097120488@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit b00ff6d8c1c3898b0f768cbb38ef722d25bd2f39 upstream.

In order to properly display information regardless of the page size,
it is necessary to take into account real page size.

Fixes: cabe8138b23c ("powerpc: dump as a single line areas mapping a single physical page.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a53b2a0ffd042a8d85464bf90d55bc5b970e00a1.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/ptdump/ptdump.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -58,6 +58,7 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned long start_pa;
 	unsigned long last_pa;
+	unsigned long page_size;
 	unsigned int level;
 	u64 current_flags;
 	bool check_wx;
@@ -155,9 +156,9 @@ static void dump_addr(struct pg_state *s
 #endif
 
 	pt_dump_seq_printf(st->seq, REG "-" REG " ", st->start_address, addr - 1);
-	if (st->start_pa == st->last_pa && st->start_address + PAGE_SIZE != addr) {
+	if (st->start_pa == st->last_pa && st->start_address + st->page_size != addr) {
 		pt_dump_seq_printf(st->seq, "[" REG "]", st->start_pa);
-		delta = PAGE_SIZE >> 10;
+		delta = st->page_size >> 10;
 	} else {
 		pt_dump_seq_printf(st->seq, " " REG " ", st->start_pa);
 		delta = (addr - st->start_address) >> 10;
@@ -188,7 +189,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct pg_state *st, unsigned long addr,
-	       unsigned int level, u64 val)
+	       unsigned int level, u64 val, unsigned long page_size)
 {
 	u64 flag = val & pg_level[level].mask;
 	u64 pa = val & PTE_RPN_MASK;
@@ -200,6 +201,7 @@ static void note_page(struct pg_state *s
 		st->start_address = addr;
 		st->start_pa = pa;
 		st->last_pa = pa;
+		st->page_size = page_size;
 		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 	/*
 	 * Dump the section of virtual memory when:
@@ -211,7 +213,7 @@ static void note_page(struct pg_state *s
 	 */
 	} else if (flag != st->current_flags || level != st->level ||
 		   addr >= st->marker[1].start_address ||
-		   (pa != st->last_pa + PAGE_SIZE &&
+		   (pa != st->last_pa + st->page_size &&
 		    (pa != st->start_pa || st->start_pa != st->last_pa))) {
 
 		/* Check the PTE flags */
@@ -239,6 +241,7 @@ static void note_page(struct pg_state *s
 		st->start_address = addr;
 		st->start_pa = pa;
 		st->last_pa = pa;
+		st->page_size = page_size;
 		st->current_flags = flag;
 		st->level = level;
 	} else {
@@ -254,7 +257,7 @@ static void walk_pte(struct pg_state *st
 
 	for (i = 0; i < PTRS_PER_PTE; i++, pte++) {
 		addr = start + i * PAGE_SIZE;
-		note_page(st, addr, 4, pte_val(*pte));
+		note_page(st, addr, 4, pte_val(*pte), PAGE_SIZE);
 
 	}
 }
@@ -271,7 +274,7 @@ static void walk_pmd(struct pg_state *st
 			/* pmd exists */
 			walk_pte(st, pmd, addr);
 		else
-			note_page(st, addr, 3, pmd_val(*pmd));
+			note_page(st, addr, 3, pmd_val(*pmd), PMD_SIZE);
 	}
 }
 
@@ -287,7 +290,7 @@ static void walk_pud(struct pg_state *st
 			/* pud exists */
 			walk_pmd(st, pud, addr);
 		else
-			note_page(st, addr, 2, pud_val(*pud));
+			note_page(st, addr, 2, pud_val(*pud), PUD_SIZE);
 	}
 }
 
@@ -306,7 +309,7 @@ static void walk_pagetables(struct pg_st
 			/* pgd exists */
 			walk_pud(st, pgd, addr);
 		else
-			note_page(st, addr, 1, pgd_val(*pgd));
+			note_page(st, addr, 1, pgd_val(*pgd), PGDIR_SIZE);
 	}
 }
 
@@ -361,7 +364,7 @@ static int ptdump_show(struct seq_file *
 
 	/* Traverse kernel page tables */
 	walk_pagetables(&st);
-	note_page(&st, 0, 0, 0);
+	note_page(&st, 0, 0, 0, 0);
 	return 0;
 }
 


