Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E573E80C9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhHJRw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237315AbhHJRuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C71161076;
        Tue, 10 Aug 2021 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617358;
        bh=VX9BCv/xjhp3lzPf4kDY4Ob7smi3OWrnyPp1j+Ehe5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMPTKutpoyHzbQWbHLdtNyziNG65G6vUVC07QZLbe7XIrmOdeeS9oJHXs8asfZTK6
         FXZbGPKRylMsp2kmMIFc+NgBSvXKem/bAFyLfXswjQHJKG7MNh6XBI2a8pnJ29jBFh
         +OE5aqrtFoa9kDIhX1Y6Zob1WWZbWSDIhBU/JEds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Wende Tan <twd2.me@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 023/175] riscv: stacktrace: Fix NULL pointer dereference
Date:   Tue, 10 Aug 2021 19:28:51 +0200
Message-Id: <20210810173001.717955153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 78d9d8005e4556448f398d876f29d0ca7ab8e398 ]

When CONFIG_FRAME_POINTER=y, calling dump_stack() can always trigger
NULL pointer dereference panic similar as below:

[    0.396060] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5+ #47
[    0.396692] Hardware name: riscv-virtio,qemu (DT)
[    0.397176] Call Trace:
[    0.398191] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000960
[    0.399487] Oops [#1]
[    0.399739] Modules linked in:
[    0.400135] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5+ #47
[    0.400570] Hardware name: riscv-virtio,qemu (DT)
[    0.400926] epc : walk_stackframe+0xc4/0xdc
[    0.401291]  ra : dump_backtrace+0x30/0x38
[    0.401630] epc : ffffffff80004922 ra : ffffffff8000496a sp : ffffffe000f3bd00
[    0.402115]  gp : ffffffff80cfdcb8 tp : ffffffe000f30000 t0 : ffffffff80d0b0cf
[    0.402602]  t1 : ffffffff80d0b0c0 t2 : 0000000000000000 s0 : ffffffe000f3bd60
[    0.403071]  s1 : ffffffff808bc2e8 a0 : 0000000000001000 a1 : 0000000000000000
[    0.403448]  a2 : ffffffff803d7088 a3 : ffffffff808bc2e8 a4 : 6131725dbc24d400
[    0.403820]  a5 : 0000000000001000 a6 : 0000000000000002 a7 : ffffffffffffffff
[    0.404226]  s2 : 0000000000000000 s3 : 0000000000000000 s4 : 0000000000000000
[    0.404634]  s5 : ffffffff803d7088 s6 : ffffffff808bc2e8 s7 : ffffffff80630650
[    0.405085]  s8 : ffffffff80912a80 s9 : 0000000000000008 s10: ffffffff804000fc
[    0.405388]  s11: 0000000000000000 t3 : 0000000000000043 t4 : ffffffffffffffff
[    0.405616]  t5 : 000000000000003d t6 : ffffffe000f3baa8
[    0.405793] status: 0000000000000100 badaddr: 0000000000000960 cause: 000000000000000d
[    0.406135] [<ffffffff80004922>] walk_stackframe+0xc4/0xdc
[    0.407032] [<ffffffff8000496a>] dump_backtrace+0x30/0x38
[    0.407797] [<ffffffff803d7100>] show_stack+0x40/0x4c
[    0.408234] [<ffffffff803d9e5c>] dump_stack+0x90/0xb6
[    0.409019] [<ffffffff8040423e>] ptdump_init+0x20/0xc4
[    0.409681] [<ffffffff800015b6>] do_one_initcall+0x4c/0x226
[    0.410110] [<ffffffff80401094>] kernel_init_freeable+0x1f4/0x258
[    0.410562] [<ffffffff803dba88>] kernel_init+0x22/0x148
[    0.410959] [<ffffffff800029e2>] ret_from_exception+0x0/0x14
[    0.412241] ---[ end trace b2ab92c901b96251 ]---
[    0.413099] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

The reason is the task is NULL when we finally call walk_stackframe()
the NULL is passed from __dump_stack():

|static void __dump_stack(void)
|{
|        dump_stack_print_info(KERN_DEFAULT);
|        show_stack(NULL, NULL, KERN_DEFAULT);
|}

Fix this issue by checking "task == NULL" case in walk_stackframe().

Fixes: eac2f3059e02 ("riscv: stacktrace: fix the riscv stacktrace when CONFIG_FRAME_POINTER enabled")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Tested-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index bde85fc53357..7bc8af75933a 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -27,7 +27,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		fp = frame_pointer(regs);
 		sp = user_stack_pointer(regs);
 		pc = instruction_pointer(regs);
-	} else if (task == current) {
+	} else if (task == NULL || task == current) {
 		fp = (unsigned long)__builtin_frame_address(1);
 		sp = (unsigned long)__builtin_frame_address(0);
 		pc = (unsigned long)__builtin_return_address(0);
-- 
2.30.2



