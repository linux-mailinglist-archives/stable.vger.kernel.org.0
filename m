Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D26526F3B3
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIRDIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgIRCDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 263F421734;
        Fri, 18 Sep 2020 02:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394598;
        bh=3UzKPJpQ37RhRn+1oYQIhbxWLpk7fMNkZoK9Ve7/WU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PF0vUiatpdYfODYD7Ow8pkjgOqHD+ojKe/FHLOYOtmdRIgayCb2rG55BS4Q1yDKMj
         8rhr/eqtO38MU1hMLbMZRtkb92854TMqiiSuYY91oC51KdYai2tYv4/CjDk26Tc+jq
         FDl1+8ypEUt2UE1DIS7YdYvarKjW52KyuFgBPf5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 106/330] ARM: 8948/1: Prevent OOB access in stacktrace
Date:   Thu, 17 Sep 2020 21:57:26 -0400
Message-Id: <20200918020110.2063155-106-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 40ff1ddb5570284e039e0ff14d7a859a73dc3673 ]

The stacktrace code can read beyond the stack size, when it attempts to
read pt_regs from exception frames.

This can happen on normal, non-corrupt stacks.  Since the unwind
information in the extable is not correct for function prologues, the
unwinding code can return data from the stack which is not actually the
caller function address, and if in_entry_text() happens to succeed on
this value, we can end up reading data from outside the task's stack
when attempting to read pt_regs, since there is no bounds check.

Example:

 [<8010e729>] (unwind_backtrace) from [<8010a9c9>] (show_stack+0x11/0x14)
 [<8010a9c9>] (show_stack) from [<8057d8d7>] (dump_stack+0x87/0xac)
 [<8057d8d7>] (dump_stack) from [<8012271d>] (tasklet_action_common.constprop.4+0xa5/0xa8)
 [<8012271d>] (tasklet_action_common.constprop.4) from [<80102333>] (__do_softirq+0x11b/0x31c)
 [<80102333>] (__do_softirq) from [<80122485>] (irq_exit+0xad/0xd8)
 [<80122485>] (irq_exit) from [<8015f3d7>] (__handle_domain_irq+0x47/0x84)
 [<8015f3d7>] (__handle_domain_irq) from [<8036a523>] (gic_handle_irq+0x43/0x78)
 [<8036a523>] (gic_handle_irq) from [<80101a49>] (__irq_svc+0x69/0xb4)
 Exception stack(0xeb491f58 to 0xeb491fa0)
 1f40:                                                       7eb14794 00000000
 1f60: ffffffff 008dd32c 008dd324 ffffffff 008dd314 0000002a 801011e4 eb490000
 1f80: 0000002a 7eb1478c 50c5387d eb491fa8 80101001 8023d09c 40080033 ffffffff
 [<80101a49>] (__irq_svc) from [<8023d09c>] (do_pipe2+0x0/0xac)
 [<8023d09c>] (do_pipe2) from [<ffffffff>] (0xffffffff)
 Exception stack(0xeb491fc8 to 0xeb492010)
 1fc0:                   008dd314 0000002a 00511ad8 008de4c8 7eb14790 7eb1478c
 1fe0: 00511e34 7eb14774 004c8557 76f44098 60080030 7eb14794 00000000 00000000
 2000: 00000001 00000000 ea846c00 ea847cc0

In this example, the stack limit is 0xeb492000, but 16 bytes outside the
stack have been read.

Fix it by adding bounds checks.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/stacktrace.c | 2 ++
 arch/arm/kernel/traps.c      | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index a082f6e4f0f4a..76ea4178a55cb 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -116,6 +116,8 @@ static int save_trace(struct stackframe *frame, void *d)
 		return 0;
 
 	regs = (struct pt_regs *)frame->sp;
+	if ((unsigned long)&regs[1] > ALIGN(frame->sp, THREAD_SIZE))
+		return 0;
 
 	trace->entries[trace->nr_entries++] = regs->ARM_pc;
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index c053abd1fb539..97a512551b217 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -64,14 +64,16 @@ static void dump_mem(const char *, const char *, unsigned long, unsigned long);
 
 void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame)
 {
+	unsigned long end = frame + 4 + sizeof(struct pt_regs);
+
 #ifdef CONFIG_KALLSYMS
 	printk("[<%08lx>] (%ps) from [<%08lx>] (%pS)\n", where, (void *)where, from, (void *)from);
 #else
 	printk("Function entered at [<%08lx>] from [<%08lx>]\n", where, from);
 #endif
 
-	if (in_entry_text(from))
-		dump_mem("", "Exception stack", frame + 4, frame + 4 + sizeof(struct pt_regs));
+	if (in_entry_text(from) && end <= ALIGN(frame, THREAD_SIZE))
+		dump_mem("", "Exception stack", frame + 4, end);
 }
 
 void dump_backtrace_stm(u32 *stack, u32 instruction)
-- 
2.25.1

