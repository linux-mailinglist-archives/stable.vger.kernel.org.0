Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA610AB92
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 09:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfK0ITs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 03:19:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43993 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfK0ITo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 03:19:44 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iZsXu-0002SA-7K; Wed, 27 Nov 2019 09:19:34 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 770061C1E6E;
        Wed, 27 Nov 2019 09:19:30 +0100 (CET)
Date:   Wed, 27 Nov 2019 08:19:30 -0000
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()
Cc:     Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>,
        <stable@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
        Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191126111119.GA110513@gmail.com>
References: <20191126111119.GA110513@gmail.com>
MIME-Version: 1.0
Message-ID: <157484277038.21853.10016482959595799515.tip-bot2@tip-bot2>
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

Commit-ID:     9a62d20027da3164a22244d9f022c0c987261687
Gitweb:        https://git.kernel.org/tip/9a62d20027da3164a22244d9f022c0c987261687
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Tue, 26 Nov 2019 11:09:42 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 26 Nov 2019 21:53:34 +01:00

x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

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
---
 arch/x86/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ceacd1..304d31d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -197,7 +197,7 @@ void vmalloc_sync_all(void)
 		return;
 
 	for (address = VMALLOC_START & PMD_MASK;
-	     address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
+	     address >= TASK_SIZE_MAX && address < VMALLOC_END;
 	     address += PMD_SIZE) {
 		struct page *page;
 
