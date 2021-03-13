Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0FE339BEF
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhCMFIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhCMFIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902F264FA8;
        Sat, 13 Mar 2021 05:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612115;
        bh=3BlKgJi0ll++8rFe7FHuTeUyHYOG/ULHH87iCYBuEz0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sAynsjzZMqr18T9Ur1ebKYh7J9gFZMvAjXYLDVbjEEbG5FrUYVtS29cWpS5Q534E8
         APTLQ8R4Z5M0sPkwaSArMMaP9URURKQ45sGReuclpfMs+OszNNvrGkm6EfR34NvhNs
         Cvc72RhQIMExqfH5C5xlt8jSCTZVCEyLV2WNXd9Q=
Date:   Fri, 12 Mar 2021 21:08:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenweilong@huawei.com,
        dingtianhong@huawei.com, guohanjun@huawei.com, hannes@cmpxchg.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, zhouguanghui1@huawei.com,
        ziy@nvidia.com
Subject:  [patch 27/29] mm/memcg: set memcg when splitting page
Message-ID: <20210313050833.w4W0nDDFK%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Guanghui <zhouguanghui1@huawei.com>
Subject: mm/memcg: set memcg when splitting page

As described in the split_page() comment, for the non-compound high order
page, the sub-pages must be freed individually.  If the memcg of the first
page is valid, the tail pages cannot be uncharged when be freed.

For example, when alloc_pages_exact is used to allocate 1MB continuous
physical memory, 2MB is charged(kmemcg is enabled and __GFP_ACCOUNT is
set).  When make_alloc_exact free the unused 1MB and free_pages_exact free
the applied 1MB, actually, only 4KB(one page) is uncharged.

Therefore, the memcg of the tail page needs to be set when splitting a
page.

Michel:

There are at least two explicit users of __GFP_ACCOUNT with
alloc_exact_pages added recently.  See 7efe8ef274024 ("KVM: arm64:
Allocate stage-2 pgd pages with GFP_KERNEL_ACCOUNT") and c419621873713
("KVM: s390: Add memcg accounting to KVM allocations"), so this is not
just a theoretical issue.

Link: https://lkml.kernel.org/r/20210304074053.65527-3-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-memcg-set-memcg-when-split-page
+++ a/mm/page_alloc.c
@@ -3314,6 +3314,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
+	split_page_memcg(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
_
