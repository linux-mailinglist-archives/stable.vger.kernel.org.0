Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDBC411C8B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345854AbhITRK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345932AbhITRI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D4A6139E;
        Mon, 20 Sep 2021 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156961;
        bh=zWRyMRxFe1EWlVNwJftPpmD8XfzvNluhmXS0Qz9Tbkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bifDPxGDCRH5g5DGfZbqr/awBt2AV3yYlo6PJSgE9OOTQYMX6OfJWwtC4AcBpCgoR
         XethweVO0SPCThxGXyfF5PHfiZnYxhwEUr/GryaPnEz4SWBxE+UspC+dkfKpG4ToH/
         XHVVegYqkDjruq472X7EKhGwBOr7i6X7dBj9LW6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Borislav Petkov <bp@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH 4.9 165/175] x86/mm: Fix kern_addr_valid() to cope with existing but not present entries
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Message-Id: <20210920163923.459567132@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 34b1999da935a33be6239226bfa6cd4f704c5c88 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1126,21 +1126,21 @@ int kern_addr_valid(unsigned long addr)
 		return 0;
 
 	pud = pud_offset(pgd, addr);
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
 		return pfn_valid(pmd_pfn(*pmd));
 
 	pte = pte_offset_kernel(pmd, addr);
-	if (pte_none(*pte))
+	if (!pte_present(*pte))
 		return 0;
 
 	return pfn_valid(pte_pfn(*pte));


