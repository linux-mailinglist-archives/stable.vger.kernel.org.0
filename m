Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E614D4D70
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiCJPLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 10:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344921AbiCJPKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 10:10:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDCB195302;
        Thu, 10 Mar 2022 07:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D8556169A;
        Thu, 10 Mar 2022 15:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD685C340F4;
        Thu, 10 Mar 2022 15:04:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nSKLR-001DZF-KN;
        Thu, 10 Mar 2022 10:04:49 -0500
Message-ID: <20220310150449.470612365@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 10 Mar 2022 10:04:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [for-linus][PATCH 1/3] tracing/osnoise: Do not unregister events twice
References: <20220310150431.248810778@goodmis.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

Nicolas reported that using:

 # trace-cmd record -e all -M 10 -p osnoise --poll

Resulted in the following kernel warning:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 1217 at kernel/tracepoint.c:404 tracepoint_probe_unregister+0x280/0x370
 [...]
 CPU: 0 PID: 1217 Comm: trace-cmd Not tainted 5.17.0-rc6-next-20220307-nico+ #19
 RIP: 0010:tracepoint_probe_unregister+0x280/0x370
 [...]
 CR2: 00007ff919b29497 CR3: 0000000109da4005 CR4: 0000000000170ef0
 Call Trace:
  <TASK>
  osnoise_workload_stop+0x36/0x90
  tracing_set_tracer+0x108/0x260
  tracing_set_trace_write+0x94/0xd0
  ? __check_object_size.part.0+0x10a/0x150
  ? selinux_file_permission+0x104/0x150
  vfs_write+0xb5/0x290
  ksys_write+0x5f/0xe0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7ff919a18127
 [...]
 ---[ end trace 0000000000000000 ]---

The warning complains about an attempt to unregister an
unregistered tracepoint.

This happens on trace-cmd because it first stops tracing, and
then switches the tracer to nop. Which is equivalent to:

  # cd /sys/kernel/tracing/
  # echo osnoise > current_tracer
  # echo 0 > tracing_on
  # echo nop > current_tracer

The osnoise tracer stops the workload when no trace instance
is actually collecting data. This can be caused both by
disabling tracing or disabling the tracer itself.

To avoid unregistering events twice, use the existing
trace_osnoise_callback_enabled variable to check if the events
(and the workload) are actually active before trying to
deactivate them.

Link: https://lore.kernel.org/all/c898d1911f7f9303b7e14726e7cc9678fbfb4a0e.camel@redhat.com/
Link: https://lkml.kernel.org/r/938765e17d5a781c2df429a98f0b2e7cc317b022.1646823913.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Fixes: 2fac8d6486d5 ("tracing/osnoise: Allow multiple instances of the same tracer")
Reported-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index cfddb30e65ab..2aa3efdca755 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2200,6 +2200,17 @@ static void osnoise_workload_stop(void)
 	if (osnoise_has_registered_instances())
 		return;
 
+	/*
+	 * If callbacks were already disabled in a previous stop
+	 * call, there is no need to disable then again.
+	 *
+	 * For instance, this happens when tracing is stopped via:
+	 * echo 0 > tracing_on
+	 * echo nop > current_tracer.
+	 */
+	if (!trace_osnoise_callback_enabled)
+		return;
+
 	trace_osnoise_callback_enabled = false;
 	/*
 	 * Make sure that ftrace_nmi_enter/exit() see
-- 
2.34.1
