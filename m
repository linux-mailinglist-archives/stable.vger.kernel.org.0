Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D28A63592D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiKWKJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbiKWKIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E2959FC8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F18561B5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294DFC433C1;
        Wed, 23 Nov 2022 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197495;
        bh=Wsgk9B9ibQKnSKhxbQMpuw1MKUj0bTEKFbDa7TQjK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYhksMNsI2y3ck9wOLVgjPj7PQREiUaN3Ve50g773kumqE6x4JyqoGyZM5rwByTD6
         Fa9x78pkqBH/Smg/R78wgMystWLyyc4CflcaNGejOVylBYmlXjgwbv5gqxZOBMjY1y
         OeMNJY4C9sEgbEDuukKcFI6/2vrixfMicrO7X588=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        syzbot+2251879aa068ad9c960d@syzkaller.appspotmail.com,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 311/314] bpf: Prevent bpf program recursion for raw tracepoint probes
Date:   Wed, 23 Nov 2022 09:52:36 +0100
Message-Id: <20221123084639.677872088@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 05b24ff9b2cfabfcfd951daaa915a036ab53c9e1 upstream.

We got report from sysbot [1] about warnings that were caused by
bpf program attached to contention_begin raw tracepoint triggering
the same tracepoint by using bpf_trace_printk helper that takes
trace_printk_lock lock.

 Call Trace:
  <TASK>
  ? trace_event_raw_event_bpf_trace_printk+0x5f/0x90
  bpf_trace_printk+0x2b/0xe0
  bpf_prog_a9aec6167c091eef_prog+0x1f/0x24
  bpf_trace_run2+0x26/0x90
  native_queued_spin_lock_slowpath+0x1c6/0x2b0
  _raw_spin_lock_irqsave+0x44/0x50
  bpf_trace_printk+0x3f/0xe0
  bpf_prog_a9aec6167c091eef_prog+0x1f/0x24
  bpf_trace_run2+0x26/0x90
  native_queued_spin_lock_slowpath+0x1c6/0x2b0
  _raw_spin_lock_irqsave+0x44/0x50
  bpf_trace_printk+0x3f/0xe0
  bpf_prog_a9aec6167c091eef_prog+0x1f/0x24
  bpf_trace_run2+0x26/0x90
  native_queued_spin_lock_slowpath+0x1c6/0x2b0
  _raw_spin_lock_irqsave+0x44/0x50
  bpf_trace_printk+0x3f/0xe0
  bpf_prog_a9aec6167c091eef_prog+0x1f/0x24
  bpf_trace_run2+0x26/0x90
  native_queued_spin_lock_slowpath+0x1c6/0x2b0
  _raw_spin_lock_irqsave+0x44/0x50
  __unfreeze_partials+0x5b/0x160
  ...

The can be reproduced by attaching bpf program as raw tracepoint on
contention_begin tracepoint. The bpf prog calls bpf_trace_printk
helper. Then by running perf bench the spin lock code is forced to
take slow path and call contention_begin tracepoint.

Fixing this by skipping execution of the bpf program if it's
already running, Using bpf prog 'active' field, which is being
currently used by trampoline programs for the same reason.

Moving bpf_prog_inc_misses_counter to syscall.c because
trampoline.c is compiled in just for CONFIG_BPF_JIT option.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
Reported-by: syzbot+2251879aa068ad9c960d@syzkaller.appspotmail.com
[1] https://lore.kernel.org/bpf/YxhFe3EwqchC%2FfYf@krava/T/#t
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220916071914.7156-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    5 +++++
 kernel/bpf/syscall.c     |   11 +++++++++++
 kernel/bpf/trampoline.c  |   15 ++-------------
 kernel/trace/bpf_trace.c |    6 ++++++
 4 files changed, 24 insertions(+), 13 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1967,6 +1967,7 @@ static inline bool unprivileged_ebpf_ena
 	return !sysctl_unprivileged_bpf_disabled;
 }
 
+void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2305,6 +2306,10 @@ static inline int sock_map_bpf_prog_quer
 {
 	return -EINVAL;
 }
+
+static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2094,6 +2094,17 @@ struct bpf_prog_kstats {
 	u64 misses;
 };
 
+void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog)
+{
+	struct bpf_prog_stats *stats;
+	unsigned int flags;
+
+	stats = this_cpu_ptr(prog->stats);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
+	u64_stats_inc(&stats->misses);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
+}
+
 static void bpf_prog_get_stats(const struct bpf_prog *prog,
 			       struct bpf_prog_kstats *stats)
 {
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -863,17 +863,6 @@ static __always_inline u64 notrace bpf_p
 	return start;
 }
 
-static void notrace inc_misses_counter(struct bpf_prog *prog)
-{
-	struct bpf_prog_stats *stats;
-	unsigned int flags;
-
-	stats = this_cpu_ptr(prog->stats);
-	flags = u64_stats_update_begin_irqsave(&stats->syncp);
-	u64_stats_inc(&stats->misses);
-	u64_stats_update_end_irqrestore(&stats->syncp, flags);
-}
-
 /* The logic is similar to bpf_prog_run(), but with an explicit
  * rcu_read_lock() and migrate_disable() which are required
  * for the trampoline. The macro is split into
@@ -896,7 +885,7 @@ u64 notrace __bpf_prog_enter(struct bpf_
 	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
 
 	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
+		bpf_prog_inc_misses_counter(prog);
 		return 0;
 	}
 	return bpf_prog_start_time();
@@ -967,7 +956,7 @@ u64 notrace __bpf_prog_enter_sleepable(s
 	might_fault();
 
 	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
-		inc_misses_counter(prog);
+		bpf_prog_inc_misses_counter(prog);
 		return 0;
 	}
 
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2058,9 +2058,15 @@ static __always_inline
 void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 {
 	cant_sleep();
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
+		bpf_prog_inc_misses_counter(prog);
+		goto out;
+	}
 	rcu_read_lock();
 	(void) bpf_prog_run(prog, args);
 	rcu_read_unlock();
+out:
+	this_cpu_dec(*(prog->active));
 }
 
 #define UNPACK(...)			__VA_ARGS__


