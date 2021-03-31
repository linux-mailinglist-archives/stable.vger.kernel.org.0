Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187B634C885
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhC2IXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhC2IVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25CC56044F;
        Mon, 29 Mar 2021 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006065;
        bh=m20dkXyj3a3HqpZFesIlMDDWHEfJQ01oQF5GMlKh/A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq/JFIJAeWpVFIMNeMLhssI1/hsyKl0w2PBk8uVCVqC05hBjvDMaqRkazrb7AkJFP
         ffJ59tRKPuzNs+xxZpywP+t/1Bi9D0/c7ljtAg3rbW03u5ESH5Q0A9TgBsRY84yta9
         aX9bd6jM/jYvhb+yzz/cjh8q1RztnKRs9nkb2hVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 071/221] hugetlb_cgroup: fix imbalanced css_get and css_put pair for shared mappings
Date:   Mon, 29 Mar 2021 09:56:42 +0200
Message-Id: <20210329075631.557645189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit d85aecf2844ff02a0e5f077252b2461d4f10c9f0 upstream.

The current implementation of hugetlb_cgroup for shared mappings could
have different behavior.  Consider the following two scenarios:

 1.Assume initial css reference count of hugetlb_cgroup is 1:
  1.1 Call hugetlb_reserve_pages with from = 1, to = 2. So css reference
      count is 2 associated with 1 file_region.
  1.2 Call hugetlb_reserve_pages with from = 2, to = 3. So css reference
      count is 3 associated with 2 file_region.
  1.3 coalesce_file_region will coalesce these two file_regions into
      one. So css reference count is 3 associated with 1 file_region
      now.

 2.Assume initial css reference count of hugetlb_cgroup is 1 again:
  2.1 Call hugetlb_reserve_pages with from = 1, to = 3. So css reference
      count is 2 associated with 1 file_region.

Therefore, we might have one file_region while holding one or more css
reference counts. This inconsistency could lead to imbalanced css_get()
and css_put() pair. If we do css_put one by one (i.g. hole punch case),
scenario 2 would put one more css reference. If we do css_put all
together (i.g. truncate case), scenario 1 will leak one css reference.

The imbalanced css_get() and css_put() pair would result in a non-zero
reference when we try to destroy the hugetlb cgroup. The hugetlb cgroup
directory is removed __but__ associated resource is not freed. This
might result in OOM or can not create a new hugetlb cgroup in a busy
workload ultimately.

In order to fix this, we have to make sure that one file_region must
hold exactly one css reference. So in coalesce_file_region case, we
should release one css reference before coalescence. Also only put css
reference when the entire file_region is removed.

The last thing to note is that the caller of region_add() will only hold
one reference to h_cg->css for the whole contiguous reservation region.
But this area might be scattered when there are already some
file_regions reside in it. As a result, many file_regions may share only
one h_cg->css reference. In order to ensure that one file_region must
hold exactly one css reference, we should do css_get() for each
file_region and release the reference held by caller when they are done.

[linmiaohe@huawei.com: fix imbalanced css_get and css_put pair for shared mappings]
  Link: https://lkml.kernel.org/r/20210316023002.53921-1-linmiaohe@huawei.com

Link: https://lkml.kernel.org/r/20210301120540.37076-1-linmiaohe@huawei.com
Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
Reported-by: kernel test robot <lkp@intel.com> (auto build test ERROR)
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb_cgroup.h |   15 +++++++++++++--
 mm/hugetlb.c                   |   41 +++++++++++++++++++++++++++++++++++++----
 mm/hugetlb_cgroup.c            |   10 ++++++++--
 3 files changed, 58 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -113,6 +113,11 @@ static inline bool hugetlb_cgroup_disabl
 	return !cgroup_subsys_enabled(hugetlb_cgrp_subsys);
 }
 
+static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
+{
+	css_put(&h_cg->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -138,7 +143,8 @@ extern void hugetlb_cgroup_uncharge_coun
 
 extern void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
 						struct file_region *rg,
-						unsigned long nr_pages);
+						unsigned long nr_pages,
+						bool region_del);
 
 extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
@@ -147,7 +153,8 @@ extern void hugetlb_cgroup_migrate(struc
 #else
 static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
 						       struct file_region *rg,
-						       unsigned long nr_pages)
+						       unsigned long nr_pages,
+						       bool region_del)
 {
 }
 
@@ -185,6 +192,10 @@ static inline bool hugetlb_cgroup_disabl
 	return true;
 }
 
