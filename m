Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3228C3DD942
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhHBN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236070AbhHBN47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722726115C;
        Mon,  2 Aug 2021 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912480;
        bh=Ix+EIv2FJ3EbJS8waMUtLO+G5ZHGIfvxMkbNAnRPKj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo6MFl0nW1zWNuzQUe13AjvYg6//4Yxi4/+sUDSd9J1vlE5C4F8q+FOvIaWRZasCR
         Ztb2gtbE5cd0wcCXCDmzv9DO77StHJ4gfePMvdSe2t9BO3KGX5EGOFnJlc+nbMRx/v
         KqiI0O5D1qhyDJlnFXn8iaqHqRe/Saz/7zyLREWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Down <chris@chrisdown.name>,
        Rik van Riel <riel@surriel.com>,
        Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 012/104] mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code
Date:   Mon,  2 Aug 2021 15:44:09 +0200
Message-Id: <20210802134344.419426208@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 30def93565e5ba08676aa2b9083f253fc586dbed upstream.

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
thresholding code is invoked during stat changes, and those contexts
have irqs disabled as well.  If the lock breaking occurs inside the
flush function, it will result in a sleep from an atomic context.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3394,7 +3394,8 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		cgroup_rstat_flush(memcg->css.cgroup);
+		/* mem_cgroup_threshold() calls here from irqsafe context */
+		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)


