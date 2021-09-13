Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7955D4090D3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbhIMNzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242393AbhIMNxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E9A6112E;
        Mon, 13 Sep 2021 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540108;
        bh=uN5CR+OJnxeovHmH8+k1UfXVk3zkafDXS4D4RHTAj18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFpkrJMvbM6HnxWdblyBCvKwt2UjCY9ax9E+miVJ/iyrJK53X+gXhKhcYi8qrzQYc
         aFeNN6xe5C4uTmLqTq1NHQanWYC46mQZA6p4v6PB7rDXWIA3H7qxC5ye0vS6ePQLpB
         nfN0Z6oCu2jb4MnGKj3wBRtxDC837PFaqy7inYTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Yiu <rickyiu@google.com>,
        Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 053/300] sched: Fix UCLAMP_FLAG_IDLE setting
Date:   Mon, 13 Sep 2021 15:11:54 +0200
Message-Id: <20210913131111.150048708@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit ca4984a7dd863f3e1c0df775ae3e744bff24c303 ]

The UCLAMP_FLAG_IDLE flag is set on a runqueue when dequeueing the last
uclamp active task (that is, when buckets.tasks reaches 0 for all
buckets) to maintain the last uclamp.max and prevent blocked util from
suddenly becoming visible.

However, there is an asymmetry in how the flag is set and cleared which
can lead to having the flag set whilst there are active tasks on the rq.
Specifically, the flag is cleared in the uclamp_rq_inc() path, which is
called at enqueue time, but set in uclamp_rq_dec_id() which is called
both when dequeueing a task _and_ in the update_uclamp_active() path. As
a result, when both uclamp_rq_{dec,ind}_id() are called from
update_uclamp_active(), the flag ends up being set but not cleared,
hence leaving the runqueue in a broken state.

Fix this by clearing the flag in update_uclamp_active() as well.

Fixes: e496187da710 ("sched/uclamp: Enforce last task's UCLAMP_MAX")
Reported-by: Rick Yiu <rickyiu@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Qais Yousef <qais.yousef@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20210805102154.590709-2-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 15b4d2fb6be3..1e9672d609f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1281,6 +1281,23 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 		uclamp_rq_dec_id(rq, p, clamp_id);
 }
 
+static inline void uclamp_rq_reinc_id(struct rq *rq, struct task_struct *p,
+				      enum uclamp_id clamp_id)
+{
+	if (!p->uclamp[clamp_id].active)
+		return;
+
+	uclamp_rq_dec_id(rq, p, clamp_id);
+	uclamp_rq_inc_id(rq, p, clamp_id);
+
+	/*
+	 * Make sure to clear the idle flag if we've transiently reached 0
+	 * active tasks on rq.
+	 */
+	if (clamp_id == UCLAMP_MAX && (rq->uclamp_flags & UCLAMP_FLAG_IDLE))
+		rq->uclamp_flags &= ~UCLAMP_FLAG_IDLE;
+}
+
 static inline void
 uclamp_update_active(struct task_struct *p)
 {
@@ -1304,12 +1321,8 @@ uclamp_update_active(struct task_struct *p)
 	 * affecting a valid clamp bucket, the next time it's enqueued,
 	 * it will already see the updated clamp bucket value.
 	 */
-	for_each_clamp_id(clamp_id) {
-		if (p->uclamp[clamp_id].active) {
-			uclamp_rq_dec_id(rq, p, clamp_id);
-			uclamp_rq_inc_id(rq, p, clamp_id);
-		}
-	}
+	for_each_clamp_id(clamp_id)
+		uclamp_rq_reinc_id(rq, p, clamp_id);
 
 	task_rq_unlock(rq, p, &rf);
 }
-- 
2.30.2



