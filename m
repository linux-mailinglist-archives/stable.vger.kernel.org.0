Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17F468965F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjBCK3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjBCK2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B4E1D92A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 244CCB82A68
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8E1C433D2;
        Fri,  3 Feb 2023 10:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420083;
        bh=yU/KHOVoY3cgHVv7ftkC4XUH3Cf97dmamGzRt85zphM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9nU3l8H9V+aF0Gdi4JxfupM+PhwCmiP61wTgZ7PcgpL4NOG8HIG8qP6oqwCELUY6
         m55dPYq+/kICx2P53GENhFzwThsh/7Wo/oqOqsBiUMR2sbNXavJPZoIn89wFz3eRtS
         ewRvmTUGfqU4fNtXskQiodGHi5JQ4cYFX8PhDvYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 075/134] tracing: Make sure trace_printk() can output as soon as it can be used
Date:   Fri,  3 Feb 2023 11:13:00 +0100
Message-Id: <20230203101027.229420105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
@@ -9317,6 +9317,8 @@ void __init early_trace_init(void)
 			static_key_enable(&tracepoint_printk_key.key);
 	}
 	tracer_alloc_buffers();
+
+	init_events();
 }
 
 void __init trace_init(void)
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1590,6 +1590,7 @@ extern void trace_event_enable_cmd_recor
 extern void trace_event_enable_tgid_record(bool enable);
 
 extern int event_trace_init(void);
+extern int init_events(void);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1366,7 +1366,7 @@ static struct trace_event *events[] __in
 	NULL
 };
 
-__init static int init_events(void)
+__init int init_events(void)
 {
 	struct trace_event *event;
 	int i, ret;
@@ -1384,4 +1384,3 @@ __init static int init_events(void)
 
 	return 0;
 }
-early_initcall(init_events);


