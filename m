Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FDA53650F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 17:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiE0Pzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 11:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345868AbiE0Pzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 11:55:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC713F420;
        Fri, 27 May 2022 08:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6CE5CE259F;
        Fri, 27 May 2022 15:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648AC385A9;
        Fri, 27 May 2022 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653666943;
        bh=cCOkIPySWpvVdaAN06SdyUyZG3iiUBVWghvfYHnbzYk=;
        h=From:To:Cc:Subject:Date:From;
        b=gsAvd6roIaIqzKsnQUK5DspCDPDDGAQJXkPtmL1depNCcT4JpOnPu0V0J752DWZl+
         4udQcnsOftggPJYYy7C7XYP56rFgNMesvlXZyOBmt5BBYgUQiz8jVobYlLI+XaRcen
         4YHielmJTa/YwQtL4tzyhq9r0q9aQyS5FGcQsGG/kpLQrS3tsqXUAHETCTT12Oflv+
         HLfj+9FX+bmJFwyra1PaeHel/GGjyn60TiQNok/9nqvPf+4xGN3EgkpLr4xuVoxQHj
         rRAHZzTsin6DPOr/ZL4/8zneeY+Y/aeTUKVE+89r5/ZYvSdG+2kbqXCn3l1vAoas0l
         A9+BQVv7/tceA==
From:   "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns NULL in kretprobe_dispatcher()
Date:   Sat, 28 May 2022 00:55:39 +0900
Message-Id: <165366693881.797669.16926184644089588731.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

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

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/trace_kprobe.c |   11 ++++++++++-
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

