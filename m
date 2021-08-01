Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3493DCD33
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 21:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhHATMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 15:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHATMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Aug 2021 15:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE66F61059;
        Sun,  1 Aug 2021 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627845117;
        bh=Syeh1lCF5/JHyYWrWl2wFmvsdWXHfUpr2p43fB5d/sc=;
        h=Date:From:To:Subject:From;
        b=iLeW9WCOem5msw7zfSTAqDCDggnYhgk0SSYcWJMeHVrr8HteBf9qMr/joAShtyadF
         PFNzQWUKUKievOxxy726Dwcfy2wSQjkjWLgdzUNSFHhQWkYn1/z8smmml6w3Tajobo
         YokoYpAVZ/h1J1CmFRAdvXhF2/Tho/KqgLdKdjOw=
Date:   Sun, 01 Aug 2021 12:11:57 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, dan.carpenter@oracle.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        shakeelb@google.com, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memcontrol-fix-blocking-rstat-function-called-from-atomic?=
 =?US-ASCII?Q?-cgroup1-thresholding-code.patch?= removed from -mm tree
Message-ID: <20210801191157._NKo6lYAE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-blocking-rstat-function-called-from-atomic-cgroup1-thresholding-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code

Dan Carpenter reports:

    The patch 2d146aa3aa84: "mm: memcontrol: switch to rstat" from Apr
    29, 2021, leads to the following static checker warning:

	    kernel/cgroup/rstat.c:200 cgroup_rstat_flush()
	    warn: sleeping in atomic context

    mm/memcontrol.c
      3572  static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
      3573  {
      3574          unsigned long val;
      3575
      3576          if (mem_cgroup_is_root(memcg)) {
      3577                  cgroup_rstat_flush(memcg->css.cgroup);
			    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    This is from static analysis and potentially a false positive.  The
    problem is that mem_cgroup_usage() is called from __mem_cgroup_threshold()
    which holds an rcu_read_lock().  And the cgroup_rstat_flush() function
    can sleep.

      3578                  val = memcg_page_state(memcg, NR_FILE_PAGES) +
      3579                          memcg_page_state(memcg, NR_ANON_MAPPED);
      3580                  if (swap)
      3581                          val += memcg_page_state(memcg, MEMCG_SWAP);
      3582          } else {
      3583                  if (!swap)
      3584                          val = page_counter_read(&memcg->memory);
      3585                  else
      3586                          val = page_counter_read(&memcg->memsw);
      3587          }
      3588          return val;
      3589  }

__mem_cgroup_threshold() indeed holds the rcu lock.  In addition, the
thresholding code is invoked during stat changes, and those contexts have
irqs disabled as well.  If the lock breaking occurs inside the flush
function, it will result in a sleep from an atomic context.

Use the irqsafe flushing variant in mem_cgroup_usage() to fix this.

Link: https://lkml.kernel.org/r/20210726150019.251820-1-hannes@cmpxchg.org
Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-blocking-rstat-function-called-from-atomic-cgroup1-thresholding-code
+++ a/mm/memcontrol.c
@@ -3574,7 +3574,8 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		cgroup_rstat_flush(memcg->css.cgroup);
+		/* mem_cgroup_threshold() calls here from irqsafe context */
+		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

