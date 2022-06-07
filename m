Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE10532F75
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiEXRJD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 24 May 2022 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiEXRJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 13:09:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F997C149
        for <stable@vger.kernel.org>; Tue, 24 May 2022 10:09:01 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24O8OtCR015419
        for <stable@vger.kernel.org>; Tue, 24 May 2022 10:09:00 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g6urw23j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 24 May 2022 10:09:00 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 24 May 2022 10:08:59 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 8F680809F036; Tue, 24 May 2022 10:08:43 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <rostedt@goodmis.org>, <kernel-team@fb.com>,
        Song Liu <song@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2] ftrace: clean up hash direct_functions on register failures
Date:   Tue, 24 May 2022 10:08:39 -0700
Message-ID: <20220524170839.900849-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZcHL8O_TQr9dE6Fy7FogERuerpQ0_MMg
X-Proofpoint-ORIG-GUID: ZcHL8O_TQr9dE6Fy7FogERuerpQ0_MMg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_08,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 kernel/trace/ftrace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4557023295c2..fa6de95a4e4e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4448,7 +4448,7 @@ int ftrace_func_mapper_add_ip(struct ftrace_func_mapper *mapper,
  * @ip: The instruction pointer address to remove the data from
  *
  * Returns the data if it is found, otherwise NULL.
- * Note, if the data pointer is used as the data itself, (see 
+ * Note, if the data pointer is used as the data itself, (see
  * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
  * if the data pointer was set to zero.
  */
@@ -5151,8 +5151,6 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 		goto out_unlock;
 
 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
-	if (ret)
-		remove_hash_entry(direct_functions, entry);
 
 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
 		ret = register_ftrace_function(&direct_ops);
@@ -5161,6 +5159,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	}
 
 	if (ret) {
+		remove_hash_entry(direct_functions, entry);
 		kfree(entry);
 		if (!direct->count) {
 			list_del_rcu(&direct->next);
-- 
2.30.2

