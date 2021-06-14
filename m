Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7203A6485
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhFNL0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235941AbhFNLYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224056140B;
        Mon, 14 Jun 2021 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667999;
        bh=ZeolnNeHAsD23tiJ+VYHj1ILRD6OzkoNPrJA6e5kj/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkK/Y+UcHZPcw+SN9aAHgxaWfZTa1de8A4gnQuDPwmDJGeJhivHjgbiDEAkhWOECX
         asKGD5e3J4qkKndHim8WnX1wQHgRwpitMAprEbqMhTAyaOnhqGtR4ZhKmUVo0OyEbz
         goiAH3h7jkRR9+Isd/P5UbgvECicm4jg8Bcbc8RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 155/173] sched/fair: Make sure to update tg contrib for blocked load
Date:   Mon, 14 Jun 2021 12:28:07 +0200
Message-Id: <20210614102703.323815507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
@@ -8005,7 +8005,7 @@ static bool __update_blocked_fair(struct
 		/* Propagate pending load changes to the parent, if any: */
 		se = cfs_rq->tg->se[cpu];
 		if (se && !skip_blocked_update(se))
-			update_load_avg(cfs_rq_of(se), se, 0);
+			update_load_avg(cfs_rq_of(se), se, UPDATE_TG);
 
 		/*
 		 * There can be a lot of idle CPU cgroups.  Don't let fully