+static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
+{
+}
+
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
 {
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -285,6 +285,17 @@ static void record_hugetlb_cgroup_unchar
 		nrg->reservation_counter =
 			&h_cg->rsvd_hugepage[hstate_index(h)];
 		nrg->css = &h_cg->css;
+		/*
+		 * The caller will hold exactly one h_cg->css reference for the
+		 * whole contiguous reservation region. But this area might be
+		 * scattered when there are already some file_regions reside in
+		 * it. As a result, many file_regions may share only one css
+		 * reference. In order to ensure that one file_region must hold
+		 * exactly one h_cg->css reference, we should do css_get for
+		 * each file_region and leave the reference held by caller
+		 * untouched.
+		 */
+		css_get(&h_cg->css);
 		if (!resv->pages_per_hpage)
 			resv->pages_per_hpage = pages_per_huge_page(h);
 		/* pages_per_hpage should be the same for all entries in
@@ -298,6 +309,14 @@ static void record_hugetlb_cgroup_unchar
 #endif
 }
 
+static void put_uncharge_info(struct file_region *rg)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	if (rg->css)
+		css_put(rg->css);
+#endif
+}
+
 static bool has_same_uncharge_info(struct file_region *rg,
 				   struct file_region *org)
 {
@@ -321,6 +340,7 @@ static void coalesce_file_region(struct
 		prg->to = rg->to;
 
 		list_del(&rg->link);
+		put_uncharge_info(rg);
 		kfree(rg);
 
 		rg = prg;
@@ -332,6 +352,7 @@ static void coalesce_file_region(struct
 		nrg->from = rg->from;
 
 		list_del(&rg->link);
+		put_uncharge_info(rg);
 		kfree(rg);
 	}
 }
@@ -664,7 +685,7 @@ retry:
 
 			del += t - f;
 			hugetlb_cgroup_uncharge_file_region(
-				resv, rg, t - f);
+				resv, rg, t - f, false);
 
 			/* New entry for end of split region */
 			nrg->from = t;
@@ -685,7 +706,7 @@ retry:
 		if (f <= rg->from && t >= rg->to) { /* Remove entire region */
 			del += rg->to - rg->from;
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
-							    rg->to - rg->from);
+							    rg->to - rg->from, true);
 			list_del(&rg->link);
 			kfree(rg);
 			continue;
@@ -693,13 +714,13 @@ retry:
 
 		if (f <= rg->from) {	/* Trim beginning of region */
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
-							    t - rg->from);
+							    t - rg->from, false);
 
 			del += t - rg->from;
 			rg->from = t;
 		} else {		/* Trim end of region */
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
-							    rg->to - f);
+							    rg->to - f, false);
 
 			del += rg->to - f;
 			rg->to = f;
@@ -5189,6 +5210,10 @@ int hugetlb_reserve_pages(struct inode *
 			 */
 			long rsv_adjust;
 
+			/*
+			 * hugetlb_cgroup_uncharge_cgroup_rsvd() will put the
+			 * reference to h_cg->css. See comment below for detail.
+			 */
 			hugetlb_cgroup_uncharge_cgroup_rsvd(
 				hstate_index(h),
 				(chg - add) * pages_per_huge_page(h), h_cg);
@@ -5196,6 +5221,14 @@ int hugetlb_reserve_pages(struct inode *
 			rsv_adjust = hugepage_subpool_put_pages(spool,
 								chg - add);
 			hugetlb_acct_memory(h, -rsv_adjust);
+		} else if (h_cg) {
+			/*
+			 * The file_regions will hold their own reference to
+			 * h_cg->css. So we should release the reference held
+			 * via hugetlb_cgroup_charge_cgroup_rsvd() when we are
+			 * done.
+			 */
+			hugetlb_cgroup_put_rsvd_cgroup(h_cg);
 		}
 	}
 	return 0;
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -391,7 +391,8 @@ void hugetlb_cgroup_uncharge_counter(str
 
 void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
 					 struct file_region *rg,
-					 unsigned long nr_pages)
+					 unsigned long nr_pages,
+					 bool region_del)
 {
 	if (hugetlb_cgroup_disabled() || !resv || !rg || !nr_pages)
 		return;
@@ -400,7 +401,12 @@ void hugetlb_cgroup_uncharge_file_region
 	    !resv->reservation_counter) {
 		page_counter_uncharge(rg->reservation_counter,
 				      nr_pages * resv->pages_per_hpage);
-		css_put(rg->css);
+		/*
+		 * Only do css_put(rg->css) when we delete the entire region
+		 * because one file_region must hold exactly one css reference.
+		 */
+		if (region_del)
+			css_put(rg->css);
 	}
 }
 


