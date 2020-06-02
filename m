Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85931EB4B7
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 06:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgFBEuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 00:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgFBEuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 00:50:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 479EC20772;
        Tue,  2 Jun 2020 04:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591073402;
        bh=YHoIRwraHRsuP6rRJNsuWB+JzS4sqVyKwtup97MwEfk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vsjnVmtlZVSIKu2GO8zuS8fMiFyc6DqxwcU4yYn8Jj9Z3Gb4uFlxZt6ZprpgQSmj6
         bOhyQxA+uksYoOGo5w2FMR6f5H3F8EGJUnqowCUiTh08LNkqeqo7mzuN2i9hvikMMG
         hYNtb4QeWTQcq/Rq0JhalqiBqljTSXtJDmtA/Ris=
Date:   Mon, 01 Jun 2020 21:50:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@linux.intel.com, jbeulich@suse.com, linux-mm@kvack.org,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, steven.price@arm.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 085/128] mm: ptdump: expand type of 'val' in
 note_page()
Message-ID: <20200602045001.lGoO32E-a%akpm@linux-foundation.org>
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>
Subject: mm: ptdump: expand type of 'val' in note_page()

The page table entry is passed in the 'val' argument to note_page(),
however this was previously an "unsigned long" which is fine on 64-bit
platforms.  But for 32 bit x86 it is not always big enough to contain a
page table entry which may be 64 bits.

Change the type to u64 to ensure that it is always big enough.

[akpm@linux-foundation.org: fix riscv]
Link: http://lkml.kernel.org/r/20200521152308.33096-3-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/dump.c          |    2 +-
 arch/riscv/mm/ptdump.c        |    2 +-
 arch/x86/mm/dump_pagetables.c |    2 +-
 include/linux/ptdump.h        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/dump.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/arm64/mm/dump.c
@@ -247,7 +247,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      unsigned long val)
+		      u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	static const char units[] = "KMGTPE";
--- a/arch/riscv/mm/ptdump.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/riscv/mm/ptdump.c
@@ -204,7 +204,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr,
-		      int level, unsigned long val)
+		      int level, u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	u64 pa = PFN_PHYS(pte_pfn(__pte(val)));
--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-expand-type-of-val-in-note_page
+++ a/arch/x86/mm/dump_pagetables.c
@@ -273,7 +273,7 @@ static void effective_prot(struct ptdump
  * print what we collected so far.
  */
 static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      unsigned long val)
+		      u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	pgprotval_t new_prot, new_eff;
--- a/include/linux/ptdump.h~mm-ptdump-expand-type-of-val-in-note_page
+++ a/include/linux/ptdump.h
@@ -13,7 +13,7 @@ struct ptdump_range {
 struct ptdump_state {
 	/* level is 0:PGD to 4:PTE, or -1 if unknown */
 	void (*note_page)(struct ptdump_state *st, unsigned long addr,
-			  int level, unsigned long val);
+			  int level, u64 val);
 	void (*effective_prot)(struct ptdump_state *st, int level, u64 val);
 	const struct ptdump_range *range;
 };
_
