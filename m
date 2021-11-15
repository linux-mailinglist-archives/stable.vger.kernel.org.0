Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE4451672
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348171AbhKOVY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349124AbhKOVTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 16:19:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B17EA61B4D;
        Mon, 15 Nov 2021 21:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637011004;
        bh=hgzrC7OEfGSSU+nQUoU344E+z12K9c++EYEMrg7yjgY=;
        h=Date:From:To:Subject:From;
        b=R5nyCyyHawJa+jw08hmQeOShB7YiuRINDvHhEIgRvPW9exVi9QI6UQ6CtiN04gK+d
         w2/BHhFPih5U4cZi67Tr70c0SjMC0nOhBmii3PsdBrPJKmUvBZZCW9NwDQlyOiv8wZ
         MO8v9jcAf8lw7YIKCdCKnFcpRfU+GJeZbkLPTFvY=
Date:   Mon, 15 Nov 2021 13:16:43 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, linmiaohe@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minhquangbui99@gmail.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  +
 hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch added to -mm
 tree
Message-ID: <20211115211643.woJFRjTCW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: fix hugetlb cgroup refcounting during mremap
has been added to the -mm tree.  Its filename is
     hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: hugetlb: fix hugetlb cgroup refcounting during mremap

When hugetlb_vm_op_open() is called during copy_vma(), we may take the
reference to resv_map->css.  Later, when clearing the reservation pointer
of old_vma after transferring it to new_vma, we forget to drop the
reference to resv_map->css.  This leads to a reference leak of css.

Fixes this by adding a check to drop reservation css reference in
clear_vma_resv_huge_pages()

Link: https://lkml.kernel.org/r/20211113154412.91134-1-minhquangbui99@gmail.com
Fixes: 550a7d60bd5e35 ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   12 ++++++++++++
 mm/hugetlb.c                   |    4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap
+++ a/include/linux/hugetlb_cgroup.h
@@ -128,6 +128,13 @@ static inline void resv_map_dup_hugetlb_
 		css_get(resv_map->css);
 }
 
+static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_put(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -210,6 +217,11 @@ static inline void resv_map_dup_hugetlb_
 						struct resv_map *resv_map)
 {
 }
+
+static inline void resv_map_put_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
 
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
--- a/mm/hugetlb.c~hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap
+++ a/mm/hugetlb.c
@@ -1037,8 +1037,10 @@ void clear_vma_resv_huge_pages(struct vm
 	 */
 	struct resv_map *reservations = vma_resv_map(vma);
 
-	if (reservations && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (reservations && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_put_hugetlb_cgroup_uncharge_info(reservations);
 		kref_put(&reservations->refs, resv_map_release);
+	}
 
 	reset_vma_resv_huge_pages(vma);
 }
_

Patches currently in -mm which might be from minhquangbui99@gmail.com are

hugetlb-fix-hugetlb-cgroup-refcounting-during-mremap.patch

