Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCA3FF6BB
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347960AbhIBV7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347964AbhIBV7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE546056B;
        Thu,  2 Sep 2021 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619934;
        bh=InL7XckgP2LayJs4waAJT2UmIK7YdTBwggKtuav0sCY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2j6PcwZwP21ChkhAC9PayEkwTtNcR9JszrDDdpxNS5xff0bkulxzBwk6BNsTNddGZ
         x+mgkG6q4ZUJXY1Aw0flmtUdgF4qlCx0MHTUv4yefoBrjdOs4e70RU3Ia6NoSkpl4W
         GjXKGM7Zr723iLs0cIiUQufAOG+CAIJGHTTZQRI8=
Date:   Thu, 02 Sep 2021 14:58:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guillaume@morinfr.org,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 169/212] hugetlb: fix hugetlb cgroup refcounting
 during vma split
Message-ID: <20210902215853.KRTbu9hz7%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix hugetlb cgroup refcounting during vma split

Guillaume Morin reported hitting the following WARNING followed by GPF or
NULL pointer deference either in cgroups_destroy or in the kill_css path.:

percpu ref (css_release) <= 0 (-1) after switching to atomic
WARNING: CPU: 23 PID: 130 at lib/percpu-refcount.c:196 percpu_ref_switch_to_atomic_rcu+0x127/0x130
CPU: 23 PID: 130 Comm: ksoftirqd/23 Kdump: loaded Tainted: G           O      5.10.60 #1
RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x127/0x130
Call Trace:
 rcu_core+0x30f/0x530
 rcu_core_si+0xe/0x10
 __do_softirq+0x103/0x2a2
 ? sort_range+0x30/0x30
 run_ksoftirqd+0x2b/0x40
 smpboot_thread_fn+0x11a/0x170
 kthread+0x10a/0x140
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x22/0x30

Upon further examination, it was discovered that the css structure was
associated with hugetlb reservations.

For private hugetlb mappings the vma points to a reserve map that contains
a pointer to the css.  At mmap time, reservations are set up and a
reference to the css is taken.  This reference is dropped in the vma close
operation; hugetlb_vm_op_close.  However, if a vma is split no additional
reference to the css is taken yet hugetlb_vm_op_close will be called twice
for the split vma resulting in an underflow.

Fix by taking another reference in hugetlb_vm_op_open.  Note that the
reference is only taken for the owner of the reserve map.  In the more
common fork case, the pointer to the reserve map is cleared for non-owning
vmas.

Link: https://lkml.kernel.org/r/20210830215015.155224-1-mike.kravetz@oracle.com
Fixes: e9fe92ae0cd2 ("hugetlb_cgroup: add reservation accounting for
private mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: Guillaume Morin <guillaume@morinfr.org>
Tested-by: Guillaume Morin <guillaume@morinfr.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   12 ++++++++++++
 mm/hugetlb.c                   |    4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb-fix-hugetlb-cgroup-refcounting-during-vma-split
+++ a/include/linux/hugetlb_cgroup.h
@@ -121,6 +121,13 @@ static inline void hugetlb_cgroup_put_rs
 	css_put(&h_cg->css);
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_get(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -199,6 +206,11 @@ static inline void hugetlb_cgroup_put_rs
 {
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
+
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
 {
--- a/mm/hugetlb.c~hugetlb-fix-hugetlb-cgroup-refcounting-during-vma-split
+++ a/mm/hugetlb.c
@@ -4106,8 +4106,10 @@ static void hugetlb_vm_op_open(struct vm
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_dup_hugetlb_cgroup_uncharge_info(resv);
 		kref_get(&resv->refs);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
_
