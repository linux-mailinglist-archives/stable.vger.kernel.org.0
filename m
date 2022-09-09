Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F4A5B3EDF
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIISdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiIISc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE18E124609
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E190620BA
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 18:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E449C433C1;
        Fri,  9 Sep 2022 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662748376;
        bh=JoVkuvTHyhu0+M45zm1wnaoudIg7elgFeV9Jd4AhV84=;
        h=Subject:To:Cc:From:Date:From;
        b=qyrKO0fk2zjCcx2JXF/WLNS1LR0+0r3OE69qz05pUNwyfxNxlRkcUtD9+b7n9sh3z
         nExvhW0zMSFs2tlyLI9w4sVDLGL6pHRPAnrJYr4nSIse+h9+tX0/2IlmP5A5JKKjH4
         +5e3PmjBS2hbKBDPbqtk84iPcSzpPbLlE4uGsA/U=
Subject: FAILED: patch "[PATCH] kprobes: Prohibit probes in gate area" failed to apply to 4.9-stable tree
To:     lk@c--e.de, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, naveen.n.rao@linux.ibm.com,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Sep 2022 20:32:54 +0200
Message-ID: <16627483742937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1efda38d6f9b ("kprobes: Prohibit probes in gate area")
28f6c37a2910 ("kprobes: Forbid probing on trampoline and BPF code areas")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1efda38d6f9ba26ac88b359c6277f1172db03f1e Mon Sep 17 00:00:00 2001
From: "Christian A. Ehrhardt" <lk@c--e.de>
Date: Wed, 7 Sep 2022 22:09:17 +0200
Subject: [PATCH] kprobes: Prohibit probes in gate area

The system call gate area counts as kernel text but trying
to install a kprobe in this area fails with an Oops later on.
To fix this explicitly disallow the gate area for kprobes.

Found by syzkaller with the following reproducer:
perf_event_open$cgroup(&(0x7f00000001c0)={0x6, 0x80, 0x0, 0x0, 0x0, 0x0, 0x80ffff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, @perf_config_ext={0x0, 0xffffffffff600000}}, 0xffffffffffffffff, 0x0, 0xffffffffffffffff, 0x0)

Sample report:
BUG: unable to handle page fault for address: fffffbfff3ac6000
PGD 6dfcb067 P4D 6dfcb067 PUD 6df8f067 PMD 6de4d067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 PID: 21978 Comm: syz-executor.2 Not tainted 6.0.0-rc3-00363-g7726d4c3e60b-dirty #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:__insn_get_emulate_prefix arch/x86/lib/insn.c:91 [inline]
RIP: 0010:insn_get_emulate_prefix arch/x86/lib/insn.c:106 [inline]
RIP: 0010:insn_get_prefixes.part.0+0xa8/0x1110 arch/x86/lib/insn.c:134
Code: 49 be 00 00 00 00 00 fc ff df 48 8b 40 60 48 89 44 24 08 e9 81 00 00 00 e8 e5 4b 39 ff 4c 89 fa 4c 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 32 38 ca 7f 08 84 d2 0f 85 06 10 00 00 48 89 d8 48 89
RSP: 0018:ffffc900088bf860 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffffffff9b9bebc0 RCX: 0000000000000000
RDX: 1ffffffff3ac6000 RSI: ffffc90002d82000 RDI: ffffc900088bf9e8
RBP: ffffffff9d630001 R08: 0000000000000000 R09: ffffc900088bf9e8
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffffffff9d630000 R14: dffffc0000000000 R15: ffffffff9d630000
FS:  00007f63eef63640(0000) GS:ffff88806d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3ac6000 CR3: 0000000029d90005 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 insn_get_prefixes arch/x86/lib/insn.c:131 [inline]
 insn_get_opcode arch/x86/lib/insn.c:272 [inline]
 insn_get_modrm+0x64a/0x7b0 arch/x86/lib/insn.c:343
 insn_get_sib+0x29a/0x330 arch/x86/lib/insn.c:421
 insn_get_displacement+0x350/0x6b0 arch/x86/lib/insn.c:464
 insn_get_immediate arch/x86/lib/insn.c:632 [inline]
 insn_get_length arch/x86/lib/insn.c:707 [inline]
 insn_decode+0x43a/0x490 arch/x86/lib/insn.c:747
 can_probe+0xfc/0x1d0 arch/x86/kernel/kprobes/core.c:282
 arch_prepare_kprobe+0x79/0x1c0 arch/x86/kernel/kprobes/core.c:739
 prepare_kprobe kernel/kprobes.c:1160 [inline]
 register_kprobe kernel/kprobes.c:1641 [inline]
 register_kprobe+0xb6e/0x1690 kernel/kprobes.c:1603
 __register_trace_kprobe kernel/trace/trace_kprobe.c:509 [inline]
 __register_trace_kprobe+0x26a/0x2d0 kernel/trace/trace_kprobe.c:477
 create_local_trace_kprobe+0x1f7/0x350 kernel/trace/trace_kprobe.c:1833
 perf_kprobe_init+0x18c/0x280 kernel/trace/trace_event_perf.c:271
 perf_kprobe_event_init+0xf8/0x1c0 kernel/events/core.c:9888
 perf_try_init_event+0x12d/0x570 kernel/events/core.c:11261
 perf_init_event kernel/events/core.c:11325 [inline]
 perf_event_alloc.part.0+0xf7f/0x36a0 kernel/events/core.c:11619
 perf_event_alloc kernel/events/core.c:12059 [inline]
 __do_sys_perf_event_open+0x4a8/0x2a00 kernel/events/core.c:12157
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f63ef7efaed
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f63eef63028 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 00007f63ef90ff80 RCX: 00007f63ef7efaed
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 00000000200001c0
RBP: 00007f63ef86019c R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000002 R14: 00007f63ef90ff80 R15: 00007f63eef43000
 </TASK>
Modules linked in:
CR2: fffffbfff3ac6000
---[ end trace 0000000000000000 ]---
RIP: 0010:__insn_get_emulate_prefix arch/x86/lib/insn.c:91 [inline]
RIP: 0010:insn_get_emulate_prefix arch/x86/lib/insn.c:106 [inline]
RIP: 0010:insn_get_prefixes.part.0+0xa8/0x1110 arch/x86/lib/insn.c:134
Code: 49 be 00 00 00 00 00 fc ff df 48 8b 40 60 48 89 44 24 08 e9 81 00 00 00 e8 e5 4b 39 ff 4c 89 fa 4c 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 32 38 ca 7f 08 84 d2 0f 85 06 10 00 00 48 89 d8 48 89
RSP: 0018:ffffc900088bf860 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffffffff9b9bebc0 RCX: 0000000000000000
RDX: 1ffffffff3ac6000 RSI: ffffc90002d82000 RDI: ffffc900088bf9e8
RBP: ffffffff9d630001 R08: 0000000000000000 R09: ffffc900088bf9e8
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffffffff9d630000 R14: dffffc0000000000 R15: ffffffff9d630000
FS:  00007f63eef63640(0000) GS:ffff88806d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3ac6000 CR3: 0000000029d90005 CR4: 0000000000770ef0
PKRU: 55555554
==================================================================

Link: https://lkml.kernel.org/r/20220907200917.654103-1-lk@c--e.de

cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 08350e35aba2..ca9d834d0b84 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1562,6 +1562,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	/* Ensure it is not in reserved area nor out of text */
 	if (!(core_kernel_text((unsigned long) p->addr) ||
 	    is_module_text_address((unsigned long) p->addr)) ||
+	    in_gate_area_no_mm((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    static_call_text_reserved(p->addr, p->addr) ||

