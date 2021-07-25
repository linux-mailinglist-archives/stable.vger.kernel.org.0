Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0373D4F63
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGYR2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 13:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGYR2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Jul 2021 13:28:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E60FD60E78;
        Sun, 25 Jul 2021 18:08:52 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m7iYV-000t8G-8w; Sun, 25 Jul 2021 19:08:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH] pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
Date:   Sun, 25 Jul 2021 19:08:30 +0100
Message-Id: <20210725180830.250218-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org, amelie.delaunay@foss.st.com, linus.walleij@linaro.org, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Casting a small array of u8 to an unsigned long is *never* OK:

- it does funny thing when the array size is less than that of a long,
  as it accesses random places in the stack
- it makes everything even more fun with a BE kernel

Fix this by building the unsigned long used as a bitmap byte by byte,
in a way that works across endianess and has no undefined behaviours.

An extra BUILD_BUG_ON() catches the unlikely case where the array
would be larger than a single unsigned long.

Fixes: 1490d9f841b1 ("pinctrl: Add STMFX GPIO expander Pinctrl/GPIO driver")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
---
 drivers/pinctrl/pinctrl-stmfx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-stmfx.c b/drivers/pinctrl/pinctrl-stmfx.c
index 008c83107a3c..5fa2488fae87 100644
--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -566,7 +566,7 @@ static irqreturn_t stmfx_pinctrl_irq_thread_fn(int irq, void *dev_id)
 	u8 pending[NR_GPIO_REGS];
 	u8 src[NR_GPIO_REGS] = {0, 0, 0};
 	unsigned long n, status;
-	int ret;
+	int i, ret;
 
 	ret = regmap_bulk_read(pctl->stmfx->map, STMFX_REG_IRQ_GPI_PENDING,
 			       &pending, NR_GPIO_REGS);
@@ -576,7 +576,9 @@ static irqreturn_t stmfx_pinctrl_irq_thread_fn(int irq, void *dev_id)
 	regmap_bulk_write(pctl->stmfx->map, STMFX_REG_IRQ_GPI_SRC,
 			  src, NR_GPIO_REGS);
 
-	status = *(unsigned long *)pending;
+	BUILD_BUG_ON(NR_GPIO_REGS > sizeof(status));
+	for (i = 0, status = 0; i < NR_GPIO_REGS; i++)
+		status |= (unsigned long)pending[i] << (i * 8);
 	for_each_set_bit(n, &status, gc->ngpio) {
 		handle_nested_irq(irq_find_mapping(gc->irq.domain, n));
 		stmfx_pinctrl_irq_toggle_trigger(pctl, n);
-- 
2.30.2

