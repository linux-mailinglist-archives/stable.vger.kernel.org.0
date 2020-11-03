Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D52A4E31
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgKCSRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:19 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B7720757;
        Tue,  3 Nov 2020 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427438;
        bh=HxCZsl5iAySGVYWrVhzCDnFgYOOLjeCydSLs3jm4k4s=;
        h=Date:From:To:Subject:From;
        b=2gajwrNrd/dTtQ2PrFTgBfpmhb5+23pMLKW0cdf8NX4Zpm/bu9dCnGCMCVJlcx09K
         deW3NCbxtO7uCAcZ6okIKgcUZUPpdlskUFmSOYCiIy0n583j4d4wnIRRzGfFDYO263
         K0uF4B6Sl5lN8xMCm4ohUBcKGC4uNQOpQ69BwhpE=
Date:   Tue, 03 Nov 2020 10:17:17 -0800
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, bp@alien8.de, brijesh.singh@amd.com,
        corbet@lwn.net, dvyukov@google.com, dyoung@redhat.com,
        glider@google.com, jgg@nvidia.com, konrad.wilk@oracle.com,
        luto@kernel.org, lwoodman@redhat.com, matt@codeblueprint.co.uk,
        mingo@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org, riel@redhat.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, toshi.kani@hpe.com
Subject:  [merged]
 mm-always-have-io_remap_pfn_range-set-pgprot_decrypted.patch removed from
 -mm tree
Message-ID: <20201103181717.NuA7UkclW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: always have io_remap_pfn_range() set pgprot_decrypted()
has been removed from the -mm tree.  Its filename was
     mm-always-have-io_remap_pfn_range-set-pgprot_decrypted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm: always have io_remap_pfn_range() set pgprot_decrypted()

The purpose of io_remap_pfn_range() is to map IO memory, such as a memory
mapped IO exposed through a PCI BAR.  IO devices do not understand
encryption, so this memory must always be decrypted.  Automatically call
pgprot_decrypted() as part of the generic implementation.

This fixes a bug where enabling AMD SME causes subsystems, such as RDMA,
using io_remap_pfn_range() to expose BAR pages to user space to fail.  The
CPU will encrypt access to those BAR pages instead of passing unencrypted
IO directly to the device.

Places not mapping IO should use remap_pfn_range().

Link: https://lkml.kernel.org/r/0-v1-025d64bdf6c4+e-amd_sme_fix_jgg@nvidia.com
Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
CcK Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Dave Young" <dyoung@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Toshimitsu Kani <toshi.kani@hpe.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    9 +++++++++
 include/linux/pgtable.h |    4 ----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-always-have-io_remap_pfn_range-set-pgprot_decrypted
+++ a/include/linux/mm.h
@@ -2759,6 +2759,15 @@ static inline vm_fault_t vmf_insert_page
 	return VM_FAULT_NOPAGE;
 }
 
+#ifndef io_remap_pfn_range
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long addr, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, addr, pfn, size, pgprot_decrypted(prot));
+}
+#endif
+
 static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)
--- a/include/linux/pgtable.h~mm-always-have-io_remap_pfn_range-set-pgprot_decrypted
+++ a/include/linux/pgtable.h
@@ -1427,10 +1427,6 @@ typedef unsigned int pgtbl_mod_mask;
 
 #endif /* !__ASSEMBLY__ */
 
-#ifndef io_remap_pfn_range
-#define io_remap_pfn_range remap_pfn_range
-#endif
-
 #ifndef has_transparent_hugepage
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define has_transparent_hugepage() 1
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch

