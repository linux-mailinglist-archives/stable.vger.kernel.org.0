Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCADE5865A4
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiHAH3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 03:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHAH3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 03:29:33 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACFF2F67E;
        Mon,  1 Aug 2022 00:29:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VL2sBHM_1659338966;
Received: from localhost.localdomain(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0VL2sBHM_1659338966)
          by smtp.aliyun-inc.com;
          Mon, 01 Aug 2022 15:29:27 +0800
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 1/3] bpf: Consolidate shared test timing code
Date:   Mon,  1 Aug 2022 15:29:14 +0800
Message-Id: <20220801072916.29586-2-dtcccc@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
References: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit 607b9cc92bd7208338d714a22b8082fe83bcb177 upstream.

Share the timing / signal interruption logic between different
implementations of PROG_TEST_RUN. There is a change in behaviour
as well. We check the loop exit condition before checking for
pending signals. This resolves an edge case where a signal
arrives during the last iteration. Instead of aborting with
EINTR we return the successful result to user space.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210303101816.36774-2-lmb@cloudflare.com
[dtcccc: fix conflicts in bpf_test_run()]
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
---
 net/bpf/test_run.c | 140 +++++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 62 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index eb684f31fd69..d2a4f04df1da 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -16,14 +16,78 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
 
+struct bpf_test_timer {
+	enum { NO_PREEMPT, NO_MIGRATE } mode;
+	u32 i;
+	u64 time_start, time_spent;
+};
+
+static void bpf_test_timer_enter(struct bpf_test_timer *t)
+	__acquires(rcu)
+{
+	rcu_read_lock();
+	if (t->mode == NO_PREEMPT)
+		preempt_disable();
+	else
+		migrate_disable();
+
+	t->time_start = ktime_get_ns();
+}
+
+static void bpf_test_timer_leave(struct bpf_test_timer *t)
+	__releases(rcu)
+{
+	t->time_start = 0;
+
+	if (t->mode == NO_PREEMPT)
+		preempt_enable();
+	else
+		migrate_enable();
+	rcu_read_unlock();
+}
+
+static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *err, u32 *duration)
+	__must_hold(rcu)
+{
+	t->i++;
+	if (t->i >= repeat) {
+		/* We're done. */
+		t->time_spent += ktime_get_ns() - t->time_start;
+		do_div(t->time_spent, t->i);
+		*duration = t->time_spent > U32_MAX ? U32_MAX : (u32)t->time_spent;
+		*err = 0;
+		goto reset;
+	}
+
+	if (signal_pending(current)) {
+		/* During iteration: we've been cancelled, abort. */
+		*err = -EINTR;
+		goto reset;
+	}
+
+	if (need_resched()) {
+		/* During iteration: we need to reschedule between runs. */
+		t->time_spent += ktime_get_ns() - t->time_start;
+		bpf_test_timer_leave(t);
+		cond_resched();
+		bpf_test_timer_enter(t);
+	}
+
+	/* Do another round. */
+	return true;
+
+reset:
+	t->i = 0;
+	return false;
+}
+
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
+	struct bpf_test_timer t = { NO_MIGRATE };
 	enum bpf_cgroup_storage_type stype;
-	u64 time_start, time_spent = 0;
-	int ret = 0;
-	u32 i;
+	int ret;
 
 	for_each_cgroup_storage_type(stype) {
 		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
@@ -38,10 +102,8 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	if (!repeat)
 		repeat = 1;
 
-	rcu_read_lock();
-	migrate_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	bpf_test_timer_enter(&t);
+	do {
 		ret = bpf_cgroup_storage_set(storage);
 		if (ret)
 			break;
@@ -53,29 +115,8 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 
 		bpf_cgroup_storage_unset();
 
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		if (need_resched()) {
-			time_spent += ktime_get_ns() - time_start;
-			migrate_enable();
-			rcu_read_unlock();
-
-			cond_resched();
-
-			rcu_read_lock();
-			migrate_disable();
-			time_start = ktime_get_ns();
-		}
-	}
-	time_spent += ktime_get_ns() - time_start;
-	migrate_enable();
-	rcu_read_unlock();
-
-	do_div(time_spent, repeat);
-	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	} while (bpf_test_timer_continue(&t, repeat, &ret, time));
+	bpf_test_timer_leave(&t);
 
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(storage[stype]);
@@ -688,18 +729,17 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr)
 {
+	struct bpf_test_timer t = { NO_PREEMPT };
 	u32 size = kattr->test.data_size_in;
 	struct bpf_flow_dissector ctx = {};
 	u32 repeat = kattr->test.repeat;
 	struct bpf_flow_keys *user_ctx;
 	struct bpf_flow_keys flow_keys;
-	u64 time_start, time_spent = 0;
 	const struct ethhdr *eth;
 	unsigned int flags = 0;
 	u32 retval, duration;
 	void *data;
 	int ret;
-	u32 i;
 
 	if (prog->type != BPF_PROG_TYPE_FLOW_DISSECTOR)
 		return -EINVAL;
@@ -735,39 +775,15 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	ctx.data = data;
 	ctx.data_end = (__u8 *)data + size;
 
-	rcu_read_lock();
-	preempt_disable();
-	time_start = ktime_get_ns();
-	for (i = 0; i < repeat; i++) {
+	bpf_test_timer_enter(&t);
+	do {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
 					  size, flags);
+	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	bpf_test_timer_leave(&t);
 
-		if (signal_pending(current)) {
-			preempt_enable();
-			rcu_read_unlock();
-
-			ret = -EINTR;
-			goto out;
-		}
-
-		if (need_resched()) {
-			time_spent += ktime_get_ns() - time_start;
-			preempt_enable();
-			rcu_read_unlock();
-
-			cond_resched();
-
-			rcu_read_lock();
-			preempt_disable();
-			time_start = ktime_get_ns();
-		}
-	}
-	time_spent += ktime_get_ns() - time_start;
-	preempt_enable();
-	rcu_read_unlock();
-
-	do_div(time_spent, repeat);
-	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	if (ret < 0)
+		goto out;
 
 	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
 			      retval, duration);
-- 
2.27.0

