Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB033BB105
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGDXKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhGDXKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4CC261945;
        Sun,  4 Jul 2021 23:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440044;
        bh=T+5K4vZ0zYT9jdq50clopOjfSKPueviGjMrL64xsLrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdK37x3dsH0WneTjmExTKvI1+jM5FNrr5sw7WiowC5jDvCl8pxKFjVXeTIRDLTwyU
         hMZ7YIiNIy2k76bvfxPcwwLNK/Y7SVWY3n0tC/GF2M5D6x9pALSmAUKsxTq3hRNxKn
         R1/FCY7XG4r/8aZczx4HNyaWe3Qkj1cfN3KcejKxDIgupxDyJVvM6ZWepUP/WAADeh
         tHXlr3vJgPt8M4XBVuF4+BVSpi/d2xQQw+ryshZN92J5QQCJXUQjzqv+ool5zKgkHG
         wkMqrQjhbztvW1mNOftAdBwpDkz6SZKGgr3meDSboKFa+PEBIFpFfk+Ar+5S+W4rIb
         tuXIm7HWzRNrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 50/80] mmc: via-sdmmc: add a check against NULL pointer dereference
Date:   Sun,  4 Jul 2021 19:05:46 -0400
Message-Id: <20210704230616.1489200-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 45c8ddd06c4b729c56a6083ab311bfbd9643f4a6 ]

Before referencing 'host->data', the driver needs to check whether it is
null pointer, otherwise it will cause a null pointer reference.

This log reveals it:

