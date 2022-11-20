Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A5631641
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKTUMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKTUMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:12:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDE5BD5;
        Sun, 20 Nov 2022 12:12:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 507ABB80B78;
        Sun, 20 Nov 2022 20:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09425C433C1;
        Sun, 20 Nov 2022 20:12:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqfu-00DiW7-09;
        Sun, 20 Nov 2022 15:12:22 -0500
Message-ID: <20221120201221.917825605@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:11:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 1/7] tracing: kprobe: Fix potential null-ptr-deref on trace_event_file in
 kprobe_event_gen_test_exit()
References: <20221120201156.868430827@goodmis.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

When trace_get_event_file() failed, gen_kretprobe_test will be assigned
as the error code. If module kprobe_event_gen_test is removed now, the
null pointer dereference will happen in kprobe_event_gen_test_exit().
Check if gen_kprobe_test or gen_kretprobe_test is error code or NULL
before dereference them.

BUG: kernel NULL pointer dereference, address: 0000000000000012
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 3 PID: 2210 Comm: modprobe Not tainted
6.1.0-rc1-00171-g2159299a3b74-dirty #217
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:kprobe_event_gen_test_exit+0x1c/0xb5 [kprobe_event_gen_test]
Code: Unable to access opcode bytes at 0xffffffff9ffffff2.
RSP: 0018:ffffc900015bfeb8 EFLAGS: 00010246
RAX: ffffffffffffffea RBX: ffffffffa0002080 RCX: 0000000000000000
RDX: ffffffffa0001054 RSI: ffffffffa0001064 RDI: ffffffffdfc6349c
RBP: ffffffffa0000000 R08: 0000000000000004 R09: 00000000001e95c0
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000800
R13: ffffffffa0002420 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f56b75be540(0000) GS:ffff88813bc00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff9ffffff2 CR3: 000000010874a006 CR4: 0000000000330ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __x64_sys_delete_module+0x206/0x380
 ? lockdep_hardirqs_on_prepare+0xd8/0x190
 ? syscall_enter_from_user_mode+0x1c/0x50
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lore.kernel.org/all/20221108015130.28326-2-shangxiaojing@huawei.com/

Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/kprobe_event_gen_test.c | 44 ++++++++++++++++++----------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index d81f7c51025c..1c98fafcf333 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -73,6 +73,10 @@ static struct trace_event_file *gen_kretprobe_test;
 #define KPROBE_GEN_TEST_ARG3	NULL
 #endif
 
+static bool trace_event_file_is_valid(struct trace_event_file *input)
+{
+	return input && !IS_ERR(input);
+}
 
 /*
  * Test to make sure we can create a kprobe event, then add more
@@ -217,10 +221,12 @@ static int __init kprobe_event_gen_test_init(void)
 
 	ret = test_gen_kretprobe_cmd();
 	if (ret) {
-		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-						  "kprobes",
-						  "gen_kretprobe_test", false));
-		trace_put_event_file(gen_kretprobe_test);
+		if (trace_event_file_is_valid(gen_kretprobe_test)) {
+			WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+							  "kprobes",
+							  "gen_kretprobe_test", false));
+			trace_put_event_file(gen_kretprobe_test);
+		}
 		WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
 	}
 
@@ -229,24 +235,30 @@ static int __init kprobe_event_gen_test_init(void)
 
 static void __exit kprobe_event_gen_test_exit(void)
 {
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
-					  "kprobes",
-					  "gen_kprobe_test", false));
+	if (trace_event_file_is_valid(gen_kprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
+						  "kprobes",
+						  "gen_kprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kprobe_test"));
 
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-					  "kprobes",
-					  "gen_kretprobe_test", false));
+	if (trace_event_file_is_valid(gen_kretprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+						  "kprobes",
+						  "gen_kretprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kretprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kretprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
-- 
2.35.1


