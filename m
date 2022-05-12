Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB1E52578E
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 00:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359044AbiELWIZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 12 May 2022 18:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345855AbiELWIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 18:08:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E82802F6
        for <stable@vger.kernel.org>; Thu, 12 May 2022 15:08:20 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CLKHYE000359
        for <stable@vger.kernel.org>; Thu, 12 May 2022 15:08:20 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g17vysu0b-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 12 May 2022 15:08:20 -0700
Received: from twshared29473.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 15:08:17 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 4664B78E5C26; Thu, 12 May 2022 15:08:13 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <rostedt@goodmis.org>, <kernel-team@fb.com>,
        Song Liu <song@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] ftrace: clean up hash direct_functions on register failures
Date:   Thu, 12 May 2022 15:08:08 -0700
Message-ID: <20220512220808.766832-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ft6S0lYTV8qmFtiLkhQg3xJ_rSPyKgbf
X-Proofpoint-GUID: Ft6S0lYTV8qmFtiLkhQg3xJ_rSPyKgbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_18,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: 763e34e74bb7 ("ftrace: Add register_ftrace_direct()")
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/trace/ftrace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4f1d2f5e7263..375293c5f3e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4465,7 +4465,7 @@ int ftrace_func_mapper_add_ip(struct ftrace_func_mapper *mapper,
  * @ip: The instruction pointer address to remove the data from
  *
  * Returns the data if it is found, otherwise NULL.
- * Note, if the data pointer is used as the data itself, (see 
+ * Note, if the data pointer is used as the data itself, (see
  * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
  * if the data pointer was set to zero.
  */
@@ -5200,8 +5200,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 
 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
 		ret = register_ftrace_function(&direct_ops);
-		if (ret)
+		if (ret) {
 			ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
+			remove_hash_entry(direct_functions, entry);
+		}
 	}
 
 	if (ret) {
-- 
2.30.2

