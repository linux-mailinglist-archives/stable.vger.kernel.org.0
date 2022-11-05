Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5158161DE0E
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 21:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKEUvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 16:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKEUvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 16:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644BEFCDC;
        Sat,  5 Nov 2022 13:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB8E160B9F;
        Sat,  5 Nov 2022 20:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B12C43147;
        Sat,  5 Nov 2022 20:51:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orQ8g-007k9t-1L;
        Sat, 05 Nov 2022 16:51:38 -0400
Message-ID: <20221105205138.253686628@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 16:50:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Shang XiaoJing <shangxiaojing@huawei.com>
Subject: [for-linus][PATCH 6/6] tracing: kprobe: Fix memory leak in test_gen_kprobe/kretprobe_cmd()
References: <20221105205049.462806482@goodmis.org>
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

test_gen_kprobe_cmd() only free buf in fail path, hence buf will leak
when there is no failure. Move kfree(buf) from fail path to common path
to prevent the memleak. The same reason and solution in
test_gen_kretprobe_cmd().

unreferenced object 0xffff888143b14000 (size 2048):
  comm "insmod", pid 52490, jiffies 4301890980 (age 40.553s)
  hex dump (first 32 bytes):
    70 3a 6b 70 72 6f 62 65 73 2f 67 65 6e 5f 6b 70  p:kprobes/gen_kp
    72 6f 62 65 5f 74 65 73 74 20 64 6f 5f 73 79 73  robe_test do_sys
  backtrace:
    [<000000006d7b836b>] kmalloc_trace+0x27/0xa0
    [<0000000009528b5b>] 0xffffffffa059006f
    [<000000008408b580>] do_one_initcall+0x87/0x2a0
    [<00000000c4980a7e>] do_init_module+0xdf/0x320
    [<00000000d775aad0>] load_module+0x3006/0x3390
    [<00000000e9a74b80>] __do_sys_finit_module+0x113/0x1b0
    [<000000003726480d>] do_syscall_64+0x35/0x80
    [<000000003441e93b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lore.kernel.org/all/20221102072954.26555-1-shangxiaojing@huawei.com/

Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Cc: stable@vger.kernel.org
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/kprobe_event_gen_test.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index 80e04a1e1977..d81f7c51025c 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -100,20 +100,20 @@ static int __init test_gen_kprobe_cmd(void)
 					 KPROBE_GEN_TEST_FUNC,
 					 KPROBE_GEN_TEST_ARG0, KPROBE_GEN_TEST_ARG1);
 	if (ret)
-		goto free;
+		goto out;
 
 	/* Use kprobe_event_add_fields to add the rest of the fields */
 
 	ret = kprobe_event_add_fields(&cmd, KPROBE_GEN_TEST_ARG2, KPROBE_GEN_TEST_ARG3);
 	if (ret)
-		goto free;
+		goto out;
 
 	/*
 	 * This actually creates the event.
 	 */
 	ret = kprobe_event_gen_cmd_end(&cmd);
 	if (ret)
-		goto free;
+		goto out;
 
 	/*
 	 * Now get the gen_kprobe_test event file.  We need to prevent
@@ -136,13 +136,11 @@ static int __init test_gen_kprobe_cmd(void)
 		goto delete;
 	}
  out:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kprobe_test");
- free:
-	kfree(buf);
-
 	goto out;
 }
 
@@ -170,14 +168,14 @@ static int __init test_gen_kretprobe_cmd(void)
 					    KPROBE_GEN_TEST_FUNC,
 					    "$retval");
 	if (ret)
-		goto free;
+		goto out;
 
 	/*
 	 * This actually creates the event.
 	 */
 	ret = kretprobe_event_gen_cmd_end(&cmd);
 	if (ret)
-		goto free;
+		goto out;
 
 	/*
 	 * Now get the gen_kretprobe_test event file.  We need to
@@ -201,13 +199,11 @@ static int __init test_gen_kretprobe_cmd(void)
 		goto delete;
 	}
  out:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kretprobe_test");
- free:
-	kfree(buf);
-
 	goto out;
 }
 
-- 
2.35.1