[   29.355199] BUG: kernel NULL pointer dereference, address:
0000000000000014
[   29.357323] #PF: supervisor write access in kernel mode
[   29.357706] #PF: error_code(0x0002) - not-present page
[   29.358088] PGD 0 P4D 0
[   29.358280] Oops: 0002 [#1] PREEMPT SMP PTI
[   29.358595] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.12.4-
g70e7f0549188-dirty #102
[   29.359164] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   29.359978] RIP: 0010:via_sdc_isr+0x21f/0x410
[   29.360314] Code: ff ff e8 84 aa d0 fd 66 45 89 7e 28 66 41 f7 c4 00
10 75 56 e8 72 aa d0 fd 66 41 f7 c4 00 c0 74 10 e8 65 aa d0 fd 48 8b 43
18 <c7> 40 14 ac ff ff ff e8 55 aa d0 fd 48 89 df e8 ad fb ff ff e9 77
[   29.361661] RSP: 0018:ffffc90000118e98 EFLAGS: 00010046
[   29.362042] RAX: 0000000000000000 RBX: ffff888107d77880
RCX: 0000000000000000
[   29.362564] RDX: 0000000000000000 RSI: ffffffff835d20bb
RDI: 00000000ffffffff
[   29.363085] RBP: ffffc90000118ed8 R08: 0000000000000001
R09: 0000000000000001
[   29.363604] R10: 0000000000000000 R11: 0000000000000001
R12: 0000000000008600
[   29.364128] R13: ffff888107d779c8 R14: ffffc90009c00200
R15: 0000000000008000
[   29.364651] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000)
knlGS:0000000000000000
[   29.365235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.365655] CR2: 0000000000000014 CR3: 0000000005a2e000
CR4: 00000000000006e0
[   29.366170] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[   29.366683] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[   29.367197] Call Trace:
[   29.367381]  <IRQ>
[   29.367537]  __handle_irq_event_percpu+0x53/0x3e0
[   29.367916]  handle_irq_event_percpu+0x35/0x90
[   29.368247]  handle_irq_event+0x39/0x60
[   29.368632]  handle_fasteoi_irq+0xc2/0x1d0
[   29.368950]  __common_interrupt+0x7f/0x150
[   29.369254]  common_interrupt+0xb4/0xd0
[   29.369547]  </IRQ>
[   29.369708]  asm_common_interrupt+0x1e/0x40
[   29.370016] RIP: 0010:native_safe_halt+0x17/0x20
[   29.370360] Code: 07 0f 00 2d db 80 43 00 f4 5d c3 0f 1f 84 00 00 00
00 00 8b 05 c2 37 e5 01 55 48 89 e5 85 c0 7e 07 0f 00 2d bb 80 43 00 fb
f4 <5d> c3 cc cc cc cc cc cc cc 55 48 89 e5 e8 67 53 ff ff 8b 0d f9 91
[   29.371696] RSP: 0018:ffffc9000008fe90 EFLAGS: 00000246
[   29.372079] RAX: 0000000000000000 RBX: 0000000000000002
RCX: 0000000000000000
[   29.372595] RDX: 0000000000000000 RSI: ffffffff854f67a4
RDI: ffffffff85403406
[   29.373122] RBP: ffffc9000008fe90 R08: 0000000000000001
R09: 0000000000000001
[   29.373646] R10: 0000000000000000 R11: 0000000000000001
R12: ffffffff86009188
[   29.374160] R13: 0000000000000000 R14: 0000000000000000
R15: ffff888100258000
[   29.374690]  default_idle+0x9/0x10
[   29.374944]  arch_cpu_idle+0xa/0x10
[   29.375198]  default_idle_call+0x6e/0x250
[   29.375491]  do_idle+0x1f0/0x2d0
[   29.375740]  cpu_startup_entry+0x18/0x20
[   29.376034]  start_secondary+0x11f/0x160
[   29.376328]  secondary_startup_64_no_verify+0xb0/0xbb
[   29.376705] Modules linked in:
[   29.376939] Dumping ftrace buffer:
[   29.377187]    (ftrace buffer empty)
[   29.377460] CR2: 0000000000000014
[   29.377712] ---[ end trace 51a473dffb618c47 ]---
[   29.378056] RIP: 0010:via_sdc_isr+0x21f/0x410
[   29.378380] Code: ff ff e8 84 aa d0 fd 66 45 89 7e 28 66 41 f7 c4 00
10 75 56 e8 72 aa d0 fd 66 41 f7 c4 00 c0 74 10 e8 65 aa d0 fd 48 8b 43
18 <c7> 40 14 ac ff ff ff e8 55 aa d0 fd 48 89 df e8 ad fb ff ff e9 77
[   29.379714] RSP: 0018:ffffc90000118e98 EFLAGS: 00010046
[   29.380098] RAX: 0000000000000000 RBX: ffff888107d77880
RCX: 0000000000000000
[   29.380614] RDX: 0000000000000000 RSI: ffffffff835d20bb
RDI: 00000000ffffffff
[   29.381134] RBP: ffffc90000118ed8 R08: 0000000000000001
R09: 0000000000000001
[   29.381653] R10: 0000000000000000 R11: 0000000000000001
R12: 0000000000008600
[   29.382176] R13: ffff888107d779c8 R14: ffffc90009c00200
R15: 0000000000008000
[   29.382697] FS:  0000000000000000(0000) GS:ffff88817bc80000(0000)
knlGS:0000000000000000
[   29.383277] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.383697] CR2: 0000000000000014 CR3: 0000000005a2e000
CR4: 00000000000006e0
[   29.384223] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[   29.384736] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[   29.385260] Kernel panic - not syncing: Fatal exception in interrupt
[   29.385882] Dumping ftrace buffer:
[   29.386135]    (ftrace buffer empty)
[   29.386401] Kernel Offset: disabled
[   29.386656] Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/1622727200-15808-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 4f4c0813f9fd..350e67056fa6 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -857,6 +857,9 @@ static void via_sdc_data_isr(struct via_crdr_mmc_host *host, u16 intmask)
 {
 	BUG_ON(intmask == 0);
 
+	if (!host->data)
+		return;
+
 	if (intmask & VIA_CRDR_SDSTS_DT)
 		host->data->error = -ETIMEDOUT;
 	else if (intmask & (VIA_CRDR_SDSTS_RC | VIA_CRDR_SDSTS_WC))
-- 
2.30.2

