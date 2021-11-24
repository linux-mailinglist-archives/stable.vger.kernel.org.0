Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6079245BB2E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhKXMR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243717AbhKXMPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:15:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0677610FF;
        Wed, 24 Nov 2021 12:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755806;
        bh=4z52jqCN3AgHIqU92bBhqstzoyr6b5Bx4iZHdmGduLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXTO31Dx/kIpF8wwbFf786H8kFqJpKkXpTw8DuzO0yegNumHBJw/SIpnhmIXrfZoi
         Xlc2bLWFyjStkSaIfpZwEYRcH5vdJXT1hkHM8kr8m2JU80POHNwGFZt5efNysiTnLC
         xW0tsWHS2d5J50/ES57BJllwRxHCzRTWY+fOPfnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/207] media: netup_unidvb: handle interrupt properly according to the firmware
Date:   Wed, 24 Nov 2021 12:55:36 +0100
Message-Id: <20211124115706.029924770@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit dbb4cfea6efe979ed153bd59a6a527a90d3d0ab3 ]

The interrupt handling should be related to the firmware version. If
the driver matches an old firmware, then the driver should not handle
interrupt such as i2c or dma, otherwise it will cause some errors.

This log reveals it:

[   27.708641] INFO: trying to register non-static key.
[   27.710851] The code is fine but needs lockdep annotation, or maybe
[   27.712010] you didn't initialize this object before use?
[   27.712396] turning off the locking correctness validator.
[   27.712787] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.12.4-g70e7f0549188-dirty #169
[   27.713349] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   27.714149] Call Trace:
[   27.714329]  <IRQ>
[   27.714480]  dump_stack+0xba/0xf5
[   27.714737]  register_lock_class+0x873/0x8f0
[   27.715052]  ? __lock_acquire+0x323/0x1930
[   27.715353]  __lock_acquire+0x75/0x1930
[   27.715636]  lock_acquire+0x1dd/0x3e0
[   27.715905]  ? netup_i2c_interrupt+0x19/0x310
[   27.716226]  _raw_spin_lock_irqsave+0x4b/0x60
[   27.716544]  ? netup_i2c_interrupt+0x19/0x310
[   27.716863]  netup_i2c_interrupt+0x19/0x310
[   27.717178]  netup_unidvb_isr+0xd3/0x160
[   27.717467]  __handle_irq_event_percpu+0x53/0x3e0
[   27.717808]  handle_irq_event_percpu+0x35/0x90
[   27.718129]  handle_irq_event+0x39/0x60
[   27.718409]  handle_fasteoi_irq+0xc2/0x1d0
[   27.718707]  __common_interrupt+0x7f/0x150
[   27.719008]  common_interrupt+0xb4/0xd0
[   27.719289]  </IRQ>
[   27.719446]  asm_common_interrupt+0x1e/0x40
[   27.719747] RIP: 0010:native_safe_halt+0x17/0x20
[   27.720084] Code: 07 0f 00 2d 8b ee 4c 00 f4 5d c3 0f 1f 84 00 00 00 00 00 8b 05 72 95 17 02 55 48 89 e5 85 c0 7e 07 0f 00 2d 6b ee 4c 00 fb f4 <5d> c3 cc cc cc cc cc cc cc 55 48 89 e5 e8 67 53 ff ff 8b 0d 29 f6
[   27.721386] RSP: 0018:ffffc9000008fe90 EFLAGS: 00000246
[   27.721758] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[   27.722262] RDX: 0000000000000000 RSI: ffffffff85f7c054 RDI: ffffffff85ded4e6
[   27.722770] RBP: ffffc9000008fe90 R08: 0000000000000001 R09: 0000000000000001
[   27.723277] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff86a75408
[   27.723781] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888100260000
[   27.724289]  default_idle+0x9/0x10
[   27.724537]  arch_cpu_idle+0xa/0x10
[   27.724791]  default_idle_call+0x6e/0x250
[   27.725082]  do_idle+0x1f0/0x2d0
[   27.725326]  cpu_startup_entry+0x18/0x20
[   27.725613]  start_secondary+0x11f/0x160
[   27.725902]  secondary_startup_64_no_verify+0xb0/0xbb
[   27.726272] BUG: kernel NULL pointer dereference, address: 0000000000000002
[   27.726768] #PF: supervisor read access in kernel mode
[   27.727138] #PF: error_code(0x0000) - not-present page
[   27.727507] PGD 8000000118688067 P4D 8000000118688067 PUD 10feab067 PMD 0
[   27.727999] Oops: 0000 [#1] PREEMPT SMP PTI
[   27.728302] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.12.4-g70e7f0549188-dirty #169
[   27.728861] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   27.729660] RIP: 0010:netup_i2c_interrupt+0x23/0x310
[   27.730019] Code: 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 89 fb e8 af 6e 95 fd 48 89 df e8 e7 9f 1c 01 49 89 c5 48 8b 83 48 08 00 00 <66> 44 8b 60 02 44 89 e0 48 8b 93 48 08 00 00 83 e0 f8 66 89 42 02
[   27.731339] RSP: 0018:ffffc90000118e90 EFLAGS: 00010046
[   27.731716] RAX: 0000000000000000 RBX: ffff88810803c4d8 RCX: 0000000000000000
[   27.732223] RDX: 0000000000000001 RSI: ffffffff85d37b94 RDI: ffff88810803c4d8
[   27.732727] RBP: ffffc90000118ea8 R08: 0000000000000000 R09: 0000000000000001
[   27.733239] R10: ffff88810803c4f0 R11: 61646e6f63657320 R12: 0000000000000000
[   27.733745] R13: 0000000000000046 R14: ffff888101041000 R15: ffff8881081b2400
[   27.734251] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000) knlGS:0000000000000000
[   27.734821] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.735228] CR2: 0000000000000002 CR3: 0000000108194000 CR4: 00000000000006e0
[   27.735735] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   27.736241] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   27.736744] Call Trace:
[   27.736924]  <IRQ>
[   27.737074]  netup_unidvb_isr+0xd3/0x160
[   27.737363]  __handle_irq_event_percpu+0x53/0x3e0
[   27.737706]  handle_irq_event_percpu+0x35/0x90
[   27.738028]  handle_irq_event+0x39/0x60
[   27.738306]  handle_fasteoi_irq+0xc2/0x1d0
[   27.738602]  __common_interrupt+0x7f/0x150
[   27.738899]  common_interrupt+0xb4/0xd0
[   27.739176]  </IRQ>
[   27.739331]  asm_common_interrupt+0x1e/0x40
[   27.739633] RIP: 0010:native_safe_halt+0x17/0x20
[   27.739967] Code: 07 0f 00 2d 8b ee 4c 00 f4 5d c3 0f 1f 84 00 00 00 00 00 8b 05 72 95 17 02 55 48 89 e5 85 c0 7e 07 0f 00 2d 6b ee 4c 00 fb f4 <5d> c3 cc cc cc cc cc cc cc 55 48 89 e5 e8 67 53 ff ff 8b 0d 29 f6
[   27.741275] RSP: 0018:ffffc9000008fe90 EFLAGS: 00000246
[   27.741647] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[   27.742148] RDX: 0000000000000000 RSI: ffffffff85f7c054 RDI: ffffffff85ded4e6
[   27.742652] RBP: ffffc9000008fe90 R08: 0000000000000001 R09: 0000000000000001
[   27.743154] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff86a75408
[   27.743652] R13: 0000000000000000 R14: 0000000000000000 R15: ffff888100260000
[   27.744157]  default_idle+0x9/0x10
[   27.744405]  arch_cpu_idle+0xa/0x10
[   27.744658]  default_idle_call+0x6e/0x250
[   27.744948]  do_idle+0x1f0/0x2d0
[   27.745190]  cpu_startup_entry+0x18/0x20
[   27.745475]  start_secondary+0x11f/0x160
[   27.745761]  secondary_startup_64_no_verify+0xb0/0xbb
[   27.746123] Modules linked in:
[   27.746348] Dumping ftrace buffer:
[   27.746596]    (ftrace buffer empty)
[   27.746852] CR2: 0000000000000002
[   27.747094] ---[ end trace ebafd46f83ab946d ]---
[   27.747424] RIP: 0010:netup_i2c_interrupt+0x23/0x310
[   27.747778] Code: 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 89 fb e8 af 6e 95 fd 48 89 df e8 e7 9f 1c 01 49 89 c5 48 8b 83 48 08 00 00 <66> 44 8b 60 02 44 89 e0 48 8b 93 48 08 00 00 83 e0 f8 66 89 42 02
[   27.749082] RSP: 0018:ffffc90000118e90 EFLAGS: 00010046
[   27.749461] RAX: 0000000000000000 RBX: ffff88810803c4d8 RCX: 0000000000000000
[   27.749966] RDX: 0000000000000001 RSI: ffffffff85d37b94 RDI: ffff88810803c4d8
[   27.750471] RBP: ffffc90000118ea8 R08: 0000000000000000 R09: 0000000000000001
[   27.750976] R10: ffff88810803c4f0 R11: 61646e6f63657320 R12: 0000000000000000
[   27.751480] R13: 0000000000000046 R14: ffff888101041000 R15: ffff8881081b2400
[   27.751986] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000) knlGS:0000000000000000
[   27.752560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.752970] CR2: 0000000000000002 CR3: 0000000108194000 CR4: 00000000000006e0
[   27.753481] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   27.753984] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   27.754487] Kernel panic - not syncing: Fatal exception in interrupt
[   27.755033] Dumping ftrace buffer:
[   27.755279]    (ftrace buffer empty)
[   27.755534] Kernel Offset: disabled
[   27.755785] Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/netup_unidvb/netup_unidvb_core.c      | 27 +++++++++++--------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index b078ac2a682cf..48e1f4a128019 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -266,19 +266,24 @@ static irqreturn_t netup_unidvb_isr(int irq, void *dev_id)
 	if ((reg40 & AVL_IRQ_ASSERTED) != 0) {
 		/* IRQ is being signaled */
 		reg_isr = readw(ndev->bmmio0 + REG_ISR);
-		if (reg_isr & NETUP_UNIDVB_IRQ_I2C0) {
-			iret = netup_i2c_interrupt(&ndev->i2c[0]);
-		} else if (reg_isr & NETUP_UNIDVB_IRQ_I2C1) {
-			iret = netup_i2c_interrupt(&ndev->i2c[1]);
-		} else if (reg_isr & NETUP_UNIDVB_IRQ_SPI) {
+		if (reg_isr & NETUP_UNIDVB_IRQ_SPI)
 			iret = netup_spi_interrupt(ndev->spi);
-		} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA1) {
-			iret = netup_dma_interrupt(&ndev->dma[0]);
-		} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA2) {
-			iret = netup_dma_interrupt(&ndev->dma[1]);
-		} else if (reg_isr & NETUP_UNIDVB_IRQ_CI) {
-			iret = netup_ci_interrupt(ndev);
+		else if (!ndev->old_fw) {
+			if (reg_isr & NETUP_UNIDVB_IRQ_I2C0) {
+				iret = netup_i2c_interrupt(&ndev->i2c[0]);
+			} else if (reg_isr & NETUP_UNIDVB_IRQ_I2C1) {
+				iret = netup_i2c_interrupt(&ndev->i2c[1]);
+			} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA1) {
+				iret = netup_dma_interrupt(&ndev->dma[0]);
+			} else if (reg_isr & NETUP_UNIDVB_IRQ_DMA2) {
+				iret = netup_dma_interrupt(&ndev->dma[1]);
+			} else if (reg_isr & NETUP_UNIDVB_IRQ_CI) {
+				iret = netup_ci_interrupt(ndev);
+			} else {
+				goto err;
+			}
 		} else {
+err:
 			dev_err(&pci_dev->dev,
 				"%s(): unknown interrupt 0x%x\n",
 				__func__, reg_isr);
-- 
2.33.0



