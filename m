Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1953A644034
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiLFJuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiLFJuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACDC2BC0;
        Tue,  6 Dec 2022 01:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2952C615FF;
        Tue,  6 Dec 2022 09:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C23BC4347C;
        Tue,  6 Dec 2022 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320170;
        bh=p4GOASrrw7BbRUax2gtf0OMf5bM0UdngPhO3xqzted4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN5gwgehU88/7cx7s7vbbxFWacWzR7oByy4dspn7/PgG9eEnI/Wz0lGwihJYoPehW
         x/wi4aACuRivn3SZINo66fTukrtW3ArtYrkH+WQvXPODV0G40QnZbr0y8x+i/+y+YU
         kANIMvOFiX5IsKNlhxfpO1liaC7q8acO0wjGDkwEItGUDKx/z+evD0UhZw0R3iKY0T
         t/lh0ENRsZLtCOUIAdYIzWqUIoDJ67bwj73StcWlyZAT/EYT2WoWbc6/QO8b85qLhd
         lKXZIsBvwUqsjXM3szwCIoKyLPRYYwLQy7w4OY5ZBphEp1qu8Yby0PtTO263kNXSK/
         shaOhrcBNZRZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, sean.wang@kernel.org,
        linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 05/13] pinctrl: meditatek: Startup with the IRQs disabled
Date:   Tue,  6 Dec 2022 04:49:08 -0500
Message-Id: <20221206094916.987259-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094916.987259-1-sashal@kernel.org>
References: <20221206094916.987259-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 11780e37565db4dd064d3243ca68f755c13f65b4 ]

If the system is restarted via kexec(), the peripherals do not start
with a known state.

If the previous system had enabled an IRQs we will receive unexected
IRQs that can lock the system.

[   28.109251] watchdog: BUG: soft lockup - CPU#0 stuck for 26s!
[swapper/0:0]
[   28.109263] Modules linked in:
[   28.109273] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.15.79-14458-g4b9edf7b1ac6 #1 9f2e76613148af94acccd64c609a552fb4b4354b
[   28.109284] Hardware name: Google Elm (DT)
[   28.109290] pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS
		BTYPE=--)
[   28.109298] pc : __do_softirq+0xa0/0x388
[   28.109309] lr : __do_softirq+0x70/0x388
[   28.109316] sp : ffffffc008003ee0
[   28.109321] x29: ffffffc008003f00 x28: 000000000000000a x27:
0000000000000080
[   28.109334] x26: 0000000000000001 x25: ffffffefa7b350c0 x24:
ffffffefa7b47480
[   28.109346] x23: ffffffefa7b3d000 x22: 0000000000000000 x21:
ffffffefa7b0fa40
[   28.109358] x20: ffffffefa7b005b0 x19: ffffffefa7b47480 x18:
0000000000065b6b
[   28.109370] x17: ffffffefa749c8b0 x16: 000000000000018c x15:
00000000000001b8
[   28.109382] x14: 00000000000d3b6b x13: 0000000000000006 x12:
0000000000057e91
[   28.109394] x11: 0000000000000000 x10: 0000000000000000 x9 :
ffffffefa7b47480
[   28.109406] x8 : 00000000000000e0 x7 : 000000000f424000 x6 :
0000000000000000
[   28.109418] x5 : ffffffefa7dfaca0 x4 : ffffffefa7dfadf0 x3 :
000000000000000f
[   28.109429] x2 : 0000000000000000 x1 : 0000000000000100 x0 :
0000000001ac65c5
[   28.109441] Call trace:
[   28.109447]  __do_softirq+0xa0/0x388
[   28.109454]  irq_exit+0xc0/0xe0
[   28.109464]  handle_domain_irq+0x68/0x90
[   28.109473]  gic_handle_irq+0xac/0xf0
[   28.109480]  call_on_irq_stack+0x28/0x50
[   28.109488]  do_interrupt_handler+0x44/0x58
[   28.109496]  el1_interrupt+0x30/0x58
[   28.109506]  el1h_64_irq_handler+0x18/0x24
[   28.109512]  el1h_64_irq+0x7c/0x80
[   28.109519]  arch_local_irq_enable+0xc/0x18
[   28.109529]  default_idle_call+0x40/0x140
[   28.109539]  do_idle+0x108/0x290
[   28.109547]  cpu_startup_entry+0x2c/0x30
[   28.109554]  rest_init+0xe8/0xf8
[   28.109562]  arch_call_rest_init+0x18/0x24
[   28.109571]  start_kernel+0x338/0x42c
[   28.109578]  __primary_switched+0xbc/0xc4
[   28.109588] Kernel panic - not syncing: softlockup: hung tasks

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20221122-mtk-pinctrl-v1-1-bedf5655a3d2@chromium.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index f7b54a551764..c24583bffa99 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -287,12 +287,15 @@ static struct irq_chip mtk_eint_irq_chip = {
 
 static unsigned int mtk_eint_hw_init(struct mtk_eint *eint)
 {
-	void __iomem *reg = eint->base + eint->regs->dom_en;
+	void __iomem *dom_en = eint->base + eint->regs->dom_en;
+	void __iomem *mask_set = eint->base + eint->regs->mask_set;
 	unsigned int i;
 
 	for (i = 0; i < eint->hw->ap_num; i += 32) {
-		writel(0xffffffff, reg);
-		reg += 4;
+		writel(0xffffffff, dom_en);
+		writel(0xffffffff, mask_set);
+		dom_en += 4;
+		mask_set += 4;
 	}
 
 	return 0;
-- 
2.35.1

