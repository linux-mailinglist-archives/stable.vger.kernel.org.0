Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150093A6164
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhFNKq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234265AbhFNKou (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:44:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F9561408;
        Mon, 14 Jun 2021 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666985;
        bh=oby5e+s34eoWajW9Ai77zBtVrNbOCTegEtojlNx+RYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XySsZj/YWGH7GFCUexOCJZCSJHOhY4aPS4BuX+pFdr7HswhicbSN6mwqI+DRtCPL1
         LreDEzk99AHHiCG3eWe/gAJsLepxCXjUJA9lCuhPeOdNpAwmFbUjGQ5RMvet1GSGWE
         rOklIwOu6p+eryVilX7hQ0c/9dhmTUP3CC59IdLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 54/67] sched/fair: Make sure to update tg contrib for blocked load
Date:   Mon, 14 Jun 2021 12:27:37 +0200
Message-Id: <20210614102645.595560769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 02da26ad5ed6ea8680e5d01f20661439611ed776 upstream.

During the update of fair blocked load (__update_blocked_fair()), we
update the contribution of the cfs in tg->load_avg if cfs_rq's pelt
has decayed.  Nevertheless, the pelt values of a cfs_rq could have
been recently updated while propagating the change of a child. In this
case, cfs_rq's pelt will not decayed because it has already been
updated and we don't update tg->load_avg.

__update_blocked_fair
  ...
  for_each_leaf_cfs_rq_safe: child cfs_rq
    update cfs_rq_load_avg() for child cfs_rq
    ...
    update_load_avg(cfs_rq_of(se), se, 0)
      ...
      update cfs_rq_load_avg() for parent cfs_rq
		-propagation of child's load makes parent cfs_rq->load_sum
		 becoming null
        -UPDATE_TG is not set so it doesn't update parent
		 cfs_rq->tg_load_avg_contrib
  ..
  for_each_leaf_cfs_rq_safe: parent cfs_rq
    update cfs_rq_load_avg() for parent cfs_rq
      - nothing to do because parent cfs_rq has already been updated
		recently so cfs_rq->tg_load_avg_contrib is not updated
    ...
    parent cfs_rq is decayed
      list_del_leaf_cfs_rq parent cfs_rq
	  - but it still contibutes to tg->load_avg

we must set UPDATE_TG flags when propagting pending load to the parent

Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
Reported-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Odin Ugedal <odin@uged.al>
Link: https://lkml.kernel.org/r/20210527122916.27683-3-vincent.guittot@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7512,7 +7512,7 @@ static void update_blocked_averages(int
 		/* Propagate pending load changes to the parent, if any: */
 		se = cfs_rq->tg->se[cpu];
 		if (se && !skip_blocked_update(se))
-			update_load_avg(cfs_rq_of(se), se, 0);
+			update_load_avg(cfs_rq_of(se), se, UPDATE_TG);
 
 		/*
 		 * There can be a lot of idle CPU cgroups.  Don't let fully


