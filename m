Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76C340E501
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhIPRGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349178AbhIPRDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE73613A3;
        Thu, 16 Sep 2021 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810071;
        bh=PovgdXWAHX0fiTf6xwJjYzu1lWw/hwHlJD+x6BfURaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGTtPfY3dpjk5BSwLcD/H8Kq5yZWaA1z3iohw5Vf+NwfyHdfZ6M1k6LWmgZ43PrRs
         3z1T5Oj8YsEozcJcmhuqhDd5kw9mHpzLjMg53gMMBbgXPfisQH+WyW5TQs8Ka5/C6B
         vErDhHx273uJGu1623BR9Wt9+QY4f+dT3hGSkF1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Guillaume Morin <guillaume@morinfr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 357/380] hugetlb: fix hugetlb cgroup refcounting during vma split
Date:   Thu, 16 Sep 2021 18:01:54 +0200
Message-Id: <20210916155816.205173244@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 09a26e832705fdb7a9484495b71a05e0bbc65207 upstream.

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
       run_ksoftirqd+0x2b/0x40
       smpboot_thread_fn+0x11a/0x170
       kthread+0x10a/0x140
       ret_from_fork+0x22/0x30

Upon further examination, it was discovered that the css structure was
associated with hugetlb reservations.

For private hugetlb mappings the vma points to a reserve map that
contains a pointer to the css.  At mmap time, reservations are set up
and a reference to the css is taken.  This reference is dropped in the
vma close operation; hugetlb_vm_op_close.  However, if a vma is split no
additional reference to the css is taken yet hugetlb_vm_op_close will be
called twice for the split vma resulting in an underflow.

Fix by taking another reference in hugetlb_vm_op_open.  Note that the
reference is only taken for the owner of the reserve map.  In the more
common fork case, the pointer to the reserve map is cleared for
non-owning vmas.

Link: https://lkml.kernel.org/r/20210830215015.155224-1-mike.kravetz@oracle.com
Fixes: e9fe92ae0cd2 ("hugetlb_cgroup: add reservation accounting for private mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: Guillaume Morin <guillaume@morinfr.org>
Tested-by: Guillaume Morin <guillaume@morinfr.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb_cgroup.h |   12 ++++++++++++
 mm/hugetlb.c                   |    4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -118,6 +118,13 @@ static inline void hugetlb_cgroup_put_rs
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
@@ -196,6 +203,11 @@ static inline void hugetlb_cgroup_put_rs
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
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3840,8 +3840,10 @@ static void hugetlb_vm_op_open(struct vm
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


