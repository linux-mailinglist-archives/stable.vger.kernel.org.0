Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D336B6C55A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389327AbfGRDFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389909AbfGRDFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:17 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8E1204EC;
        Thu, 18 Jul 2019 03:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419116;
        bh=rhIzuUbSYLla75JR1cnW0oo8z3Km6XhCufKughoj4hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRY7GIOlvk/tyl7/V+LE7zvDKyq03cLnnDSvzXJ2iCwF/8JmGA9o0mcx0xNjN3WG8
         AhVVBTCS93Ujf5fOe7clTLVV4XzXsQbAVztQzxmaqNzBPC4EzXh6VpWhLVhMIAO5Cq
         V/02whYXp/8nqOofLM8p7aaTc+2GhFXiUVX/ZKMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Sean Wang <sean.wang@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 35/54] pinctrl: mediatek: Ignore interrupts that are wake only during resume
Date:   Thu, 18 Jul 2019 12:01:30 +0900
Message-Id: <20190718030056.020893019@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35594bc7cecf3a78504b590e350570e8f4d7779e ]

Before suspending, mtk-eint would set the interrupt mask to the
one in wake_mask. However, some of these interrupts may not have a
corresponding interrupt handler, or the interrupt may be disabled.

On resume, the eint irq handler would trigger nevertheless,
and irq/pm.c:irq_pm_check_wakeup would be called, which would
try to call irq_disable. However, if the interrupt is not enabled
(irqd_irq_disabled(&desc->irq_data) is true), the call does nothing,
and the interrupt is left enabled in the eint driver.

Especially for level-sensitive interrupts, this will lead to an
interrupt storm on resume.

If we detect that an interrupt is only in wake_mask, but not in
cur_mask, we can just mask it out immediately (as mtk_eint_resume
would do anyway at a later stage in the resume sequence, when
restoring cur_mask).

Fixes: bf22ff45bed6 ("genirq: Avoid unnecessary low level irq function calls")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Acked-by: Sean Wang <sean.wang@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index f464f8cd274b..737385e86beb 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -318,7 +318,7 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct mtk_eint *eint = irq_desc_get_handler_data(desc);
 	unsigned int status, eint_num;
-	int offset, index, virq;
+	int offset, mask_offset, index, virq;
 	void __iomem *reg =  mtk_eint_get_offset(eint, 0, eint->regs->stat);
 	int dual_edge, start_level, curr_level;
 
@@ -328,10 +328,24 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 		status = readl(reg);
 		while (status) {
 			offset = __ffs(status);
+			mask_offset = eint_num >> 5;
 			index = eint_num + offset;
 			virq = irq_find_mapping(eint->domain, index);
 			status &= ~BIT(offset);
 
+			/*
+			 * If we get an interrupt on pin that was only required
+			 * for wake (but no real interrupt requested), mask the
+			 * interrupt (as would mtk_eint_resume do anyway later
+			 * in the resume sequence).
+			 */
+			if (eint->wake_mask[mask_offset] & BIT(offset) &&
+			    !(eint->cur_mask[mask_offset] & BIT(offset))) {
+				writel_relaxed(BIT(offset), reg -
+					eint->regs->stat +
+					eint->regs->mask_set);
+			}
+
 			dual_edge = eint->dual_edge[index];
 			if (dual_edge) {
 				/*
-- 
2.20.1



