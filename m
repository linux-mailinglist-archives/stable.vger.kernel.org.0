Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA89F403F57
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 21:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241581AbhIHTEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 15:04:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54086 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhIHTEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 15:04:22 -0400
Date:   Wed, 08 Sep 2021 19:03:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631127793;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cc4XKzlAxS2JV3J1f8eqsKquDD1+Lo6QrqMckR6OU9E=;
        b=2a9isP1SrMzoKsMARCnOodf/AOZ4OZtCWOdXAC1t+/rWl6OvwXl26r4/KFYZKnaTiuoXd9
        xAuzMdfiZ07CKIdOTJEUycBlhcEaZwEk75weluEC6m5wChahDeuET4euXuTs5oFYUHLZcz
        PZDqbxYdnZksqK3LRVoFN1E6KZOaQWssSlPEHyV8Z9hFMuFfubt19RQbrdPsEhvfS6OUs8
        ccmI+bOH62lRUEsew9wkjEgF0B6EcrQYr33hhTtKolWH11TsLeuxfxVeTLsATdyGMm3kgo
        HXE1dc3/XLsQsf7kMVol79UmncR5IshfRbeCy5kR9F54SGlXifz1Bpt8ImVIlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631127793;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cc4XKzlAxS2JV3J1f8eqsKquDD1+Lo6QrqMckR6OU9E=;
        b=mrTXsTWCaeOhZ6ev+EEwpnC9sR5WC5nHWYBli36E25xcC8vdjA2gJGqbebGKjmju251SWJ
        obpS3wTu0wVfmrCg==
From:   "tip-bot2 for Mike Rapoport" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm: Fix kern_addr_valid() to cope with existing
 but not present entries
Cc:     Jiri Olsa <jolsa@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>,
        Borislav Petkov <bp@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210819132717.19358-1-rppt@kernel.org>
References: <20210819132717.19358-1-rppt@kernel.org>
MIME-Version: 1.0
Message-ID: <163112779151.25758.9291514239160548248.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     34b1999da935a33be6239226bfa6cd4f704c5c88
Gitweb:        https://git.kernel.org/tip/34b1999da935a33be6239226bfa6cd4f704c5c88
Author:        Mike Rapoport <rppt@linux.ibm.com>
AuthorDate:    Thu, 19 Aug 2021 16:27:17 +03:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 08 Sep 2021 20:50:32 +02:00

x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Jiri Olsa reported a fault when running:

  # cat /proc/kallsyms | grep ksys_read
  ffffffff8136d580 T ksys_read
  # objdump -d --start-address=0xffffffff8136d580 --stop-address=0xffffffff8136d590 /proc/kcore

  /proc/kcore:     file format elf64-x86-64

  Segmentation fault

  general protection fault, probably for non-canonical address 0xf887ffcbff000: 0000 [#1] SMP PTI
  CPU: 12 PID: 1079 Comm: objdump Not tainted 5.14.0-rc5qemu+ #508
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
  RIP: 0010:kern_addr_valid
  Call Trace:
   read_kcore
   ? rcu_read_lock_sched_held
   ? rcu_read_lock_sched_held
   ? rcu_read_lock_sched_held
   ? trace_hardirqs_on
   ? rcu_read_lock_sched_held
   ? lock_acquire
   ? lock_acquire
   ? rcu_read_lock_sched_held
   ? lock_acquire
   ? rcu_read_lock_sched_held
   ? rcu_read_lock_sched_held
   ? rcu_read_lock_sched_held
   ? lock_release
   ? _raw_spin_unlock
   ? __handle_mm_fault
   ? rcu_read_lock_sched_held
   ? lock_acquire
   ? rcu_read_lock_sched_held
   ? lock_release
   proc_reg_read
   ? vfs_read
   vfs_read
   ksys_read
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

The fault happens because kern_addr_valid() dereferences existent but not
present PMD in the high kernel mappings.

Such PMDs are created when free_kernel_image_pages() frees regions larger
than 2Mb. In this case, a part of the freed memory is mapped with PMDs and
the set_memory_np_noalias() -> ... -> __change_page_attr() sequence will
mark the PMD as not present rather than wipe it completely.

Have kern_addr_valid() check whether higher level page table entries are
present before trying to dereference them to fix this issue and to avoid
similar issues in the future.

Stable backporting note:
------------------------

Note that the stable marking is for all active stable branches because
there could be cases where pagetable entries exist but are not valid -
see 9a14aefc1d28 ("x86: cpa, fix lookup_address"), for example. So make
sure to be on the safe side here and use pXY_present() accessors rather
than pXY_none() which could #GP when accessing pages in the direct map.

Also see:

  c40a56a7818c ("x86/mm/init: Remove freed kernel image areas from alias mapping")

for more info.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: <stable@vger.kernel.org>	# 4.4+
Link: https://lkml.kernel.org/r/20210819132717.19358-1-rppt@kernel.org
---
 arch/x86/mm/init_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ddeaba9..879886c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1433,18 +1433,18 @@ int kern_addr_valid(unsigned long addr)
 		return 0;
 
 	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d))
+	if (!p4d_present(*p4d))
 		return 0;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+	if (!pud_present(*pud))
 		return 0;
 
 	if (pud_large(*pud))
 		return pfn_valid(pud_pfn(*pud));
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		return 0;
 
 	if (pmd_large(*pmd))
