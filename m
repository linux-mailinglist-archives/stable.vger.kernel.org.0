Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17325540775
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348233AbiFGRre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349078AbiFGRqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:46:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA0A1ADAE;
        Tue,  7 Jun 2022 10:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7238CB822B1;
        Tue,  7 Jun 2022 17:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF95C385A5;
        Tue,  7 Jun 2022 17:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623393;
        bh=sGmGcqaeMrXf95kZ8mefk5oX6FM7HbV7JXH1UsBZK2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QBenn5ZPdNkWoiXzpOByo1iOwAad7HvucQ4Df2ZqDNkSoLbeZbss3OfR4VWZl0Gk
         Dtm6iZhlmkrXxwGg9/ccWh3r7rYfUpjAVhE2FaGMuDtHRhto+Dmrau4rCJ4NGUxqLd
         lWfmQp1LunuwX726kAS87lRvKt5FWH8g7vR0OZ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <song@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 401/452] ftrace: Clean up hash direct_functions on register failures
Date:   Tue,  7 Jun 2022 19:04:18 +0200
Message-Id: <20220607164920.509614425@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <song@kernel.org>

commit 7d54c15cb89a29a5f59e5ffc9ee62e6591769ef1 upstream.

We see the following GPF when register_ftrace_direct fails:

[ ] general protection fault, probably for non-canonical address \
  0x200000000000010: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
[...]
[ ] RIP: 0010:ftrace_find_rec_direct+0x53/0x70
[ ] Code: 48 c1 e0 03 48 03 42 08 48 8b 10 31 c0 48 85 d2 74 [...]
[ ] RSP: 0018:ffffc9000138bc10 EFLAGS: 00010206
[ ] RAX: 0000000000000000 RBX: ffffffff813e0df0 RCX: 000000000000003b
[ ] RDX: 0200000000000000 RSI: 000000000000000c RDI: ffffffff813e0df0
[ ] RBP: ffffffffa00a3000 R08: ffffffff81180ce0 R09: 0000000000000001
[ ] R10: ffffc9000138bc18 R11: 0000000000000001 R12: ffffffff813e0df0
[ ] R13: ffffffff813e0df0 R14: ffff888171b56400 R15: 0000000000000000
[ ] FS:  00007fa9420c7780(0000) GS:ffff888ff6a00000(0000) knlGS:000000000
[ ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ ] CR2: 000000000770d000 CR3: 0000000107d50003 CR4: 0000000000370ee0
[ ] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ ] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ ] Call Trace:
[ ]  <TASK>
[ ]  register_ftrace_direct+0x54/0x290
[ ]  ? render_sigset_t+0xa0/0xa0
[ ]  bpf_trampoline_update+0x3f5/0x4a0
[ ]  ? 0xffffffffa00a3000
[ ]  bpf_trampoline_link_prog+0xa9/0x140
[ ]  bpf_tracing_prog_attach+0x1dc/0x450
[ ]  bpf_raw_tracepoint_open+0x9a/0x1e0
[ ]  ? find_held_lock+0x2d/0x90
[ ]  ? lock_release+0x150/0x430
[ ]  __sys_bpf+0xbd6/0x2700
[ ]  ? lock_is_held_type+0xd8/0x130
[ ]  __x64_sys_bpf+0x1c/0x20
[ ]  do_syscall_64+0x3a/0x80
[ ]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ ] RIP: 0033:0x7fa9421defa9
[ ] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 9 f8 [...]
[ ] RSP: 002b:00007ffed743bd78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[ ] RAX: ffffffffffffffda RBX: 00000000069d2480 RCX: 00007fa9421defa9
[ ] RDX: 0000000000000078 RSI: 00007ffed743bd80 RDI: 0000000000000011
[ ] RBP: 00007ffed743be00 R08: 0000000000bb7270 R09: 0000000000000000
[ ] R10: 00000000069da210 R11: 0000000000000246 R12: 0000000000000001
[ ] R13: 00007ffed743c4b0 R14: 00000000069d2480 R15: 0000000000000001
[ ]  </TASK>
[ ] Modules linked in: klp_vm(OK)
[ ] ---[ end trace 0000000000000000 ]---

One way to trigger this is:
  1. load a livepatch that patches kernel function xxx;
  2. run bpftrace -e 'kfunc:xxx {}', this will fail (expected for now);
  3. repeat #2 => gpf.

This is because the entry is added to direct_functions, but not removed.
Fix this by remove the entry from direct_functions when
register_ftrace_direct fails.

Also remove the last trailing space from ftrace.c, so we don't have to
worry about it anymore.

Link: https://lkml.kernel.org/r/20220524170839.900849-1-song@kernel.org

Cc: stable@vger.kernel.org
Fixes: 763e34e74bb7 ("ftrace: Add register_ftrace_direct()")
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4427,7 +4427,7 @@ int ftrace_func_mapper_add_ip(struct ftr
  * @ip: The instruction pointer address to remove the data from
  *
  * Returns the data if it is found, otherwise NULL.
- * Note, if the data pointer is used as the data itself, (see 
+ * Note, if the data pointer is used as the data itself, (see
  * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
  * if the data pointer was set to zero.
  */
@@ -5153,8 +5153,6 @@ int register_ftrace_direct(unsigned long
 	__add_hash_entry(direct_functions, entry);
 
 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
-	if (ret)
-		remove_hash_entry(direct_functions, entry);
 
 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
 		ret = register_ftrace_function(&direct_ops);
@@ -5163,6 +5161,7 @@ int register_ftrace_direct(unsigned long
 	}
 
 	if (ret) {
+		remove_hash_entry(direct_functions, entry);
 		kfree(entry);
 		if (!direct->count) {
 			list_del_rcu(&direct->next);


