Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1BA4CF77E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiCGJqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B4DB8E;
        Mon,  7 Mar 2022 01:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 640B8B810B2;
        Mon,  7 Mar 2022 09:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCCCC340E9;
        Mon,  7 Mar 2022 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646034;
        bh=c13dRu7yauQhHB1XoNo/WGE5MsvdDFUEyJtchoxTz8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMlYMGAEVbgNVDKMbvQd7Uolxak7wLJLHa1abqMhcp3QaX3Bh2ldDIn07ddDwvKuu
         7d15+xqYfPlR9cfjmVV4zU99FIEtrAcn73oa/pZP7mhhc2gURCwxcAOxm6tUr+uAmA
         kS51MmwkPEdpYkQ9vYchDRMD5cr/P7NKQhyOzqVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/262] bpf: Use u64_stats_t in struct bpf_prog_stats
Date:   Mon,  7 Mar 2022 10:17:36 +0100
Message-Id: <20220307091705.632463395@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 61a0abaee2092eee69e44fe60336aa2f5b578938 ]

Commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
fixed possible load/store tearing on 64bit arches.

For instance the following C code

stats->nsecs += sched_clock() - start;

Could be rightfully implemented like this by a compiler,
confusing concurrent readers a lot:

stats->nsecs += sched_clock();
// arbitrary delay
stats->nsecs -= start;

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211026214133.3114279-4-eric.dumazet@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h  | 10 +++++-----
 kernel/bpf/syscall.c    | 18 ++++++++++++------
 kernel/bpf/trampoline.c |  6 +++---
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1611dc9d44207..a9956b681f090 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -554,9 +554,9 @@ struct bpf_binary_header {
 };
 
 struct bpf_prog_stats {
-	u64 cnt;
-	u64 nsecs;
-	u64 misses;
+	u64_stats_t cnt;
+	u64_stats_t nsecs;
+	u64_stats_t misses;
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
@@ -618,8 +618,8 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	} else {
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 53384622e8dac..42490c39dfbf5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1824,8 +1824,14 @@ static int bpf_prog_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+struct bpf_prog_kstats {
+	u64 nsecs;
+	u64 cnt;
+	u64 misses;
+};
+
 static void bpf_prog_get_stats(const struct bpf_prog *prog,
-			       struct bpf_prog_stats *stats)
+			       struct bpf_prog_kstats *stats)
 {
 	u64 nsecs = 0, cnt = 0, misses = 0;
 	int cpu;
@@ -1838,9 +1844,9 @@ static void bpf_prog_get_stats(const struct bpf_prog *prog,
 		st = per_cpu_ptr(prog->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&st->syncp);
-			tnsecs = st->nsecs;
-			tcnt = st->cnt;
-			tmisses = st->misses;
+			tnsecs = u64_stats_read(&st->nsecs);
+			tcnt = u64_stats_read(&st->cnt);
+			tmisses = u64_stats_read(&st->misses);
 		} while (u64_stats_fetch_retry_irq(&st->syncp, start));
 		nsecs += tnsecs;
 		cnt += tcnt;
@@ -1856,7 +1862,7 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_prog *prog = filp->private_data;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 
 	bpf_prog_get_stats(prog, &stats);
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
@@ -3595,7 +3601,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 	char __user *uinsns;
 	u32 ulen;
 	int err;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d3a307a8c42b9..6933a9bfee637 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -544,7 +544,7 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
 
 	stats = this_cpu_ptr(prog->stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->misses++;
+	u64_stats_inc(&stats->misses);
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -589,8 +589,8 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
-- 
2.34.1



