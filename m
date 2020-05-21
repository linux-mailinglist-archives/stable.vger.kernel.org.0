Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1451DD69C
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgEUTGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 15:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgEUTGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 15:06:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F325520759;
        Thu, 21 May 2020 19:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590088009;
        bh=5R+efXkM7MK3uCM0o+M4NCp+vdK2KAlMNkQ1dxGDFGo=;
        h=Date:From:To:Subject:From;
        b=DhGIyhtZWR36NViw0cMBpjzS/qJYW92dRgoUbhT9NrsXBdrt6RXu3+rEtZkp3hOyo
         Z055vujR+M4R99NPEcd/+VxumoncTV+dD6nFI2hipYPLPq3870Is1co2eWYllo8wdN
         GosQ1MbyNNbSnz0Whj/AfpKkHSDwGUvigJMWqAbw=
Date:   Thu, 21 May 2020 12:06:48 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, jbeulich@suse.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, steven.price@arm.com,
        tglx@linutronix.de
Subject:  + mm-ptdump-expand-type-of-val-in-note_page.patch added
 to -mm tree
Message-ID: <20200521190648.ahK146y3G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: ptdump: expand type of 'val' in note_page()
has been added to the -mm tree.  Its filename is
     mm-ptdump-expand-type-of-val-in-note_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ptdump-expand-type-of-val-in-note_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ptdump-expand-type-of-val-in-note_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: mm: ptdump: expand type of 'val' in note_page()

The page table entry is passed in the 'val' argument to note_page(),
however this was previously an "unsigned long" which is fine on 64-bit
platforms.  But for 32 bit x86 it is not always big enough to contain a
page table entry which may be 64 bits.

Change the type to u64 to ensure that it is always big enough.

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
 arch/x86/mm/dump_pagetables.c |    2 +-
 include/linux/ptdump.h        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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

Patches currently in -mm which might be from steven.price@arm.com are

x86-mm-ptdump-calculate-effective-permissions-correctly.patch
mm-ptdump-expand-type-of-val-in-note_page.patch

