Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725EB586930
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiHAL6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiHAL5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:57:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC6D41997;
        Mon,  1 Aug 2022 04:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6F7612D0;
        Mon,  1 Aug 2022 11:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F4C433D7;
        Mon,  1 Aug 2022 11:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354726;
        bh=XdB4SfMjJFuNTvw5r7pQzIQBc4YOlKvLSEGBSh0lilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1lwBk6Q4BMycOVimPxusQphyB3J7Chxu5OcLmYpHW8doEIkwUiOpWeVmqbA7l7Iz
         ewZqw9pYZARmddhCl1lEjs6g8C2PVK3mw18aGDZYT1Fi7ra+6R53kJHo7DK3RMwHCW
         3NQ0VLCwGA91DPIGEjPVaizFBHtdRiwZSfiKg7YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH 5.10 63/65] bpf: Consolidate shared test timing code
Date:   Mon,  1 Aug 2022 13:47:20 +0200
Message-Id: <20220801114136.261188102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c |  140 +++++++++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 62 deletions(-)

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
@@ -38,10 +102,8 @@ static int bpf_test_run(struct bpf_prog
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
@@ -53,29 +115,8 @@ static int bpf_test_run(struct bpf_prog
 
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
@@ -688,18 +729,17 @@ int bpf_prog_test_run_flow_dissector(str
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
@@ -735,39 +775,15 @@ int bpf_prog_test_run_flow_dissector(str
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


