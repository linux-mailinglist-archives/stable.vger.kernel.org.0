Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF5A90D6
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbfIDSMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbfIDSMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A48222CF7;
        Wed,  4 Sep 2019 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620720;
        bh=5S9ox43KCcEMnUOn2PQ6DQ0gzqXSLPSYZm5AqhUbdfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l32z6/zUMgZRYBPQHuR7zzH/lE+ZoBx+3EbFygZcgsotGaAwxE00V4RVuLptYcRkx
         ExX/iz7b15pzI079HDMgH+uoWTOoTFH19hHg5+EvdT0fJqpU5/MHERNZx6MO3EN3ey
         mkYrQpUa1rctipcDpQsNq1mAUCEzwMjl841ozfGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.2 071/143] x86/mm/cpa: Prevent large page split when ftrace flips RW on kernel text
Date:   Wed,  4 Sep 2019 19:53:34 +0200
Message-Id: <20190904175316.836809015@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 7af0145067bc429a09ac4047b167c0971c9f0dc7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/pageattr.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -516,7 +516,7 @@ static inline void check_conflict(int wa
  */
 static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 					  unsigned long pfn, unsigned long npg,
-					  int warnlvl)
+					  unsigned long lpsize, int warnlvl)
 {
 	pgprotval_t forbidden, res;
 	unsigned long end;
@@ -535,9 +535,17 @@ static inline pgprot_t static_protection
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
@@ -819,7 +827,7 @@ static int __should_split_large_page(pte
 	 * extra conditional required here.
 	 */
 	chk_prot = static_protections(old_prot, lpaddr, old_pfn, numpages,
-				      CPA_CONFLICT);
+				      psize, CPA_CONFLICT);
 
 	if (WARN_ON_ONCE(pgprot_val(chk_prot) != pgprot_val(old_prot))) {
 		/*
@@ -855,7 +863,7 @@ static int __should_split_large_page(pte
 	 * protection requirement in the large page.
 	 */
 	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
-				      CPA_DETECT);
+				      psize, CPA_DETECT);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -906,7 +914,8 @@ static void split_set_pte(struct cpa_dat
 	if (!cpa->force_static_prot)
 		goto set;
 
-	prot = static_protections(ref_prot, address, pfn, npg, CPA_PROTECT);
+	/* Hand in lpsize = 0 to enforce the protection mechanism */
+	prot = static_protections(ref_prot, address, pfn, npg, 0, CPA_PROTECT);
 
 	if (pgprot_val(prot) == pgprot_val(ref_prot))
 		goto set;
@@ -1503,7 +1512,8 @@ repeat:
 		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
 		cpa_inc_4k_install();
-		new_prot = static_protections(new_prot, address, pfn, 1,
+		/* Hand in lpsize = 0 to enforce the protection mechanism */
+		new_prot = static_protections(new_prot, address, pfn, 1, 0,
 					      CPA_PROTECT);
 
 		new_prot = pgprot_clear_protnone_bits(new_prot);


