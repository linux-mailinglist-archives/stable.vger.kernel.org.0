Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627AD3F66FF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbhHXRaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241420AbhHXR2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD50161B4D;
        Tue, 24 Aug 2021 17:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824716;
        bh=1kRpprg/j+gLhb8ebzOl1BbBge/NZmDLjhBqolXtAnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFEG0oQzzz+XWqw2I36prpVSqaUvMuGZZ166iNoKKCx3s8fmt/EKmNUrpa5/1AYct
         QCHIODesdR7DnpvMKzrycLSAvgYKLS0FtTkw3cXyGWjp4Fa9jc0xFV6+W8H9jHnoGh
         tuoUMlJ6z3wawC+xAznS8vyHMwKd7qt/yyFDNpw5IPkwxu6Y0vpxShiBetfrtx5QIy
         +9UJ351LqptGY1xl7QCMq2pKiA3r/H5kDb0hyylscJJFr8fhoPBS5RMBnC12RBYgae
         VFkZ98i9OvC7tCD2XSJpOVgyI3GPDjePkvmpWrPLRRG35wvl9QoxvOoN51QvZQY05I
         EmglqhXm9qsPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pu Lehui <pulehui@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/64] powerpc/kprobes: Fix kprobe Oops happens in booke
Date:   Tue, 24 Aug 2021 13:04:11 -0400
Message-Id: <20210824170457.710623-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 43e8f76006592cb1573a959aa287c45421066f9c ]

When using kprobe on powerpc booke series processor, Oops happens
as show bellow:

/ # echo "p:myprobe do_nanosleep" > /sys/kernel/debug/tracing/kprobe_events
/ # echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable
/ # sleep 1
[   50.076730] Oops: Exception in kernel mode, sig: 5 [#1]
[   50.077017] BE PAGE_SIZE=4K SMP NR_CPUS=24 QEMU e500
[   50.077221] Modules linked in:
[   50.077462] CPU: 0 PID: 77 Comm: sleep Not tainted 5.14.0-rc4-00022-g251a1524293d #21
[   50.077887] NIP:  c0b9c4e0 LR: c00ebecc CTR: 00000000
[   50.078067] REGS: c3883de0 TRAP: 0700   Not tainted (5.14.0-rc4-00022-g251a1524293d)
[   50.078349] MSR:  00029000 <CE,EE,ME>  CR: 24000228  XER: 20000000
[   50.078675]
[   50.078675] GPR00: c00ebdf0 c3883e90 c313e300 c3883ea0 00000001 00000000 c3883ecc 00000001
[   50.078675] GPR08: c100598c c00ea250 00000004 00000000 24000222 102490c2 bff4180c 101e60d4
[   50.078675] GPR16: 00000000 102454ac 00000040 10240000 10241100 102410f8 10240000 00500000
[   50.078675] GPR24: 00000002 00000000 c3883ea0 00000001 00000000 0000c350 3b9b8d50 00000000
[   50.080151] NIP [c0b9c4e0] do_nanosleep+0x0/0x190
[   50.080352] LR [c00ebecc] hrtimer_nanosleep+0x14c/0x1e0
[   50.080638] Call Trace:
[   50.080801] [c3883e90] [c00ebdf0] hrtimer_nanosleep+0x70/0x1e0 (unreliable)
[   50.081110] [c3883f00] [c00ec004] sys_nanosleep_time32+0xa4/0x110
[   50.081336] [c3883f40] [c001509c] ret_from_syscall+0x0/0x28
[   50.081541] --- interrupt: c00 at 0x100a4d08
[   50.081749] NIP:  100a4d08 LR: 101b5234 CTR: 00000003
[   50.081931] REGS: c3883f50 TRAP: 0c00   Not tainted (5.14.0-rc4-00022-g251a1524293d)
[   50.082183] MSR:  0002f902 <CE,EE,PR,FP,ME>  CR: 24000222  XER: 00000000
[   50.082457]
[   50.082457] GPR00: 000000a2 bf980040 1024b4d0 bf980084 bf980084 64000000 00555345 fefefeff
[   50.082457] GPR08: 7f7f7f7f 101e0000 00000069 00000003 28000422 102490c2 bff4180c 101e60d4
[   50.082457] GPR16: 00000000 102454ac 00000040 10240000 10241100 102410f8 10240000 00500000
[   50.082457] GPR24: 00000002 bf9803f4 10240000 00000000 00000000 100039e0 00000000 102444e8
[   50.083789] NIP [100a4d08] 0x100a4d08
[   50.083917] LR [101b5234] 0x101b5234
[   50.084042] --- interrupt: c00
[   50.084238] Instruction dump:
[   50.084483] 4bfffc40 60000000 60000000 60000000 9421fff0 39400402 914200c0 38210010
[   50.084841] 4bfffc20 00000000 00000000 00000000 <7fe00008> 7c0802a6 7c892378 93c10048
[   50.085487] ---[ end trace f6fffe98e2fa8f3e ]---
[   50.085678]
Trace/breakpoint trap

There is no real mode for booke arch and the MMU translation is
always on. The corresponding MSR_IS/MSR_DS bit in booke is used
to switch the address space, but not for real mode judgment.

Fixes: 21f8b2fa3ca5 ("powerpc/kprobes: Ignore traps that happened in real mode")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210809023658.218915-1-pulehui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/kprobes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 07d3f3b40246..b8b62df102f1 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -279,7 +279,8 @@ int kprobe_handler(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	if (!(regs->msr & MSR_IR) || !(regs->msr & MSR_DR))
+	if (!IS_ENABLED(CONFIG_BOOKE) &&
+	    (!(regs->msr & MSR_IR) || !(regs->msr & MSR_DR)))
 		return 0;
 
 	/*
-- 
2.30.2

