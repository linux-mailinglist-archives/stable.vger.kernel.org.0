Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941C148B3F6
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344448AbiAKRbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:31:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344320AbiAKRbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:31:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BE76B81C4C;
        Tue, 11 Jan 2022 17:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC9FC36AF7;
        Tue, 11 Jan 2022 17:31:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1n7KzM-0032Ck-5Y;
        Tue, 11 Jan 2022 12:31:16 -0500
Message-ID: <20220111173116.004824497@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 11 Jan 2022 12:30:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiangyang Zhang <xyz.sun.ok@gmail.com>
Subject: [for-next][PATCH 15/31] tracing/kprobes: nmissed not showed correctly for kretprobe
References: <20220111173030.999527342@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiangyang Zhang <xyz.sun.ok@gmail.com>

The 'nmissed' column of the 'kprobe_profile' file for kretprobe is
not showed correctly, kretprobe can be skipped by two reasons,
shortage of kretprobe_instance which is counted by tk->rp.nmissed,
and kprobe itself is missed by some reason, so to show the sum.

Link: https://lkml.kernel.org/r/20220107150242.5019-1-xyz.sun.ok@gmail.com

Cc: stable@vger.kernel.org
Fixes: 4a846b443b4e ("tracing/kprobes: Cleanup kprobe tracer code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f8c26ee72de3..3d85323278ed 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1170,15 +1170,18 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
 	struct dyn_event *ev = v;
 	struct trace_kprobe *tk;
+	unsigned long nmissed;
 
 	if (!is_trace_kprobe(ev))
 		return 0;
 
 	tk = to_trace_kprobe(ev);
+	nmissed = trace_kprobe_is_return(tk) ?
+		tk->rp.kp.nmissed + tk->rp.nmissed : tk->rp.kp.nmissed;
 	seq_printf(m, "  %-44s %15lu %15lu\n",
 		   trace_probe_name(&tk->tp),
 		   trace_kprobe_nhit(tk),
-		   tk->rp.kp.nmissed);
+		   nmissed);
 
 	return 0;
 }
-- 
2.33.0
