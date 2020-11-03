Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF92A4E27
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgKCSQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgKCSQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:16:51 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C642080D;
        Tue,  3 Nov 2020 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427410;
        bh=AHdfGuGOzOHxuKWWVI8IhoYe06mfxy5CkilcCtf9O3U=;
        h=Date:From:To:Subject:From;
        b=rXExq+kh27cc299hlxwN0qvLjcF/ncj1Jwe8Ew+VSszEo/E6ZT84KncHQA47AiNT/
         FKfTb4UPprZF1Rpl5QokodL23nUDBgmLzHduImJVqp3NMGJDXSY0MumrqN5pY1wpwp
         yiW6Qy5qz6iNKGryFCh+6VBLK+cu+cHoZ1NNzwSw=
Date:   Tue, 03 Nov 2020 10:16:49 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.vnet.ibm.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mprivozn@redhat.com, mst@redhat.com,
        songmuchun@bytedance.com, stable@vger.kernel.org, tj@kernel.org
Subject:  [merged] hugetlb_cgroup-fix-reservation-accounting.patch
 removed from -mm tree
Message-ID: <20201103181649.6Rs3942ad%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix reservation accounting
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-fix-reservation-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb_cgroup: fix reservation accounting

Michal Privoznik was using "free page reporting" in QEMU/virtio-balloon
with hugetlbfs and hit the warning below.  QEMU with free page hinting
uses fallocate(FALLOC_FL_PUNCH_HOLE) to discard pages that are reported
as free by a VM. The reporting granularity is in pageblock granularity.
So when the guest reports 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE)
one huge page in QEMU.

[  315.251417] ------------[ cut here ]------------
[  315.251424] WARNING: CPU: 7 PID: 6636 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x50
[  315.251425] Modules linked in: ...
[  315.251466] CPU: 7 PID: 6636 Comm: qemu-system-x86 Not tainted 5.9.0 #137
[  315.251467] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS PRO/X570 AORUS PRO, BIOS F21 07/31/2020
[  315.251469] RIP: 0010:page_counter_uncharge+0x4b/0x50
...
[  315.251479] Call Trace:
[  315.251485]  hugetlb_cgroup_uncharge_file_region+0x4b/0x80
[  315.251487]  region_del+0x1d3/0x300
[  315.251489]  hugetlb_unreserve_pages+0x39/0xb0
[  315.251492]  remove_inode_hugepages+0x1a8/0x3d0
[  315.251495]  ? tlb_finish_mmu+0x7a/0x1d0
[  315.251497]  hugetlbfs_fallocate+0x3c4/0x5c0
[  315.251519]  ? kvm_arch_vcpu_ioctl_run+0x614/0x1700 [kvm]
[  315.251522]  ? file_has_perm+0xa2/0xb0
[  315.251524]  ? inode_security+0xc/0x60
[  315.251525]  ? selinux_file_permission+0x4e/0x120
[  315.251527]  vfs_fallocate+0x146/0x290
[  315.251529]  __x64_sys_fallocate+0x3e/0x70
[  315.251531]  do_syscall_64+0x33/0x40
[  315.251533]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
...
[  315.251542] ---[ end trace 4c88c62ccb1349c9 ]---

Investigation of the issue uncovered bugs in hugetlb cgroup reservation
accounting.  This patch addresses the found issues.

Link: https://lkml.kernel.org/r/20201021204426.36069-1-mike.kravetz@oracle.com
Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
Cc: <stable@vger.kernel.org>
Reported-by: Michal Privoznik <mprivozn@redhat.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Michal Privoznik <mprivozn@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb_cgroup-fix-reservation-accounting
+++ a/mm/hugetlb.c
@@ -648,6 +648,8 @@ retry:
 			}
 
 			del += t - f;
+			hugetlb_cgroup_uncharge_file_region(
+				resv, rg, t - f);
 
 			/* New entry for end of split region */
 			nrg->from = t;
@@ -660,9 +662,6 @@ retry:
 			/* Original entry is trimmed */
 			rg->to = f;
 
-			hugetlb_cgroup_uncharge_file_region(
-				resv, rg, nrg->to - nrg->from);
-
 			list_add(&nrg->link, &rg->link);
 			nrg = NULL;
 			break;
@@ -678,17 +677,17 @@ retry:
 		}
 
 		if (f <= rg->from) {	/* Trim beginning of region */
-			del += t - rg->from;
-			rg->from = t;
-
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
 							    t - rg->from);
-		} else {		/* Trim end of region */
-			del += rg->to - f;
-			rg->to = f;
 
+			del += t - rg->from;
+			rg->from = t;
+		} else {		/* Trim end of region */
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
 							    rg->to - f);
+
+			del += rg->to - f;
+			rg->to = f;
 		}
 	}
 
@@ -2443,6 +2442,9 @@ struct page *alloc_huge_page(struct vm_a
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
+		if (deferred_reserve)
+			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
+					pages_per_huge_page(h), page);
 	}
 	return page;
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


