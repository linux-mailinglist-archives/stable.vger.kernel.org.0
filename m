Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D212D6AED2D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjCGSCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCGSBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:01:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2A5AA25D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764716150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAD6C433EF;
        Tue,  7 Mar 2023 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211715;
        bh=gRp7Po+gUT+oi7gLVCDHF+VJaGojUHBYqoNMHQFBMY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYaCDe+5mvjg8TE2NLPU4N5t8FqYR+4yT8tKoMZeNrufMzt6IYb64BJjCh93sgQMP
         fsJRSd+/Z5A42EC7nvObQvqU/gkYhTtLK2QuK4Fp082ULN2L33w/6d2pFY+GdntCpz
         AGsaVfY+6QkS4aeVABjQbUy29u9cTPdPKGSWb3XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 0952/1001] ring-buffer: Handle race between rb_move_tail and rb_check_pages
Date:   Tue,  7 Mar 2023 18:02:04 +0100
Message-Id: <20230307170103.459341514@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mukesh Ojha <quic_mojha@quicinc.com>

commit 8843e06f67b14f71c044bf6267b2387784c7e198 upstream.

It seems a data race between ring_buffer writing and integrity check.
That is, RB_FLAG of head_page is been updating, while at same time
RB_FLAG was cleared when doing integrity check rb_check_pages():

  rb_check_pages()            rb_handle_head_page():
  --------                    --------
  rb_head_page_deactivate()
                              rb_head_page_set_normal()
  rb_head_page_activate()

We do intergrity test of the list to check if the list is corrupted and
it is still worth doing it. So, let's refactor rb_check_pages() such that
we no longer clear and set flag during the list sanity checking.

[1] and [2] are the test to reproduce and the crash report respectively.

1:
``` read_trace.sh
  while true;
  do
    # the "trace" file is closed after read
    head -1 /sys/kernel/tracing/trace > /dev/null
  done
```
``` repro.sh
  sysctl -w kernel.panic_on_warn=1
  # function tracer will writing enough data into ring_buffer
  echo function > /sys/kernel/tracing/current_tracer
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
  ./read_trace.sh &
```

2:
------------[ cut here ]------------
WARNING: CPU: 9 PID: 62 at kernel/trace/ring_buffer.c:2653
rb_move_tail+0x450/0x470
Modules linked in:
CPU: 9 PID: 62 Comm: ksoftirqd/9 Tainted: G        W          6.2.0-rc6+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:rb_move_tail+0x450/0x470
Code: ff ff 4c 89 c8 f0 4d 0f b1 02 48 89 c2 48 83 e2 fc 49 39 d0 75 24
83 e0 03 83 f8 02 0f 84 e1 fb ff ff 48 8b 57 10 f0 ff 42 08 <0f> 0b 83
f8 02 0f 84 ce fb ff ff e9 db
RSP: 0018:ffffb5564089bd00 EFLAGS: 00000203
RAX: 0000000000000000 RBX: ffff9db385a2bf81 RCX: ffffb5564089bd18
RDX: ffff9db281110100 RSI: 0000000000000fe4 RDI: ffff9db380145400
RBP: ffff9db385a2bf80 R08: ffff9db385a2bfc0 R09: ffff9db385a2bfc2
R10: ffff9db385a6c000 R11: ffff9db385a2bf80 R12: 0000000000000000
R13: 00000000000003e8 R14: ffff9db281110100 R15: ffffffffbb006108
FS:  0000000000000000(0000) GS:ffff9db3bdcc0000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005602323024c8 CR3: 0000000022e0c000 CR4: 00000000000006e0
Call Trace:
 <TASK>
 ring_buffer_lock_reserve+0x136/0x360
 ? __do_softirq+0x287/0x2df
 ? __pfx_rcu_softirq_qs+0x10/0x10
 trace_function+0x21/0x110
 ? __pfx_rcu_softirq_qs+0x10/0x10
 ? __do_softirq+0x287/0x2df
 function_trace_call+0xf6/0x120
 0xffffffffc038f097
 ? rcu_softirq_qs+0x5/0x140
 rcu_softirq_qs+0x5/0x140
 __do_softirq+0x287/0x2df
 run_ksoftirqd+0x2a/0x30
 smpboot_thread_fn+0x188/0x220
 ? __pfx_smpboot_thread_fn+0x10/0x10
 kthread+0xe7/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 </TASK>
---[ end trace 0000000000000000 ]---

[ crash report and test reproducer credit goes to Zheng Yejian]

Link: https://lore.kernel.org/linux-trace-kernel/1676376403-16462-1-git-send-email-quic_mojha@quicinc.com

Cc: <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 1039221cc278 ("ring-buffer: Do not disable recording when there is an iterator")
Reported-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1581,19 +1581,6 @@ static int rb_check_bpage(struct ring_bu
 }
 
 /**
- * rb_check_list - make sure a pointer to a list has the last bits zero
- */
-static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
-			 struct list_head *list)
-{
-	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev) != list->prev))
-		return 1;
-	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->next) != list->next))
-		return 1;
-	return 0;
-}
-
-/**
  * rb_check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
  *
@@ -1602,36 +1589,27 @@ static int rb_check_list(struct ring_buf
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = cpu_buffer->pages;
-	struct buffer_page *bpage, *tmp;
+	struct list_head *head = rb_list_head(cpu_buffer->pages);
+	struct list_head *tmp;
 
-	/* Reset the head page if it exists */
-	if (cpu_buffer->head_page)
-		rb_set_head_page(cpu_buffer);
-
-	rb_head_page_deactivate(cpu_buffer);
-
-	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
-		return -1;
-	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
+	if (RB_WARN_ON(cpu_buffer,
+			rb_list_head(rb_list_head(head->next)->prev) != head))
 		return -1;
 
-	if (rb_check_list(cpu_buffer, head))
+	if (RB_WARN_ON(cpu_buffer,
+			rb_list_head(rb_list_head(head->prev)->next) != head))
 		return -1;
 
-	list_for_each_entry_safe(bpage, tmp, head, list) {
+	for (tmp = rb_list_head(head->next); tmp != head; tmp = rb_list_head(tmp->next)) {
 		if (RB_WARN_ON(cpu_buffer,
-			       bpage->list.next->prev != &bpage->list))
+				rb_list_head(rb_list_head(tmp->next)->prev) != tmp))
 			return -1;
+
 		if (RB_WARN_ON(cpu_buffer,
-			       bpage->list.prev->next != &bpage->list))
-			return -1;
-		if (rb_check_list(cpu_buffer, &bpage->list))
+				rb_list_head(rb_list_head(tmp->prev)->next) != tmp))
 			return -1;
 	}
 
-	rb_head_page_activate(cpu_buffer);
-
 	return 0;
 }
 


