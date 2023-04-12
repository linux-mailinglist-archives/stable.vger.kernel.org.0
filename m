Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14256DEFC3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDLIxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjDLIxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D392C902D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9A7631CB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE47DC433EF;
        Wed, 12 Apr 2023 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289580;
        bh=u373mlatMxaoKpPJkgPE0X216RB99HVyAAddIuY5j2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qalw8gIoXF7Fe0AV0OJ+hKWTupeW0GXTnOju0fjAPxoZKvQoCs+rGVDYjrD4uC+Gt
         qr3fRrHB4cNKLXwZE9plMD37QpGYTJL7jkrmWdqJbOb8SlL0bL6Beq17A7gN/LfNMF
         9i2FSPpw+P/3CvbU+OJ5084lxBREJ7UFZbeNObwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 124/173] tracing: Free error logs of tracing instances
Date:   Wed, 12 Apr 2023 10:34:10 +0200
Message-Id: <20230412082843.152871600@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 3357c6e429643231e60447b52ffbb7ac895aca22 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9472,6 +9472,7 @@ static int __remove_instance(struct trac
 	tracefs_remove(tr->dir);
 	free_percpu(tr->last_func_repeats);
 	free_trace_buffers(tr);
+	clear_tracing_err_log(tr);
 
 	for (i = 0; i < tr->nr_topts; i++) {
 		kfree(tr->topts[i].topts);


