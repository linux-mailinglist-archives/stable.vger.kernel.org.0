Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E539B3DAE8D
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhG2Vxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 17:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhG2Vxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153E360F4B;
        Thu, 29 Jul 2021 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595625;
        bh=T8myYaSeYJGUG6e2uICIz9ocg2CRyodLBfAmwO8PGr8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZLOibavFOxD+pKfq+Jg91Kc77vaemR4JudGhjVNjWe7zIE+z45RsUjnv2amEBP0Qb
         tSAnG8wPRcjZGSvfItEYZIz1bWtRGw1VdcmV6aP36nPKF8HHK4yO7XvNH8fZHVu6zY
         MRnFkyvmXSoG0y2q01vNq7MJo/YReIHEu1ztoMWo=
Date:   Thu, 29 Jul 2021 14:53:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        dan.carpenter@oracle.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 4/7] mm: memcontrol: fix blocking rstat function
 called from atomic cgroup1 thresholding code
Message-ID: <20210729215344.0pEJL7fxK%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
