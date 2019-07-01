Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3745205B3
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEPLjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbfEPLjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:39:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0AA920881;
        Thu, 16 May 2019 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006786;
        bh=tBCzZByeN4C91PgXW1UqMiCBhoEnLvF0UumL/e18Rc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oNB/ukrGnBywjVn/X2wQN+8NEDG9YU6SYAaVu+ZZO4IlLrCbZH0mgbn4phR/v1d9
         y0wJexXmb2Hc+zX1ox5wH+FK9h/Le42yDD50LeZZ4Xq7ruXb8lJ342g2TdJZ2gkm3Z
         bnC5M9hYplEhdR2ipzodslYjID3VYluqCz9T1roA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 10/34] clk: sunxi-ng: nkmp: Avoid GENMASK(-1, 0)
Date:   Thu, 16 May 2019 07:39:07 -0400
Message-Id: <20190516113932.8348-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 2abc330c514fe56c570bb1a6318b054b06a4f72e ]

Sometimes one of the nkmp factors is unused. This means that one of the
factors shift and width values are set to 0. Current nkmp clock code
generates a mask for each factor with GENMASK(width + shift - 1, shift).
For unused factor this translates to GENMASK(-1, 0). This code is
further expanded by C preprocessor to final version:
(((~0UL) - (1UL << (0)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (-1))))
or a bit simplified:
(~0UL & (~0UL >> BITS_PER_LONG))

It turns out that result of the second part (~0UL >> BITS_PER_LONG) is
actually undefined by C standard, which clearly specifies:

"If the value of the right operand is negative or is greater than or
equal to the width of the promoted left operand, the behavior is
undefined."

Additionally, compiling kernel with aarch64-linux-gnu-gcc 8.3.0 gave
different results whether literals or variables with same values as
literals were used. GENMASK with literals -1 and 0 gives zero and with
variables gives 0xFFFFFFFFFFFFFFF (~0UL). Because nkmp driver uses
GENMASK with variables as parameter, expression calculates mask as ~0UL
instead of 0. This has further consequences that LSB in register is
always set to 1 (1 is neutral value for a factor and shift is 0).

For example, H6 pll-de clock is set to 600 MHz by sun4i-drm driver, but
due to this bug ends up being 300 MHz. Additionally, 300 MHz seems to be
too low because following warning can be found in dmesg:

[    1.752763] WARNING: CPU: 2 PID: 41 at drivers/clk/sunxi-ng/ccu_common.c:41 ccu_helper_wait_for_lock.part.0+0x6c/0x90
[    1.763378] Modules linked in:
[    1.766441] CPU: 2 PID: 41 Comm: kworker/2:1 Not tainted 5.1.0-rc2-next-20190401 #138
[    1.774269] Hardware name: Pine H64 (DT)
[    1.778200] Workqueue: events deferred_probe_work_func
[    1.783341] pstate: 40000005 (nZcv daif -PAN -UAO)
[    1.788135] pc : ccu_helper_wait_for_lock.part.0+0x6c/0x90
[    1.793623] lr : ccu_helper_wait_for_lock.part.0+0x48/0x90
[    1.799107] sp : ffff000010f93840
[    1.802422] x29: ffff000010f93840 x28: 0000000000000000
[    1.807735] x27: ffff800073ce9d80 x26: ffff000010afd1b8
[    1.813049] x25: ffffffffffffffff x24: 00000000ffffffff
[    1.818362] x23: 0000000000000001 x22: ffff000010abd5c8
[    1.823675] x21: 0000000010000000 x20: 00000000685f367e
[    1.828987] x19: 0000000000001801 x18: 0000000000000001
[    1.834300] x17: 0000000000000001 x16: 0000000000000000
[    1.839613] x15: 0000000000000000 x14: ffff000010789858
[    1.844926] x13: 0000000000000000 x12: 0000000000000001
[    1.850239] x11: 0000000000000000 x10: 0000000000000970
[    1.855551] x9 : ffff000010f936c0 x8 : ffff800074cec0d0
[    1.860864] x7 : 0000800067117000 x6 : 0000000115c30b41
[    1.866177] x5 : 00ffffffffffffff x4 : 002c959300bfe500
[    1.871490] x3 : 0000000000000018 x2 : 0000000029aaaaab
[    1.876802] x1 : 00000000000002e6 x0 : 00000000686072bc
[    1.882114] Call trace:
[    1.884565]  ccu_helper_wait_for_lock.part.0+0x6c/0x90
[    1.889705]  ccu_helper_wait_for_lock+0x10/0x20
[    1.894236]  ccu_nkmp_set_rate+0x244/0x2a8
[    1.898334]  clk_change_rate+0x144/0x290
[    1.902258]  clk_core_set_rate_nolock+0x180/0x1b8
[    1.906963]  clk_set_rate+0x34/0xa0
[    1.910455]  sun8i_mixer_bind+0x484/0x558
[    1.914466]  component_bind_all+0x10c/0x230
[    1.918651]  sun4i_drv_bind+0xc4/0x1a0
[    1.922401]  try_to_bring_up_master+0x164/0x1c0
[    1.926932]  __component_add+0xa0/0x168
[    1.930769]  component_add+0x10/0x18
[    1.934346]  sun8i_dw_hdmi_probe+0x18/0x20
[    1.938443]  platform_drv_probe+0x50/0xa0
[    1.942455]  really_probe+0xcc/0x280
[    1.946032]  driver_probe_device+0x54/0xe8
[    1.950130]  __device_attach_driver+0x80/0xb8
[    1.954488]  bus_for_each_drv+0x78/0xc8
[    1.958326]  __device_attach+0xd4/0x130
[    1.962163]  device_initial_probe+0x10/0x18
[    1.966348]  bus_probe_device+0x90/0x98
[    1.970185]  deferred_probe_work_func+0x6c/0xa0
[    1.974720]  process_one_work+0x1e0/0x320
[    1.978732]  worker_thread+0x228/0x428
[    1.982484]  kthread+0x120/0x128
[    1.985714]  ret_from_fork+0x10/0x18
[    1.989290] ---[ end trace 9babd42e1ca4b84f ]---

