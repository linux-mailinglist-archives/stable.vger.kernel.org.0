Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD405129A93
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 20:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLWTvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 14:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfLWTvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 14:51:37 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F31206B7;
        Mon, 23 Dec 2019 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577130696;
        bh=/0UqyxLP9PhhVlx/M31LoxeAEq/RQPtAy28UYxCkrbM=;
        h=Date:From:To:Subject:From;
        b=UlfxUWsWNX3QNUaYp3W+mZnVEs+WyvPQyzN2zQPuGPbdoQCQanpJx2i8o1cfWfNEc
         DhyPG0dJUnY7T9Gllxo3nSoY4anAaZz7XNCLcmwbQUi1U4J5SsQXR645m7/Ess/m6X
         tuUHULEiuxQW0vIswGva01s00gSH3tOlewWeOOoQ=
Date:   Mon, 23 Dec 2019 11:51:36 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-vmscan-protect-shrinker-idr-replace-with-config_memcg.patch removed from
 -mm tree
Message-ID: <20191223195136.REASfxwIT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG
has been removed from the -mm tree.  Its filename was
     mm-vmscan-protect-shrinker-idr-replace-with-config_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG

Since commit 0a432dcbeb32edc ("mm: shrinker: make shrinker not depend on
memcg kmem"), shrinkers' idr is protected by CONFIG_MEMCG instead of
CONFIG_MEMCG_KMEM, so it makes no sense to protect shrinker idr replace
with CONFIG_MEMCG_KMEM.

And in the CONFIG_MEMCG && CONFIG_SLOB case, shrinker_idr contains only
shrinker, and it is deferred_split_shrinker.  But it is never actually
called, since idr_replace() is never compiled due to the wrong #ifdef. 
The deferred_split_shrinker all the time is staying in half-registered
state, and it's never called for subordinate mem cgroups.

Link: http://lkml.kernel.org/r/1575486978-45249-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-protect-shrinker-idr-replace-with-config_memcg
+++ a/mm/vmscan.c
@@ -387,7 +387,7 @@ void register_shrinker_prepared(struct s
 {
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		idr_replace(&shrinker_idr, shrinker, shrinker->id);
 #endif
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-move_pages-return-valid-node-id-in-status-if-the-page-is-already-on-the-target-node.patch

