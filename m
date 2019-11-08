Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D04F3CF8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfKHAjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfKHAjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:39:00 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1F321D7E;
        Fri,  8 Nov 2019 00:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173538;
        bh=CmDxy4s8a1m8EtDokAQvNwApCDjyCw5+PUBNQegEHiI=;
        h=Date:From:To:Subject:From;
        b=H6QHWN/jpSPDbKOYgkK4y9dgFAiX+TBn9er4O7dQ0W/zgPXPV6zywS8vVV11rcVRp
         98of3nCo9ZVC4mm0RizJAe5CHhrTVXs6z/lqyZL2fcbWiEXhfwCVmT2XeZUZCnjAwr
         Z/XjQJ/MUKGzYWd7G6RVok/KjQo3BC+bNO2p3CK8=
Date:   Thu, 07 Nov 2019 16:38:57 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org, bp@alien8.de,
        daniel.vetter@intel.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@mellanox.com, jglisse@redhat.com,
        kirill.shutemov@linux.intel.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        ville.syrjala@linux.intel.com
Subject:  [merged]
 khugepaged-might_sleep-warn-due-to-config_highpte=y.patch removed from -mm
 tree
Message-ID: <20191108003857.T0hOFSWpI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix might_sleep() warn with CONFIG_HIGHPTE=3Dy
has been removed from the -mm tree.  Its filename was
     khugepaged-might_sleep-warn-due-to-config_highpte=3Dy.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
Subject: mm/khugepaged: fix might_sleep() warn with CONFIG_HIGHPTE=3Dy

I got some khugepaged spew on a 32bit x86:

[  217.490026] BUG: sleeping function called from invalid context at includ=
e/linux/mmu_notifier.h:346
[  217.492826] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 25, n=
ame: khugepaged
[  217.495589] INFO: lockdep is turned off.
[  217.498371] CPU: 1 PID: 25 Comm: khugepaged Not tainted 5.4.0-rc5-elk+ #=
206
[  217.501233] Hardware name: System manufacturer P5Q-EM/P5Q-EM, BIOS 2203 =
   07/08/2009
[  217.501697] Call Trace:
[  217.501697]  dump_stack+0x66/0x8e
[  217.501697]  ___might_sleep.cold.96+0x95/0xa6
[  217.501697]  __might_sleep+0x2e/0x80
[  217.501697]  collapse_huge_page.isra.51+0x5ac/0x1360
[  217.501697]  ? __alloc_pages_nodemask+0xec/0xf80
[  217.501697]  ? __alloc_pages_nodemask+0x191/0xf80
[  217.501697]  ? trace_hardirqs_on+0x4a/0xf0
[  217.501697]  khugepaged+0x9a9/0x20f0
[  217.501697]  ? _raw_spin_unlock+0x21/0x30
[  217.501697]  ? trace_hardirqs_on+0x4a/0xf0
[  217.501697]  ? wait_woken+0xa0/0xa0
[  217.501697]  kthread+0xf5/0x110
[  217.501697]  ? collapse_pte_mapped_thp+0x3b0/0x3b0
[  217.501697]  ? kthread_create_worker_on_cpu+0x20/0x20
[  217.501697]  ret_from_fork+0x2e/0x38

Looks like it's due to CONFIG_HIGHPTE=3Dy pte_offset_map()->kmap_atomic()
vs.  mmu_notifier_invalidate_range_start().  Let's do the naive approach
and just reorder the two operations.

Link: http://lkml.kernel.org/r/20191029201513.GG1208@intel.com
Fixes: 810e24e009cf71 ("mm/mmu_notifiers: annotate with might_sleep()")
Signed-off-by: Ville Syrjl <ville.syrjala@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~khugepaged-might_sleep-warn-due-to-config_highpte=3Dy
+++ a/mm/khugepaged.c
@@ -1028,12 +1028,13 @@ static void collapse_huge_page(struct mm
=20
 	anon_vma_lock_write(vma->anon_vma);
=20
-	pte =3D pte_offset_map(pmd, address);
-	pte_ptl =3D pte_lockptr(mm, pmd);
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
 				address, address + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
+
+	pte =3D pte_offset_map(pmd, address);
+	pte_ptl =3D pte_lockptr(mm, pmd);
+
 	pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
 	 * After this gup_fast can't run anymore. This also removes
_

Patches currently in -mm which might be from ville.syrjala@linux.intel.com =
are


