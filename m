Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0C5A2687
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH2Szi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:55:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51274 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfH2Szi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 14:55:38 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i3PZt-0004wC-NS; Thu, 29 Aug 2019 20:55:25 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B6CFA1C07C3;
        Thu, 29 Aug 2019 20:55:24 +0200 (CEST)
Date:   Thu, 29 Aug 2019 18:55:24 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm/cpa: Prevent large page split when ftrace
 flips RW on kernel text
Cc:     Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.21.1908282355340.1938@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1908282355340.1938@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <156710492460.9654.8831877201682543400.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7af0145067bc429a09ac4047b167c0971c9f0dc7
Gitweb:        https://git.kernel.org/tip/7af0145067bc429a09ac4047b167c0971c9f0dc7
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Aug 2019 00:31:34 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 29 Aug 2019 20:48:44 +02:00

x86/mm/cpa: Prevent large page split when ftrace flips RW on kernel text

ftrace does not use text_poke() for enabling trace functionality. It uses
its own mechanism and flips the whole kernel text to RW and back to RO.

The CPA rework removed a loop based check of 4k pages which tried to
preserve a large page by checking each 4k page whether the change would
actually cover all pages in the large page.

This resulted in endless loops for nothing as in testing it turned out that
it actually never preserved anything. Of course testing missed to include
ftrace, which is the one and only case which benefitted from the 4k loop.

As a consequence enabling function tracing or ftrace based kprobes results
in a full 4k split of the kernel text, which affects iTLB performance.

The kernel RO protection is the only valid case where this can actually
preserve large pages.

All other static protections (RO data, data NX, PCI, BIOS) are truly
static.  So a conflict with those protections which results in a split
should only ever happen when a change of memory next to a protected region
is attempted. But these conflicts are rightfully splitting the large page
to preserve the protected regions. In fact a change to the protected
regions itself is a bug and is warned about.

Add an exception for the static protection check for kernel text RO when
the to be changed region spawns a full large page which allows to preserve
the large mappings. This also prevents the syslog to be spammed about CPA
violations when ftrace is used.

The exception needs to be removed once ftrace switched over to text_poke()
which avoids the whole issue.

Fixes: 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Song Liu <songliubraving@fb.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1908282355340.1938@nanos.tec.linutronix.de
---
 arch/x86/mm/pageattr.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6a9a77a..e14e95e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -516,7 +516,7 @@ static inline void check_conflict(int warnlvl, pgprot_t prot, pgprotval_t val,
  */
 static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 					  unsigned long pfn, unsigned long npg,
-					  int warnlvl)
+					  unsigned long lpsize, int warnlvl)
 {
 	pgprotval_t forbidden, res;
 	unsigned long end;
@@ -535,9 +535,17 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 	check_conflict(warnlvl, prot, res, start, end, pfn, "Text NX");
 	forbidden = res;
 
-	res = protect_kernel_text_ro(start, end);
-	check_conflict(warnlvl, prot, res, start, end, pfn, "Text RO");
-	forbidden |= res;
+	/*
+	 * Special case to preserve a large page. If the change spawns the
+	 * full large page mapping then there is no point to split it
+	 * up. Happens with ftrace and is going to be removed once ftrace
+	 * switched to text_poke().
+	 */
+	if (lpsize != (npg * PAGE_SIZE) || (start & (lpsize - 1))) {
+		res = protect_kernel_text_ro(start, end);
+		check_conflict(warnlvl, prot, res, start, end, pfn, "Text RO");
+		forbidden |= res;
+	}
 
 	/* Check the PFN directly */
 	res = protect_pci_bios(pfn, pfn + npg - 1);
@@ -819,7 +827,7 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	 * extra conditional required here.
 	 */
 	chk_prot = static_protections(old_prot, lpaddr, old_pfn, numpages,
-				      CPA_CONFLICT);
+				      psize, CPA_CONFLICT);
 
 	if (WARN_ON_ONCE(pgprot_val(chk_prot) != pgprot_val(old_prot))) {
 		/*
@@ -855,7 +863,7 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	 * protection requirement in the large page.
 	 */
 	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
-				      CPA_DETECT);
+				      psize, CPA_DETECT);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -906,7 +914,8 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 	if (!cpa->force_static_prot)
 		goto set;
 
-	prot = static_protections(ref_prot, address, pfn, npg, CPA_PROTECT);
+	/* Hand in lpsize = 0 to enforce the protection mechanism */
+	prot = static_protections(ref_prot, address, pfn, npg, 0, CPA_PROTECT);
 
 	if (pgprot_val(prot) == pgprot_val(ref_prot))
 		goto set;
@@ -1503,7 +1512,8 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
 		cpa_inc_4k_install();
-		new_prot = static_protections(new_prot, address, pfn, 1,
+		/* Hand in lpsize = 0 to enforce the protection mechanism */
+		new_prot = static_protections(new_prot, address, pfn, 1, 0,
 					      CPA_PROTECT);
 
 		new_prot = pgprot_clear_protnone_bits(new_prot);
