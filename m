Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F072410FD8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhITHKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 03:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbhITHKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 03:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5DDD60F0F;
        Mon, 20 Sep 2021 07:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632121717;
        bh=KOdQxMciwA062eLY63XUSwymnbFDH1bDgts0LPh+Lw0=;
        h=Subject:To:Cc:From:Date:From;
        b=LBFfVNhb/60Dcs0VlK31kfKfs8Yfh6mmrDTvg4babbafDdeZdMMOHeAMspjhrmcbT
         XcmDR7NG91CX+7QOMg7sZPjbvSj8URAOoI32yK2fapW7824EKp2PDUCtA+f+qNgGVP
         aWgA6TR5mhiiNZqptdm0jsumGa85xDvrv64S+kgY=
Subject: FAILED: patch "[PATCH] x86/mm: Fix kern_addr_valid() to cope with existing but not" failed to apply to 4.4-stable tree
To:     rppt@linux.ibm.com, bp@suse.de, dave.hansen@intel.com,
        david@redhat.com, jolsa@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 09:08:35 +0200
Message-ID: <163212171511930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34b1999da935a33be6239226bfa6cd4f704c5c88 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Thu, 19 Aug 2021 16:27:17 +0300
Subject: [PATCH] x86/mm: Fix kern_addr_valid() to cope with existing but not
 present entries

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

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ddeaba947eb3..879886c6cc53 100644
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

