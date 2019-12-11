Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E730F11B807
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfLKPK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730742AbfLKPKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A289320663;
        Wed, 11 Dec 2019 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077024;
        bh=cics5kjVSYpYnPvKQuCF/mMDXQpUxK2EhuST2U+tfd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRPm8EOXR0u9S7Z30lZkOp8fn/A3scex2ACGQKgJv6g3wFSC+DfWCYk7vtwWmFf1H
         jV4SqZGBgcEqnzdQlmRV4xxf08Goc0lmvfyZnd9GP/ZXnc7X6tC3eh2z4BvUPzsVSo
         E3G+MM5yLAwryGiF0JutuUYy1ryAjcfAJhcwAXp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 44/92] x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()
Date:   Wed, 11 Dec 2019 16:05:35 +0100
Message-Id: <20191211150242.020012504@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 9a62d20027da3164a22244d9f022c0c987261687 upstream.

The job of vmalloc_sync_all() is to help the lazy freeing of vmalloc()
ranges: before such vmap ranges are reused we make sure that they are
unmapped from every task's page tables.

This is really easy on pagetable setups where the kernel page tables
are shared between all tasks - this is the case on 32-bit kernels
with SHARED_KERNEL_PMD = 1.

But on !SHARED_KERNEL_PMD 32-bit kernels this involves iterating
over the pgd_list and clearing all pmd entries in the pgds that
are cleared in the init_mm.pgd, which is the reference pagetable
that the vmalloc() code uses.

In that context the current practice of vmalloc_sync_all() iterating
until FIX_ADDR_TOP is buggy:

        for (address = VMALLOC_START & PMD_MASK;
             address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
             address += PMD_SIZE) {
                struct page *page;

Because iterating up to FIXADDR_TOP will involve a lot of non-vmalloc
address ranges:

	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR

This is mostly harmless for the FIX_ADDR and CPU_ENTRY_AREA ranges
that don't clear their pmds, but it's lethal for the LDT range,
which relies on having different mappings in different processes,
and 'synchronizing' them in the vmalloc sense corrupts those
pagetable entries (clearing them).

This got particularly prominent with PTI, which turns SHARED_KERNEL_PMD
off and makes this the dominant mapping mode on 32-bit.

To make LDT working again vmalloc_sync_all() must only iterate over
the volatile parts of the kernel address range that are identical
between all processes.

So the correct check in vmalloc_sync_all() is "address < VMALLOC_END"
to make sure the VMALLOC areas are synchronized and the LDT
mapping is not falsely overwritten.

The CPU_ENTRY_AREA and the FIXMAP area are no longer synced either,
but this is not really a proplem since their PMDs get established
during bootup and never change.

This change fixes the ldt_gdt selftest in my setup.

[ mingo: Fixed up the changelog to explain the logic and modified the
         copying to only happen up until VMALLOC_END. ]

Reported-by: Borislav Petkov <bp@suse.de>
Tested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com
Fixes: 7757d607c6b3: ("x86/pti: Allow CONFIG_PAGE_TABLE_ISOLATION for x86_32")
Link: https://lkml.kernel.org/r/20191126111119.GA110513@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -197,7 +197,7 @@ void vmalloc_sync_all(void)
 		return;
 
 	for (address = VMALLOC_START & PMD_MASK;
-	     address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
+	     address >= TASK_SIZE_MAX && address < VMALLOC_END;
 	     address += PMD_SIZE) {
 		struct page *page;
 


