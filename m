Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E7FF7E3E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfKKStg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfKKStg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265E5204FD;
        Mon, 11 Nov 2019 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498174;
        bh=PMkpqNZv3ZPfHaaDe9KyVurQIlzPF/Fmtm0kTa+IWaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HUKcglcNc6D2WqarXXiBN/FYT7JPY33XZNIGihnPhkEIeq1PeEPrBcmFmSwU5ZmH
         MeePDsbQ4BIyzaA1O2GVBOpCnY0w3AHMJZIoyIQG4v2zegaAkpkK0U9Bp9NopilVnM
         piotZ3E7CrZHkY3nqzHXihuRa6RE/U7il82Hv5AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ville Syrjl <ville.syrjala@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 044/193] mm/khugepaged: fix might_sleep() warn with CONFIG_HIGHPTE=y
Date:   Mon, 11 Nov 2019 19:27:06 +0100
Message-Id: <20191111181504.216827366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ec649c9d454ea372dcf16cccf48250994f1d7788 upstream.

I got some khugepaged spew on a 32bit x86:

  BUG: sleeping function called from invalid context at include/linux/mmu_notifier.h:346
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 25, name: khugepaged
  INFO: lockdep is turned off.
  CPU: 1 PID: 25 Comm: khugepaged Not tainted 5.4.0-rc5-elk+ #206
  Hardware name: System manufacturer P5Q-EM/P5Q-EM, BIOS 2203    07/08/2009
  Call Trace:
   dump_stack+0x66/0x8e
   ___might_sleep.cold.96+0x95/0xa6
   __might_sleep+0x2e/0x80
   collapse_huge_page.isra.51+0x5ac/0x1360
   khugepaged+0x9a9/0x20f0
   kthread+0xf5/0x110
   ret_from_fork+0x2e/0x38

Looks like it's due to CONFIG_HIGHPTE=y pte_offset_map()->kmap_atomic()
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
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1016,12 +1016,13 @@ static void collapse_huge_page(struct mm
 
 	anon_vma_lock_write(vma->anon_vma);
 
-	pte = pte_offset_map(pmd, address);
-	pte_ptl = pte_lockptr(mm, pmd);
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
 				address, address + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
+
+	pte = pte_offset_map(pmd, address);
+	pte_ptl = pte_lockptr(mm, pmd);
+
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
 	 * After this gup_fast can't run anymore. This also removes


