Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A885655266F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 23:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbiFTVcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 17:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241677AbiFTVcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 17:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6313C13CFE;
        Mon, 20 Jun 2022 14:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1E34611FC;
        Mon, 20 Jun 2022 21:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ED3C341C5;
        Mon, 20 Jun 2022 21:32:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1o3P0Q-003o1G-4h;
        Mon, 20 Jun 2022 17:32:22 -0400
Message-ID: <20220620213221.981855209@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 20 Jun 2022 17:31:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yonghong Song <yhs@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [for-linus][PATCH 1/4] tracing/kprobes: Check whether get_kretprobe() returns NULL in
 kretprobe_dispatcher()
References: <20220620213158.468216113@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

There is a small chance that get_kretprobe(ri) returns NULL in
kretprobe_dispatcher() when another CPU unregisters the kretprobe
right after __kretprobe_trampoline_handler().

To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
return value again. And if it is NULL, it returns soon because that
kretprobe is under unregistering process.

This issue has been introduced when the kretprobe is decoupled
from the struct kretprobe_instance by commit d741bf41d7c7
("kprobes: Remove kretprobe hash"). Before that commit, the
struct kretprob_instance::rp directly points the kretprobe
and it is never be NULL.

Link: https://lkml.kernel.org/r/165366693881.797669.16926184644089588731.stgit@devnote2

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: bpf <bpf@vger.kernel.org>
Cc: Kernel Team <kernel-team@fb.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 93507330462c..a245ea673715 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1718,8 +1718,17 @@ static int
 kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct kretprobe *rp = get_kretprobe(ri);
-	struct trace_kprobe *tk = container_of(rp, struct trace_kprobe, rp);
+	struct trace_kprobe *tk;
+
+	/*
+	 * There is a small chance that get_kretprobe(ri) returns NULL when
+	 * the kretprobe is unregister on another CPU between kretprobe's
+	 * trampoline_handler and this function.
+	 */
+	if (unlikely(!rp))
+		return 0;
 
+	tk = container_of(rp, struct trace_kprobe, rp);
 	raw_cpu_inc(*tk->nhit);
 
 	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
-- 
2.35.1
