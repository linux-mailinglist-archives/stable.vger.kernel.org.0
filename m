Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492D9421010
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhJDNk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238530AbhJDNim (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A436561B40;
        Mon,  4 Oct 2021 13:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353464;
        bh=oUY6r6g2zJSANNMIJWvWggTv5+RsvlHHqu1DztCnh3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cc1DJP/b6mIXIlyKrCCLxxKkAuMjulDjln/dcVw4JEQnaNxFZnEEOOe2od7lobwxd
         DXrkS6JTe2PS+uHpALqSD4JqMhmKENFpfB4oWifAOOcG2Oa4Is6uD3jl+vPnS7S6zy
         LQYj1CW1/keE8rzUk5WCFVe8nkfAWHNW04szf2Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Odin Ugedal <odin@uged.al>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 139/172] sched/fair: Add ancestors of unthrottled undecayed cfs_rq
Date:   Mon,  4 Oct 2021 14:53:09 +0200
Message-Id: <20211004125049.457079331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 2630cde26711dab0d0b56a8be1616475be646d13 ]

Since commit a7b359fc6a37 ("sched/fair: Correctly insert cfs_rq's to
list on unthrottle") we add cfs_rqs with no runnable tasks but not fully
decayed into the load (leaf) list. We may ignore adding some ancestors
and therefore breaking tmp_alone_branch invariant. This broke LTP test
cfs_bandwidth01 and it was partially fixed in commit fdaba61ef8a2
("sched/fair: Ensure that the CFS parent is added after unthrottling").

I noticed the named test still fails even with the fix (but with low
probability, 1 in ~1000 executions of the test). The reason is when
bailing out of unthrottle_cfs_rq early, we may miss adding ancestors of
the unthrottled cfs_rq, thus, not joining tmp_alone_branch properly.

Fix this by adding ancestors if we notice the unthrottled cfs_rq was
added to the load list.

Fixes: a7b359fc6a37 ("sched/fair: Correctly insert cfs_rq's to list on unthrottle")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Odin Ugedal <odin@uged.al>
Link: https://lore.kernel.org/r/20210917153037.11176-1-mkoutny@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30a6984a58f7..423ec671a306 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4898,8 +4898,12 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
-	if (!cfs_rq->load.weight)
+	/* Nothing to run but something to decay (on_list)? Complete the branch */
+	if (!cfs_rq->load.weight) {
+		if (cfs_rq->on_list)
+			goto unthrottle_throttle;
 		return;
+	}
 
 	task_delta = cfs_rq->h_nr_running;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
-- 
2.33.0



