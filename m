Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA45F9115
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiJIWa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiJIW1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:27:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E651427FFA;
        Sun,  9 Oct 2022 15:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1696FB80DE1;
        Sun,  9 Oct 2022 22:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371D1C433C1;
        Sun,  9 Oct 2022 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353924;
        bh=73g0JsSReowuNUCn5pgQKkzbNbSYaz9WNv4ymMmfb/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwe5siJw4A6UwupHqnSqhUGEQGJmijq3u8fI9vGx+u5QnDX/FRWSiUoVCcZk4AaqY
         ElkgzyaQn5wL3gdFG904vKqUCwqJ8xR6YP9Zs5vbv5mvfp1InnCXZcLkhqM40eoEK9
         DCd0MC8vrXEpFi/WTYrYsGkf2kATzJesoKPRYkMVzv5v2choTC4p/yRlOxVA5sep2I
         ytaHh134UjLBJMCtbifwQiVzCG3p9iCQqn0zfPveG2uul1iE6Rk0EfgtGK/75r33Mm
         pfImfqazSbnsApG3ljgfzPQCoHa8c5ASnnmssQFiYxthLLyT+FtYb2LAuLZPf/Ml1A
         5EvQjzjT1jXtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        song@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        shuah@kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 65/73] bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT
Date:   Sun,  9 Oct 2022 18:14:43 -0400
Message-Id: <20221009221453.1216158-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit c09eb2e578eb1668bbc84dc07e8d8bd6f04b9a02 ]

Martynas reported bpf_get_func_ip returning +4 address when
CONFIG_X86_KERNEL_IBT option is enabled.

When CONFIG_X86_KERNEL_IBT is enabled we'll have endbr instruction
at the function entry, which screws return value of bpf_get_func_ip()
helper that should return the function address.

There's short term workaround for kprobe_multi bpf program made by
Alexei [1], but we need this fixup also for bpf_get_attach_cookie,
that returns cookie based on the entry_ip value.

Moving the fixup in the fprobe handler, so both bpf_get_func_ip
and bpf_get_attach_cookie get expected function address when
CONFIG_X86_KERNEL_IBT option is enabled.

Also renaming kprobe_multi_link_handler entry_ip argument to fentry_ip
so it's clearer this is an ftrace __fentry__ ip.

[1] commit 7f0059b58f02 ("selftests/bpf: Fix kprobe_multi test.")

Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Martynas Pumputis <m@lambda.lt>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220926153340.1621984-5-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c                      | 20 +++++++++++++++++--
 .../selftests/bpf/progs/kprobe_multi.c        |  4 +---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 88589d74a892..af13fdf1d86c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1026,6 +1026,22 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+#ifdef CONFIG_X86_KERNEL_IBT
+static unsigned long get_entry_ip(unsigned long fentry_ip)
+{
+	u32 instr;
+
+	/* Being extra safe in here in case entry ip is on the page-edge. */
+	if (get_kernel_nofault(instr, (u32 *) fentry_ip - 1))
+		return fentry_ip;
+	if (is_endbr(instr))
+		fentry_ip -= ENDBR_INSN_SIZE;
+	return fentry_ip;
+}
+#else
+#define get_entry_ip(fentry_ip) fentry_ip
+#endif
+
 BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
 {
 	struct kprobe *kp = kprobe_running();
@@ -2414,13 +2430,13 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 }
 
 static void
-kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
+kprobe_multi_link_handler(struct fprobe *fp, unsigned long fentry_ip,
 			  struct pt_regs *regs)
 {
 	struct bpf_kprobe_multi_link *link;
 
 	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
-	kprobe_multi_link_prog_run(link, entry_ip, regs);
+	kprobe_multi_link_prog_run(link, get_entry_ip(fentry_ip), regs);
 }
 
 static int symbols_cmp_r(const void *a, const void *b, const void *priv)
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index 08f95a8155d1..98c3399e15c0 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -36,15 +36,13 @@ __u64 kretprobe_test6_result = 0;
 __u64 kretprobe_test7_result = 0;
 __u64 kretprobe_test8_result = 0;
 
-extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
-
 static void kprobe_multi_check(void *ctx, bool is_return)
 {
 	if (bpf_get_current_pid_tgid() >> 32 != pid)
 		return;
 
 	__u64 cookie = test_cookie ? bpf_get_attach_cookie(ctx) : 0;
-	__u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
+	__u64 addr = bpf_get_func_ip(ctx);
 
 #define SET(__var, __addr, __cookie) ({			\
 	if (((const void *) addr == __addr) &&		\
-- 
2.35.1

