Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F81141A4B
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 23:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgARW4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 17:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgARW4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 17:56:06 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A827620679;
        Sat, 18 Jan 2020 22:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579388165;
        bh=jZ8YdnRBX9EDonfAPfT7ZcpoPzWPALa4EA5mgXF9H3A=;
        h=Date:From:To:Subject:From;
        b=MYPu1P8nZw35efkRrlGT9SRyJQpBmLOs97Pzm/BdnHjyCXyETw//UsRcn/pVhxnkB
         Kn7DLubMgck1QTwIT5RSWwXz4Zmf9RcVebro2LlFnnHFFWX34gvWCfp4YzfQUTtAWY
         IHRu+6IsLBwWGMSsjyocXx7+rsy7rccT38cCKhDg=
Date:   Sat, 18 Jan 2020 14:56:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com,
        vdavydov.dev@gmail.com, stable@vger.kernel.org,
        rientjes@google.com, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, hannes@cmpxchg.org,
        richardw.yang@linux.intel.com
Subject:  +
 mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
 added to -mm tree
Message-ID: <20200118225605.Nvg0D%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: thp: don't need care deferred split queue in memcg charge move path
has been added to the -mm tree.  Its filename is
     mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm: thp: don't need care deferred split queue in memcg charge move path

If compound is true, this means it is a PMD mapped THP. Which implies
the page is not linked to any defer list. So the first code chunk will
not be executed.

Also with this reason, it would not be proper to add this page to a
defer list. So the second code chunk is not correct.

Based on this, we should remove the defer list related code.

[yang.shi@linux.alibaba.com: better patch title]
Link: http://lkml.kernel.org/r/20200117233836.3434-1-richardw.yang@linux.intel.com
Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>    [5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/mm/memcontrol.c~mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen
+++ a/mm/memcontrol.c
@@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struc
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
-	}
-#endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
@@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struc
 	/* caller should have done css_get */
 	page->mem_cgroup = to;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
-	}
-#endif
-
 	spin_unlock_irqrestore(&from->move_lock, flags);
 
 	ret = 0;
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch

