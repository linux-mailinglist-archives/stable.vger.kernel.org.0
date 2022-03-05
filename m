Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C34C4CE2AC
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 06:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiCEFLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 00:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiCEFLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 00:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E875593AB;
        Fri,  4 Mar 2022 21:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B736B82C87;
        Sat,  5 Mar 2022 05:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE21CC340F1;
        Sat,  5 Mar 2022 05:10:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nQMgD-00EguW-U1;
        Sat, 05 Mar 2022 00:10:09 -0500
Message-ID: <20220305051009.767499878@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Mar 2022 00:09:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 2/2] tracing: Fix return value of __setup handlers
References: <20220305050948.857222764@goodmis.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

__setup() handlers should generally return 1 to indicate that the
boot options have been handled.

Using invalid option values causes the entire kernel boot option
string to be reported as Unknown and added to init's environment
strings, polluting it.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc6
    kprobe_event=p,syscall_any,$arg1 trace_options=quiet
    trace_clock=jiffies", will be passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     kprobe_event=p,syscall_any,$arg1
     trace_options=quiet
     trace_clock=jiffies

Return 1 from the __setup() handlers so that init's environment is not
polluted with kernel boot options.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Link: https://lkml.kernel.org/r/20220303031744.32356-1-rdunlap@infradead.org

Cc: stable@vger.kernel.org
Fixes: 7bcfaf54f591 ("tracing: Add trace_options kernel command line parameter")
Fixes: e1e232ca6b8f ("tracing: Add trace_clock=<clock> kernel parameter")
Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c        | 4 ++--
 kernel/trace/trace_kprobe.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3050892d1812..eb44418574f9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -235,7 +235,7 @@ static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
 static int __init set_trace_boot_options(char *str)
 {
 	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
-	return 0;
+	return 1;
 }
 __setup("trace_options=", set_trace_boot_options);
 
@@ -246,7 +246,7 @@ static int __init set_trace_boot_clock(char *str)
 {
 	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
 	trace_boot_clock = trace_boot_clock_buf;
-	return 0;
+	return 1;
 }
 __setup("trace_clock=", set_trace_boot_clock);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 508f14af4f2c..b62fd785b599 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -32,7 +32,7 @@ static int __init set_kprobe_boot_events(char *str)
 	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
 	disable_tracing_selftest("running kprobe events");
 
-	return 0;
+	return 1;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
 
-- 
2.34.1
