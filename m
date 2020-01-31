Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC914F524
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 00:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAaXQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 18:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:47 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CB442071A;
        Fri, 31 Jan 2020 23:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512605;
        bh=Bb8dbKfhOuBZvisjx5Wkxd9/QleM0QH3bX201+zhFwg=;
        h=Date:From:To:Subject:From;
        b=rX8FIUHQf/vbYxToTUnU1EY0oQ+ADB8HvOAU0NxAq5MPcOodI4uTjosbQoOrA1kiL
         /5jwUHokbs2H7drtebqQszCxcDkWG+9u6qfeW0c4OOoEpOEzuN1iZXbXo7EHwXvHzt
         8CaOQQtKlvyt0jiqQRU/ugFEAhGr836FazS9Cfe8=
Date:   Fri, 31 Jan 2020 15:16:45 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, kirill.shutemov@linux.intel.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richardw.yang@linux.intel.com, rientjes@google.com,
        stable@vger.kernel.org, vdavydov.dev@gmail.com,
        yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
 removed from -mm tree
Message-ID: <20200131231645.15-xzFrn2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: thp: don't need care deferred split queue in memcg charge move path
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


