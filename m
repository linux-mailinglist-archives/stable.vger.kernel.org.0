Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C4E6812EB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjA3O0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbjA3O0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026463D93A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20680B80FA0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59030C433EF;
        Mon, 30 Jan 2023 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088692;
        bh=xyfc8lTCVMvnK7t/kwr12+yqcFAAvsnSl1Jn034eCQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koh8sk8TEWP9ojv5BTCMmYbD/2qyB31XF6Nzos4DyfIKmgqhax4UXXycB/CUezBwt
         q8iNDWXj+NGpx5RHvpEhdSk4X/EdBwKmt29aL1McLmLHwZpTaSEzonpEMFwjnFl3w+
         D4SkiXS0XqsDAL8YVD6FV2c1dbrcyV+70piZr/Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 103/143] tracing: Make sure trace_printk() can output as soon as it can be used
Date:   Mon, 30 Jan 2023 14:52:40 +0100
Message-Id: <20230130134311.121327994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 3bb06eb6e9acf7c4a3e1b5bc87aed398ff8e2253 upstream.

Currently trace_printk() can be used as soon as early_trace_init() is
called from start_kernel(). But if a crash happens, and
"ftrace_dump_on_oops" is set on the kernel command line, all you get will
be:

  [    0.456075]   <idle>-0         0dN.2. 347519us : Unknown type 6
  [    0.456075]   <idle>-0         0dN.2. 353141us : Unknown type 6
  [    0.456075]   <idle>-0         0dN.2. 358684us : Unknown type 6

This is because the trace_printk() event (type 6) hasn't been registered
yet. That gets done via an early_initcall(), which may be early, but not
early enough.

Instead of registering the trace_printk() event (and other ftrace events,
which are not trace events) via an early_initcall(), have them registered at
the same time that trace_printk() can be used. This way, if there is a
crash before early_initcall(), then the trace_printk()s will actually be
useful.

Link: https://lkml.kernel.org/r/20230104161412.019f6c55@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: e725c731e3bb1 ("tracing: Split tracing initialization into two for early initialization")
Reported-by: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c        |    2 ++
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_output.c |    3 +--
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9680,6 +9680,8 @@ void __init early_trace_init(void)
 			static_key_enable(&tracepoint_printk_key.key);
 	}
 	tracer_alloc_buffers();
+
+	init_events();
 }
 
 void __init trace_init(void)
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1673,6 +1673,7 @@ extern void trace_event_enable_cmd_recor
 extern void trace_event_enable_tgid_record(bool enable);
 
 extern int event_trace_init(void);
+extern int init_events(void);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 extern void __trace_early_add_events(struct trace_array *tr);
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1378,7 +1378,7 @@ static struct trace_event *events[] __in
 	NULL
 };
 
-__init static int init_events(void)
+__init int init_events(void)
 {
 	struct trace_event *event;
 	int i, ret;
@@ -1396,4 +1396,3 @@ __init static int init_events(void)
 
 	return 0;
 }
-early_initcall(init_events);


