Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734A159D802
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241180AbiHWJrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352361AbiHWJqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575F68D3FB;
        Tue, 23 Aug 2022 01:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DF6EB81C20;
        Tue, 23 Aug 2022 08:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998FCC433C1;
        Tue, 23 Aug 2022 08:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244168;
        bh=v4KGrEVskcMrBDA4KqT7FNFEnwx3XEfxBHbjvZzK7pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dm//0fp6o1VYWHtV8BuLUEB1XZaXGkjwwWbxG/ncmFyKdtU0Ur5aRaRiXef3H/gh
         orK4Qi+g0gqx2hE5Ep+nN4FOJLbo7PNSUAEjE7Rf1fciZ7IE5cZDcYhYlMgxvKYwm2
         Xyg9wdGKhyn6P+rPPclTvgC8yLakwh4nR/oYtvDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 020/244] tracing/eprobes: Do not allow eprobes to use $stack, or % for regs
Date:   Tue, 23 Aug 2022 10:22:59 +0200
Message-Id: <20220823080059.741045306@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 2673c60ee67e71f2ebe34386e62d348f71edee47 upstream.

While playing with event probes (eprobes), I tried to see what would
happen if I attempted to retrieve the instruction pointer (%rip) knowing
that event probes do not use pt_regs. The result was:

 BUG: kernel NULL pointer dereference, address: 0000000000000024
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 1 PID: 1847 Comm: trace-cmd Not tainted 5.19.0-rc5-test+ #309
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01
v03.03 07/14/2016
 RIP: 0010:get_event_field.isra.0+0x0/0x50
 Code: ff 48 c7 c7 c0 8f 74 a1 e8 3d 8b f5 ff e8 88 09 f6 ff 4c 89 e7 e8
50 6a 13 00 48 89 ef 5b 5d 41 5c 41 5d e9 42 6a 13 00 66 90 <48> 63 47 24
8b 57 2c 48 01 c6 8b 47 28 83 f8 02 74 0e 83 f8 04 74
 RSP: 0018:ffff916c394bbaf0 EFLAGS: 00010086
 RAX: ffff916c854041d8 RBX: ffff916c8d9fbf50 RCX: ffff916c255d2000
 RDX: 0000000000000000 RSI: ffff916c255d2008 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ffff916c3a2a0c08 R09: ffff916c394bbda8
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff916c854041d8
 R13: ffff916c854041b0 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff916c9ea40000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000024 CR3: 000000011b60a002 CR4: 00000000001706e0
 Call Trace:
  <TASK>
  get_eprobe_size+0xb4/0x640
  ? __mod_node_page_state+0x72/0xc0
  __eprobe_trace_func+0x59/0x1a0
  ? __mod_lruvec_page_state+0xaa/0x1b0
  ? page_remove_file_rmap+0x14/0x230
  ? page_remove_rmap+0xda/0x170
  event_triggers_call+0x52/0xe0
  trace_event_buffer_commit+0x18f/0x240
  trace_event_raw_event_sched_wakeup_template+0x7a/0xb0
  try_to_wake_up+0x260/0x4c0
  __wake_up_common+0x80/0x180
  __wake_up_common_lock+0x7c/0xc0
  do_notify_parent+0x1c9/0x2a0
  exit_notify+0x1a9/0x220
  do_exit+0x2ba/0x450
  do_group_exit+0x2d/0x90
  __x64_sys_exit_group+0x14/0x20
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Obviously this is not the desired result.

Move the testing for TPARG_FL_TPOINT which is only used for event probes
to the top of the "$" variable check, as all the other variables are not
used for event probes. Also add a check in the register parsing "%" to
fail if an event probe is used.

Link: https://lkml.kernel.org/r/20220820134400.564426983@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -279,7 +279,14 @@ static int parse_probe_vars(char *arg, c
 	int ret = 0;
 	int len;
 
-	if (strcmp(arg, "retval") == 0) {
+	if (flags & TPARG_FL_TPOINT) {
+		if (code->data)
+			return -EFAULT;
+		code->data = kstrdup(arg, GFP_KERNEL);
+		if (!code->data)
+			return -ENOMEM;
+		code->op = FETCH_OP_TP_ARG;
+	} else if (strcmp(arg, "retval") == 0) {
 		if (flags & TPARG_FL_RETURN) {
 			code->op = FETCH_OP_RETVAL;
 		} else {
@@ -319,13 +326,6 @@ static int parse_probe_vars(char *arg, c
 		code->op = FETCH_OP_ARG;
 		code->param = (unsigned int)param - 1;
 #endif
-	} else if (flags & TPARG_FL_TPOINT) {
-		if (code->data)
-			return -EFAULT;
-		code->data = kstrdup(arg, GFP_KERNEL);
-		if (!code->data)
-			return -ENOMEM;
-		code->op = FETCH_OP_TP_ARG;
 	} else
 		goto inval_var;
 
@@ -380,6 +380,11 @@ parse_probe_arg(char *arg, const struct
 		break;
 
 	case '%':	/* named register */
+		if (flags & TPARG_FL_TPOINT) {
+			/* eprobes do not handle registers */
+			trace_probe_log_err(offs, BAD_VAR);
+			break;
+		}
 		ret = regs_query_register_offset(arg + 1);
 		if (ret >= 0) {
 			code->op = FETCH_OP_REG;


