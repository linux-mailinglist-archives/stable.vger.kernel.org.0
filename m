Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0563C55D645
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiF0LuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiF0LrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:47:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB50DFCE;
        Mon, 27 Jun 2022 04:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F487B81123;
        Mon, 27 Jun 2022 11:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789AFC3411D;
        Mon, 27 Jun 2022 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329949;
        bh=8ia3nNOVzZ5UNhPme1mGfZzE7vviwrDh22cP1FO2jrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM5WAtnwXv9bpFBOVqerrKgs6LsY+UGNO3xbuXfiZVLTxHdmYS7u5WVUsuCAXTkE1
         RJKvrey8oIoXkegGORIhLlNnE1N1qTy2vzg7KmaXVFtfc+vUi1Fb/tzK/V2Teg6Gnu
         1or4RXuIAQUo7w4IjT+FietGwIflkLQHb2iDRYdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 032/181] tracing/kprobes: Check whether get_kretprobe() returns NULL in kretprobe_dispatcher()
Date:   Mon, 27 Jun 2022 13:20:05 +0200
Message-Id: <20220627111945.494369505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit cc72b72073ac982a954d3b43519ca1c28f03c27c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1718,8 +1718,17 @@ static int
 kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct kretprobe *rp = get_kretprobe(ri);
-	struct trace_kprobe *tk = container_of(rp, struct trace_kprobe, rp);
+	struct trace_kprobe *tk;
 
+	/*
+	 * There is a small chance that get_kretprobe(ri) returns NULL when
+	 * the kretprobe is unregister on another CPU between kretprobe's
+	 * trampoline_handler and this function.
+	 */
+	if (unlikely(!rp))
+		return 0;
+
+	tk = container_of(rp, struct trace_kprobe, rp);
 	raw_cpu_inc(*tk->nhit);
 
 	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))


