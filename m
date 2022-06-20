Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889C25519AC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242349AbiFTNEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244023AbiFTNCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:02:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511E219008;
        Mon, 20 Jun 2022 05:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE78B811A3;
        Mon, 20 Jun 2022 12:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3C9C3411B;
        Mon, 20 Jun 2022 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729855;
        bh=fhDHOpT5UB8R05poRAfCYJlJkd3xObPZ2ivB/X4YfXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haWxKm2WMylIhAmMSH13tBZgbwZ7ULLRVbnJQz3WEMD+rmithK3SoW7jLvH6nWT45
         E+XfL5p4oyaIbc4i/26//ApaSbP/ekTFuEbGwuuS1hOCLE0oSSYEZWLAUf+4Fv9oaF
         MrMEQ3Ckgmk8R/Y53WEOBbLOR5hcDHPbtfozSIXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing-Ting Wu <jing-ting.wu@mediatek.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 097/141] sched: Fix balance_push() vs __sched_setscheduler()
Date:   Mon, 20 Jun 2022 14:50:35 +0200
Message-Id: <20220620124732.411011417@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 04193d590b390ec7a0592630f46d559ec6564ba1 ]

The purpose of balance_push() is to act as a filter on task selection
in the case of CPU hotplug, specifically when taking the CPU out.

It does this by (ab)using the balance callback infrastructure, with
the express purpose of keeping all the unlikely/odd cases in a single
place.

In order to serve its purpose, the balance_push_callback needs to be
(exclusively) on the callback list at all times (noting that the
callback always places itself back on the list the moment it runs,
also noting that when the CPU goes down, regular balancing concerns
are moot, so ignoring them is fine).

And here-in lies the problem, __sched_setscheduler()'s use of
splice_balance_callbacks() takes the callbacks off the list across a
lock-break, making it possible for, an interleaving, __schedule() to
see an empty list and not get filtered.

Fixes: ae7927023243 ("sched: Optimize finish_lock_switch()")
Reported-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Link: https://lkml.kernel.org/r/20220519134706.GH2578@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 36 +++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h |  5 +++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e58d894df207..dd11daa7a84b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4755,25 +4755,55 @@ static void do_balance_callbacks(struct rq *rq, struct callback_head *head)
 
 static void balance_push(struct rq *rq);
 
+/*
+ * balance_push_callback is a right abuse of the callback interface and plays
+ * by significantly different rules.
+ *
+ * Where the normal balance_callback's purpose is to be ran in the same context
+ * that queued it (only later, when it's safe to drop rq->lock again),
+ * balance_push_callback is specifically targeted at __schedule().
+ *
+ * This abuse is tolerated because it places all the unlikely/odd cases behind
+ * a single test, namely: rq->balance_callback == NULL.
+ */
 struct callback_head balance_push_callback = {
 	.next = NULL,
 	.func = (void (*)(struct callback_head *))balance_push,
 };
 
-static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+static inline struct callback_head *
+__splice_balance_callbacks(struct rq *rq, bool split)
 {
 	struct callback_head *head = rq->balance_callback;
 
+	if (likely(!head))
+		return NULL;
+
 	lockdep_assert_rq_held(rq);
-	if (head)
+	/*
+	 * Must not take balance_push_callback off the list when
+	 * splice_balance_callbacks() and balance_callbacks() are not
+	 * in the same rq->lock section.
+	 *
+	 * In that case it would be possible for __schedule() to interleave
+	 * and observe the list empty.
+	 */
+	if (split && head == &balance_push_callback)
+		head = NULL;
+	else
 		rq->balance_callback = NULL;
 
 	return head;
 }
 
+static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+{
+	return __splice_balance_callbacks(rq, true);
+}
+
 static void __balance_callbacks(struct rq *rq)
 {
-	do_balance_callbacks(rq, splice_balance_callbacks(rq));
+	do_balance_callbacks(rq, __splice_balance_callbacks(rq, false));
 }
 
 static inline void balance_callbacks(struct rq *rq, struct callback_head *head)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0d2b6b758f32..84bba67c92dc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1686,6 +1686,11 @@ queue_balance_callback(struct rq *rq,
 {
 	lockdep_assert_rq_held(rq);
 
+	/*
+	 * Don't (re)queue an already queued item; nor queue anything when
+	 * balance_push() is active, see the comment with
+	 * balance_push_callback.
+	 */
 	if (unlikely(head->next || rq->balance_callback == &balance_push_callback))
 		return;
 
-- 
2.35.1



