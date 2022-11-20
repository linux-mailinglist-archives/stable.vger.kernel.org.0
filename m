Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4937663162D
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKTUHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKTUHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:07:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B391E729;
        Sun, 20 Nov 2022 12:07:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB4260D39;
        Sun, 20 Nov 2022 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD6C433D7;
        Sun, 20 Nov 2022 20:07:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqbH-00Di9j-2x;
        Sun, 20 Nov 2022 15:07:35 -0500
Message-ID: <20221120200735.791518959@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:07:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Rafael Mendonca <rafaelmendsr@gmail.com>
Subject: [for-linus][PATCH 13/13] tracing: Fix race where eprobes can be called before the event
References: <20221120200700.725968899@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The flag that tells the event to call its triggers after reading the event
is set for eprobes after the eprobe is enabled. This leads to a race where
the eprobe may be triggered at the beginning of the event where the record
information is NULL. The eprobe then dereferences the NULL record causing
a NULL kernel pointer bug.

Test for a NULL record to keep this from happening.

Link: https://lore.kernel.org/linux-trace-kernel/20221116192552.1066630-1-rafaelmendsr@gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20221117214249.2addbe10@gandalf.local.home

Cc: Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_eprobe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 5dd0617e5df6..9cda9a38422c 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -563,6 +563,9 @@ static void eprobe_trigger_func(struct event_trigger_data *data,
 {
 	struct eprobe_data *edata = data->private_data;
 
+	if (unlikely(!rec))
+		return;
+
 	__eprobe_trace_func(edata, rec);
 }
 
-- 
2.35.1


