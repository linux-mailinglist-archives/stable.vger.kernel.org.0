Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2066A7954
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCBCIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCBCIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:08:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E70C1F4A3;
        Wed,  1 Mar 2023 18:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53853B8118D;
        Thu,  2 Mar 2023 02:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D53C4339C;
        Thu,  2 Mar 2023 02:08:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pXYMc-003WcH-2O;
        Wed, 01 Mar 2023 21:08:10 -0500
Message-ID: <20230302020810.559462599@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 01 Mar 2023 20:00:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] tracing: Do not let histogram values have some modifiers
References: <20230302010051.044209550@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Histogram values can not be strings, stacktraces, graphs, symbols,
syscalls, or grouped in buckets or log. Give an error if a value is set to
do so.

Note, the histogram code was not prepared to handle these modifiers for
histograms and caused a bug.

Mark Rutland reported:

 # echo 'p:copy_to_user __arch_copy_to_user n=$arg2' >> /sys/kernel/tracing/kprobe_events
 # echo 'hist:keys=n:vals=hitcount.buckets=8:sort=hitcount' > /sys/kernel/tracing/events/kprobes/copy_to_user/trigger
 # cat /sys/kernel/tracing/events/kprobes/copy_to_user/hist
[  143.694628] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  143.695190] Mem abort info:
[  143.695362]   ESR = 0x0000000096000004
[  143.695604]   EC = 0x25: DABT (current EL), IL = 32 bits
[  143.695889]   SET = 0, FnV = 0
[  143.696077]   EA = 0, S1PTW = 0
[  143.696302]   FSC = 0x04: level 0 translation fault
[  143.702381] Data abort info:
[  143.702614]   ISV = 0, ISS = 0x00000004
[  143.702832]   CM = 0, WnR = 0
[  143.703087] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000448f9000
[  143.703407] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  143.704137] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[  143.704714] Modules linked in:
[  143.705273] CPU: 0 PID: 133 Comm: cat Not tainted 6.2.0-00003-g6fc512c10a7c #3
[  143.706138] Hardware name: linux,dummy-virt (DT)
[  143.706723] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  143.707120] pc : hist_field_name.part.0+0x14/0x140
[  143.707504] lr : hist_field_name.part.0+0x104/0x140
[  143.707774] sp : ffff800008333a30
[  143.707952] x29: ffff800008333a30 x28: 0000000000000001 x27: 0000000000400cc0
[  143.708429] x26: ffffd7a653b20260 x25: 0000000000000000 x24: ffff10d303ee5800
[  143.708776] x23: ffffd7a6539b27b0 x22: ffff10d303fb8c00 x21: 0000000000000001
[  143.709127] x20: ffff10d303ec2000 x19: 0000000000000000 x18: 0000000000000000
[  143.709478] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  143.709824] x14: 0000000000000000 x13: 203a6f666e692072 x12: 6567676972742023
[  143.710179] x11: 0a230a6d6172676f x10: 000000000000002c x9 : ffffd7a6521e018c
[  143.710584] x8 : 000000000000002c x7 : 7f7f7f7f7f7f7f7f x6 : 000000000000002c
[  143.710915] x5 : ffff10d303b0103e x4 : ffffd7a653b20261 x3 : 000000000000003d
[  143.711239] x2 : 0000000000020001 x1 : 0000000000000001 x0 : 0000000000000000
[  143.711746] Call trace:
[  143.712115]  hist_field_name.part.0+0x14/0x140
[  143.712642]  hist_field_name.part.0+0x104/0x140
[  143.712925]  hist_field_print+0x28/0x140
[  143.713125]  event_hist_trigger_print+0x174/0x4d0
[  143.713348]  hist_show+0xf8/0x980
[  143.713521]  seq_read_iter+0x1bc/0x4b0
[  143.713711]  seq_read+0x8c/0xc4
[  143.713876]  vfs_read+0xc8/0x2a4
[  143.714043]  ksys_read+0x70/0xfc
[  143.714218]  __arm64_sys_read+0x24/0x30
[  143.714400]  invoke_syscall+0x50/0x120
[  143.714587]  el0_svc_common.constprop.0+0x4c/0x100
[  143.714807]  do_el0_svc+0x44/0xd0
[  143.714970]  el0_svc+0x2c/0x84
[  143.715134]  el0t_64_sync_handler+0xbc/0x140
[  143.715334]  el0t_64_sync+0x190/0x194
[  143.715742] Code: a9bd7bfd 910003fd a90153f3 aa0003f3 (f9400000)
[  143.716510] ---[ end trace 0000000000000000 ]---
Segmentation fault

Cc: stable@vger.kernel.org
Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 89877a18f933..6e8ab726a7b5 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4235,6 +4235,15 @@ static int __create_val_field(struct hist_trigger_data *hist_data,
 		goto out;
 	}
 
+	/* Some types cannot be a value */
+	if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
+				 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+				 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
+				 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE)) {
+		hist_err(file->tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
+		ret = -EINVAL;
+	}
+
 	hist_data->fields[val_idx] = hist_field;
 
 	++hist_data->n_vals;
-- 
2.39.1
