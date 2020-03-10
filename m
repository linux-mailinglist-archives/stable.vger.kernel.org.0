Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA66D17FB27
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgCJNLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgCJNLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEEC520409;
        Tue, 10 Mar 2020 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845869;
        bh=+Uwa2Wk28zLP25jtlD4SdJWvXNi9BogDG2iBlt+WeOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CE6+9ZaDQWr+qzSLD5XUFoChIdHkcDAD/ty9OkPnaQlOnpLWivQfChnJ98qDD4BHf
         wVyaUSeLxGc4JCeF78IBwEwCDTlmPpRNdxhU8DgObsTnLFTVbfoEecqFiGOEQgvc5L
         /7TD4N5XarEMZ+uY/XI3sCSD+yVoas3iW50aBJhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Zi Yan <zi.yan@cs.rutgers.edu>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 098/126] mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa
Date:   Tue, 10 Mar 2020 13:41:59 +0100
Message-Id: <20200310124209.969332499@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 8b272b3cbbb50a6a8e62d8a15affd473a788e184 upstream.

: A user reported a bug against a distribution kernel while running a
: proprietary workload described as "memory intensive that is not swapping"
: that is expected to apply to mainline kernels.  The workload is
: read/write/modifying ranges of memory and checking the contents.  They
: reported that within a few hours that a bad PMD would be reported followed
: by a memory corruption where expected data was all zeros.  A partial
: report of the bad PMD looked like
:
:   [ 5195.338482] ../mm/pgtable-generic.c:33: bad pmd ffff8888157ba008(000002e0396009e2)
:   [ 5195.341184] ------------[ cut here ]------------
:   [ 5195.356880] kernel BUG at ../mm/pgtable-generic.c:35!
:   ....
:   [ 5195.410033] Call Trace:
:   [ 5195.410471]  [<ffffffff811bc75d>] change_protection_range+0x7dd/0x930
:   [ 5195.410716]  [<ffffffff811d4be8>] change_prot_numa+0x18/0x30
:   [ 5195.410918]  [<ffffffff810adefe>] task_numa_work+0x1fe/0x310
:   [ 5195.411200]  [<ffffffff81098322>] task_work_run+0x72/0x90
:   [ 5195.411246]  [<ffffffff81077139>] exit_to_usermode_loop+0x91/0xc2
:   [ 5195.411494]  [<ffffffff81003a51>] prepare_exit_to_usermode+0x31/0x40
:   [ 5195.411739]  [<ffffffff815e56af>] retint_user+0x8/0x10
:
: Decoding revealed that the PMD was a valid prot_numa PMD and the bad PMD
: was a false detection.  The bug does not trigger if automatic NUMA
: balancing or transparent huge pages is disabled.
:
: The bug is due a race in change_pmd_range between a pmd_trans_huge and
: pmd_nond_or_clear_bad check without any locks held.  During the
: pmd_trans_huge check, a parallel protection update under lock can have
: cleared the PMD and filled it with a prot_numa entry between the transhuge
: check and the pmd_none_or_clear_bad check.
:
: While this could be fixed with heavy locking, it's only necessary to make
: a copy of the PMD on the stack during change_pmd_range and avoid races.  A
: new helper is created for this as the check if quite subtle and the
: existing similar helpful is not suitable.  This passed 154 hours of
: testing (usually triggers between 20 minutes and 24 hours) without
: detecting bad PMDs or corruption.  A basic test of an autonuma-intensive
: workload showed no significant change in behaviour.

Although Mel withdrew the patch on the face of LKML comment
https://lkml.org/lkml/2017/4/10/922 the race window aforementioned is
still open, and we have reports of Linpack test reporting bad residuals
after the bad PMD warning is observed.  In addition to that, bad
rss-counter and non-zero pgtables assertions are triggered on mm teardown
for the task hitting the bad PMD.

 host kernel: mm/pgtable-generic.c:40: bad pmd 00000000b3152f68(8000000d2d2008e7)
 ....
 host kernel: BUG: Bad rss-counter state mm:00000000b583043d idx:1 val:512
 host kernel: BUG: non-zero pgtables_bytes on freeing mm: 4096

The issue is observed on a v4.18-based distribution kernel, but the race
window is expected to be applicable to mainline kernels, as well.

[akpm@linux-foundation.org: fix comment typo, per Rafael]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Link: http://lkml.kernel.org/r/20200216191800.22423-1-aquini@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mprotect.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -148,6 +148,31 @@ static unsigned long change_pte_range(st
 	return pages;
 }
 
+/*
+ * Used when setting automatic NUMA hinting protection where it is
+ * critical that a numa hinting PMD is not confused with a bad PMD.
+ */
+static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
+{
+	pmd_t pmdval = pmd_read_atomic(pmd);
+
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	barrier();
+#endif
+
+	if (pmd_none(pmdval))
+		return 1;
+	if (pmd_trans_huge(pmdval))
+		return 0;
+	if (unlikely(pmd_bad(pmdval))) {
+		pmd_clear_bad(pmd);
+		return 1;
+	}
+
+	return 0;
+}
+
 static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
@@ -164,8 +189,17 @@ static inline unsigned long change_pmd_r
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
-		if (!is_swap_pmd(*pmd) && !pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
-				&& pmd_none_or_clear_bad(pmd))
+
+		/*
+		 * Automatic NUMA balancing walks the tables with mmap_sem
+		 * held for read. It's possible a parallel update to occur
+		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
+		 * check leading to a false positive and clearing.
+		 * Hence, it's necessary to atomically read the PMD value
+		 * for all the checks.
+		 */
+		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
+		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
 			goto next;
 
 		/* invoke the mmu notifier if the pmd is populated */