This commit solves the issue by first checking value of the factor
width. If it is equal to 0 (unused factor), mask is set to 0, otherwise
GENMASK() macro is used as before.

Fixes: d897ef56faf9 ("clk: sunxi-ng: Mask nkmp factors when setting register")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_nkmp.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_nkmp.c b/drivers/clk/sunxi-ng/ccu_nkmp.c
index 9b49adb20d07c..69dfc6de1c4e6 100644
--- a/drivers/clk/sunxi-ng/ccu_nkmp.c
+++ b/drivers/clk/sunxi-ng/ccu_nkmp.c
@@ -167,7 +167,7 @@ static int ccu_nkmp_set_rate(struct clk_hw *hw, unsigned long rate,
 			   unsigned long parent_rate)
 {
 	struct ccu_nkmp *nkmp = hw_to_ccu_nkmp(hw);
-	u32 n_mask, k_mask, m_mask, p_mask;
+	u32 n_mask = 0, k_mask = 0, m_mask = 0, p_mask = 0;
 	struct _ccu_nkmp _nkmp;
 	unsigned long flags;
 	u32 reg;
@@ -186,10 +186,18 @@ static int ccu_nkmp_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	ccu_nkmp_find_best(parent_rate, rate, &_nkmp);
 
-	n_mask = GENMASK(nkmp->n.width + nkmp->n.shift - 1, nkmp->n.shift);
-	k_mask = GENMASK(nkmp->k.width + nkmp->k.shift - 1, nkmp->k.shift);
-	m_mask = GENMASK(nkmp->m.width + nkmp->m.shift - 1, nkmp->m.shift);
-	p_mask = GENMASK(nkmp->p.width + nkmp->p.shift - 1, nkmp->p.shift);
+	if (nkmp->n.width)
+		n_mask = GENMASK(nkmp->n.width + nkmp->n.shift - 1,
+				 nkmp->n.shift);
+	if (nkmp->k.width)
+		k_mask = GENMASK(nkmp->k.width + nkmp->k.shift - 1,
+				 nkmp->k.shift);
+	if (nkmp->m.width)
+		m_mask = GENMASK(nkmp->m.width + nkmp->m.shift - 1,
+				 nkmp->m.shift);
+	if (nkmp->p.width)
+		p_mask = GENMASK(nkmp->p.width + nkmp->p.shift - 1,
+				 nkmp->p.shift);
 
 	spin_lock_irqsave(nkmp->common.lock, flags);
 
-- 
2.20.1

