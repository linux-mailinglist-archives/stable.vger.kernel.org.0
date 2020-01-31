Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD014E8A3
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgAaGLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 422A720663;
        Fri, 31 Jan 2020 06:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451081;
        bh=ejarE+y0OViZxzeFVS7W7uaA79PRLRXmuUFtmoZWAMk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Flmjbxgh8Qk7Wn2TAKUuQzxKveuMiDLsGbZ8Wf1sVgTwotSMCm51HXHlaTPNtzsJ5
         JVY3LnZFvzB4ts+WL24ob2FDuB1JkVRPkpdUuGWJEdGZoh+wQyLmgNAi/UCfLNO2OJ
         shxjBtHc87yLPAfVO1cDCR8PbsfVS85lbiZDPMEI=
Date:   Thu, 30 Jan 2020 22:11:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richardw.yang@linux.intel.com, rientjes@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com
Subject:  [patch 007/118] mm: thp: don't need care deferred split
 queue in memcg charge move path
Message-ID: <20200131061120.Dchl2XxfT%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
