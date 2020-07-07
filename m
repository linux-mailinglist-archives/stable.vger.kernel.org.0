Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2056B217AED
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 00:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgGGWSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 18:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgGGWSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 18:18:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95A220720;
        Tue,  7 Jul 2020 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594160281;
        bh=jh4rhaChCfomJImuGvre4JC3WkoS6/+2DIzxc+A1dtA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QNZUKkdwTu8W/R69xfWjNIMO88aL0oE8tcMzHLziCMzj8yH/squ+fLyR3EJ0nKiUN
         OkBJqq/WnG+GqlJ9fYlWNkY7to8yl+ZXtfDxJFHSHC+Ui4DE2tUrFncStOUotIBVcR
         WBX5PfTaTKv3QOAP9bMdU3bDHgNJr79T0OV6ZUoc=
Date:   Tue, 07 Jul 2020 15:18:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alex.shi@linux.alibaba.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  +
 mm-memcg-fix-refcount-error-while-moving-and-swapping.patch added to -mm
 tree
Message-ID: <20200707221800.IrLXfMRm9%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix refcount error while moving and swapping
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-refcount-error-while-moving-and-swapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-refcount-error-while-moving-and-swapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-refcount-error-while-moving-and-swapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: fix refcount error while moving and swapping

It was hard to keep a test running, moving tasks between memcgs with
move_charge_at_immigrate, while swapping: mem_cgroup_id_get_many()'s
refcount is discovered to be 0 (supposedly impossible), so it is then
forced to REFCOUNT_SATURATED, and after thousands of warnings in quick
succession, the test is at last put out of misery by being OOM killed.

This is because of the way moved_swap accounting was saved up until the
task move gets completed in __mem_cgroup_clear_mc(), deferred from when
mem_cgroup_move_swap_account() actually exchanged old and new ids. 
Concurrent activity can free up swap quicker than the task is scanned,
bringing id refcount down 0 (which should only be possible when
offlining).

Just skip that optimization: do that part of the accounting immediately.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2007071431050.4726@eggly.anvils
Fixes: 615d66c37c75 ("mm: memcontrol: fix memcg id ref counter on swap charge move")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-refcount-error-while-moving-and-swapping
+++ a/mm/memcontrol.c
@@ -5669,7 +5669,6 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		mem_cgroup_id_get_many(mc.to, mc.moved_swap);
 		css_put_many(&mc.to->css, mc.moved_swap);
 
 		mc.moved_swap = 0;
@@ -5860,7 +5859,8 @@ put:			/* get_mctgt_type() gets the page
 			ent = target.ent;
 			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
 				mc.precharge--;
-				/* we fixup refcnts and charges later. */
+				mem_cgroup_id_get_many(mc.to, 1);
+				/* we fixup other refcnts and charges later. */
 				mc.moved_swap++;
 			}
 			break;
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcg-fix-refcount-error-while-moving-and-swapping.patch

