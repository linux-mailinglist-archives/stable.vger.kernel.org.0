Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AF38148F
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhEOA2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 20:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 20:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E39761446;
        Sat, 15 May 2021 00:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038427;
        bh=DhcuA4EivNVuq4ZDGwN7CQQyCFo4+IQDgT/eQDfSkv0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JMINWsinS52HeYjlwDq8yMhjBF0cbxD7jFVNFNpG1Iz1N/FHJEjV7BaDYX9fEGONs
         EK7J9ybW6td7va0FIYtO2zFxH0k2cyznoovlTObu24/0qxUFzbt67e61oS7C5U6qEc
         7kCtsmsoXC2OJK2fos1neoFa4HfjwXtKw8XtkwZw=
Date:   Fri, 14 May 2021 17:27:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        joel@joelfernandes.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/13] mm/hugetlb: fix cow where page writtable in
 child
Message-ID: <20210515002707.LZb1SqAkO%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix cow where page writtable in child

When rework early cow of pinned hugetlb pages, we moved huge_ptep_get()
upper but overlooked a side effect that the huge_ptep_get() will fetch the
pte after wr-protection.  After moving it upwards, we need explicit
wr-protect of child pte or we will keep the write bit set in the child
process, which could cause data corrution where the child can write to the
original page directly.

This issue can also be exposed by "memfd_test hugetlbfs" kselftest.

Link: https://lkml.kernel.org/r/20210503234356.9097-3-peterx@redhat.com
Fixes: 4eae4efa2c299 ("hugetlb: do early cow when page pinned on src mm")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-cow-where-page-writtable-in-child
+++ a/mm/hugetlb.c
@@ -4056,6 +4056,7 @@ again:
 				 * See Documentation/vm/mmu_notifier.rst
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				entry = huge_pte_wrprotect(entry);
 			}
 
 			page_dup_rmap(ptepage, true);
_
