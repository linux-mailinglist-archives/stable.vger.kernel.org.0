Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3085B2A22AD
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 02:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgKBBIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 20:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 20:08:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70BB22224E;
        Mon,  2 Nov 2020 01:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279282;
        bh=tt/wANYrcM6gQw1UkWFc9j26TvJMckfEtaPbU/YipIY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nwExDwFOnhnSDXBBVta35fuVm/2G3Np0NJ96kbQxqKSFt8RIJuk+Z/oDTl9EGxKVZ
         2rFGBKCuLstAnMsyKuzTJf3iXvpHvIheb70lUMED/v9gnpfRPyOe2k4xatD5ok8H9R
         USQEl0RHrweQg9wlfLoWFiEl6lkv1z7rECJOASR8=
Date:   Sun, 01 Nov 2020 17:08:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aryabinin@virtuozzo.com, bp@alien8.de,
        brijesh.singh@amd.com, corbet@lwn.net, dvyukov@google.com,
        dyoung@redhat.com, glider@google.com, jgg@nvidia.com,
        konrad.wilk@oracle.com, linux-mm@kvack.org, luto@kernel.org,
        lwoodman@redhat.com, matt@codeblueprint.co.uk, mingo@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, riel@redhat.com, stable@vger.kernel.org,
        tglx@linutronix.de, thomas.lendacky@amd.com,
        torvalds@linux-foundation.org, toshi.kani@hpe.com
Subject:  [patch 12/15] mm: always have io_remap_pfn_range() set
 pgprot_decrypted()
Message-ID: <20201102010800.Z1tI7BE5W%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
