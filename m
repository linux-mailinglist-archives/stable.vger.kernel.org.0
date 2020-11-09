Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222CB2ABA58
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731329AbgKINSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733233AbgKINSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F1320663;
        Mon,  9 Nov 2020 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927879;
        bh=/2hueZG+0Zb7UBbspGfFNJUaPv7EycolLUSuYsSp9u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyxgZ2nt7EVRbd2ssV+D4RU6n6+00MgcO+qOsw+P29mlGsVywvmYUouKIn9T/FDTr
         Os8c+2ryYLdoaJwNW0q9Rca/WKKRp6sFq8Qnm1hQD0bAzeepQZ3hTFe+B5WP25KYiY
         sjusaEyuWR8aVBW/gkx5xpZ8lzOjCQxxjAZo4iXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Privoznik <mprivozn@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mina Almasry <almasrymina@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 052/133] hugetlb_cgroup: fix reservation accounting
Date:   Mon,  9 Nov 2020 13:55:14 +0100
Message-Id: <20201109125033.223213816@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 79aa925bf239c234be8586780e482872dc4690dd upstream.

Michal Privoznik was using "free page reporting" in QEMU/virtio-balloon
with hugetlbfs and hit the warning below.  QEMU with free page hinting
uses fallocate(FALLOC_FL_PUNCH_HOLE) to discard pages that are reported
as free by a VM.  The reporting granularity is in pageblock granularity.
So when the guest reports 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE)
one huge page in QEMU.

  WARNING: CPU: 7 PID: 6636 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x50
  Modules linked in: ...
  CPU: 7 PID: 6636 Comm: qemu-system-x86 Not tainted 5.9.0 #137
  Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS PRO/X570 AORUS PRO, BIOS F21 07/31/2020
  RIP: 0010:page_counter_uncharge+0x4b/0x50
  ...
  Call Trace:
    hugetlb_cgroup_uncharge_file_region+0x4b/0x80
    region_del+0x1d3/0x300
    hugetlb_unreserve_pages+0x39/0xb0
    remove_inode_hugepages+0x1a8/0x3d0
    hugetlbfs_fallocate+0x3c4/0x5c0
    vfs_fallocate+0x146/0x290
    __x64_sys_fallocate+0x3e/0x70
    do_syscall_64+0x33/0x40
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Investigation of the issue uncovered bugs in hugetlb cgroup reservation
accounting.  This patch addresses the found issues.

Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
Reported-by: Michal Privoznik <mprivozn@redhat.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Michal Privoznik <mprivozn@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Link: https://lkml.kernel.org/r/20201021204426.36069-1-mike.kravetz@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -655,6 +655,8 @@ retry:
 			}
 
 			del += t - f;
+			hugetlb_cgroup_uncharge_file_region(
+				resv, rg, t - f);
 
 			/* New entry for end of split region */
 			nrg->from = t;
@@ -667,9 +669,6 @@ retry:
 			/* Original entry is trimmed */
 			rg->to = f;
 
-			hugetlb_cgroup_uncharge_file_region(
-				resv, rg, nrg->to - nrg->from);
-
 			list_add(&nrg->link, &rg->link);
 			nrg = NULL;
 			break;
@@ -685,17 +684,17 @@ retry:
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
 
@@ -2454,6 +2453,9 @@ struct page *alloc_huge_page(struct vm_a
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
+		if (deferred_reserve)
+			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
+					pages_per_huge_page(h), page);
 	}
 	return page;
 


