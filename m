Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855432A22A7
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgKBBH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 20:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:28 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE32206A4;
        Mon,  2 Nov 2020 01:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279248;
        bh=Xqd6/yl+/1mHKEmZeJ5x792mOBjBaVt7Pqoykjripog=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=geeM2f5lPRsKzK1A4aj1KceFwmu/ZTdL9JwoBjRlA8HcgGNzNzh3kkT8NvSA8Ta9r
         q7WI/9mva9mrDiEMLs19QCpIGpvO00cRQHi/m98lMxTA9i0qjzil4ZfvWx1R5L8zbO
         hW29L0W9m8uuMNjm//FJnh3nOm0wietOpzAAci0M=
Date:   Sun, 01 Nov 2020 17:07:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        aneesh.kumar@linux.vnet.ibm.com, david@redhat.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mprivozn@redhat.com, mst@redhat.com,
        songmuchun@bytedance.com, stable@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/15] hugetlb_cgroup: fix reservation accounting
Message-ID: <20201102010727.6e4pqN4-U%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
