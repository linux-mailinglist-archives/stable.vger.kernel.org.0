Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847596D7F62
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbjDEO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbjDEO1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3658E4EFD;
        Wed,  5 Apr 2023 07:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B916277C;
        Wed,  5 Apr 2023 14:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD3C433D2;
        Wed,  5 Apr 2023 14:26:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pk46B-000qkf-0e;
        Wed, 05 Apr 2023 10:26:55 -0400
Message-ID: <20230405142655.019084805@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 05 Apr 2023 09:58:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [for-linus][PATCH 3/3] tracing: Free error logs of tracing instances
References: <20230405135813.735507007@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.8 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a tracing instance is removed, the error messages that hold errors
that occurred in the instance needs to be freed. The following reports a
memory leak:

 # cd /sys/kernel/tracing
 # mkdir instances/foo
 # echo 'hist:keys=x' > instances/foo/events/sched/sched_switch/trigger
 # cat instances/foo/error_log
 [  117.404795] hist:sched:sched_switch: error: Couldn't find field
   Command: hist:keys=x
                      ^
 # rmdir instances/foo

Then check for memory leaks:

 # echo scan > /sys/kernel/debug/kmemleak
 # cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff88810d8ec700 (size 192):
  comm "bash", pid 869, jiffies 4294950577 (age 215.752s)
  hex dump (first 32 bytes):
    60 dd 68 61 81 88 ff ff 60 dd 68 61 81 88 ff ff  `.ha....`.ha....
    a0 30 8c 83 ff ff ff ff 26 00 0a 00 00 00 00 00  .0......&.......
  backtrace:
    [<00000000dae26536>] kmalloc_trace+0x2a/0xa0
    [<00000000b2938940>] tracing_log_err+0x277/0x2e0
    [<000000004a0e1b07>] parse_atom+0x966/0xb40
    [<0000000023b24337>] parse_expr+0x5f3/0xdb0
    [<00000000594ad074>] event_hist_trigger_parse+0x27f8/0x3560
    [<00000000293a9645>] trigger_process_regex+0x135/0x1a0
    [<000000005c22b4f2>] event_trigger_write+0x87/0xf0
    [<000000002cadc509>] vfs_write+0x162/0x670
    [<0000000059c3b9be>] ksys_write+0xca/0x170
    [<00000000f1cddc00>] do_syscall_64+0x3e/0xc0
    [<00000000868ac68c>] entry_SYSCALL_64_after_hwframe+0x72/0xdc
unreferenced object 0xffff888170c35a00 (size 32):
  comm "bash", pid 869, jiffies 4294950577 (age 215.752s)
  hex dump (first 32 bytes):
    0a 20 20 43 6f 6d 6d 61 6e 64 3a 20 68 69 73 74  .  Command: hist
    3a 6b 65 79 73 3d 78 0a 00 00 00 00 00 00 00 00  :keys=x.........
  backtrace:
    [<000000006a747de5>] __kmalloc+0x4d/0x160
    [<000000000039df5f>] tracing_log_err+0x29b/0x2e0
    [<000000004a0e1b07>] parse_atom+0x966/0xb40
    [<0000000023b24337>] parse_expr+0x5f3/0xdb0
    [<00000000594ad074>] event_hist_trigger_parse+0x27f8/0x3560
    [<00000000293a9645>] trigger_process_regex+0x135/0x1a0
    [<000000005c22b4f2>] event_trigger_write+0x87/0xf0
    [<000000002cadc509>] vfs_write+0x162/0x670
    [<0000000059c3b9be>] ksys_write+0xca/0x170
    [<00000000f1cddc00>] do_syscall_64+0x3e/0xc0
    [<00000000868ac68c>] entry_SYSCALL_64_after_hwframe+0x72/0xdc

The problem is that the error log needs to be freed when the instance is
removed.

Link: https://lore.kernel.org/lkml/76134d9f-a5ba-6a0d-37b3-28310b4a1e91@alu.unizg.hr/
Link: https://lore.kernel.org/linux-trace-kernel/20230404194504.5790b95f@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: 2f754e771b1a6 ("tracing: Have the error logs show up in the proper instances")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4686473b8497..36a6037823cd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9516,6 +9516,7 @@ static int __remove_instance(struct trace_array *tr)
 	tracefs_remove(tr->dir);
 	free_percpu(tr->last_func_repeats);
 	free_trace_buffers(tr);
+	clear_tracing_err_log(tr);
 
 	for (i = 0; i < tr->nr_topts; i++) {
 		kfree(tr->topts[i].topts);
-- 
2.39.2
