Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B940DEFE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbhIPQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240612AbhIPQFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29DD061241;
        Thu, 16 Sep 2021 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808262;
        bh=niG2Lt1Ingh5RIC5tdVdvtYyFU2QIjLuQ49vE2s/LNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFsq7U0MpFBljMfq1kwkcv2pHWNT1tO+sAoHWKWFm0v3GIYrFKYet6UByL5oFgDOl
         wiMcpgH9olPy6N2931fRuZ8FGQjNV7Jy6vMKDqYnp6cxB1/xgN2p5uRV+fs1Y6JZI5
         1e9yBIUFmQvY3klXcg1kAsM+EnBLbrk4dRLiUAfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 5.10 021/306] pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
Date:   Thu, 16 Sep 2021 17:56:06 +0200
Message-Id: <20210916155754.661055443@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 1b73e588f47397dee6e4bdfd953e0306c60b5fe5 upstream.

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
Link: https://lore.kernel.org/r/20210725180830.250218-1-maz@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-stmfx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -566,7 +566,7 @@ static irqreturn_t stmfx_pinctrl_irq_thr
 	u8 pending[NR_GPIO_REGS];
 	u8 src[NR_GPIO_REGS] = {0, 0, 0};
 	unsigned long n, status;
-	int ret;
+	int i, ret;
 
 	ret = regmap_bulk_read(pctl->stmfx->map, STMFX_REG_IRQ_GPI_PENDING,
 			       &pending, NR_GPIO_REGS);
@@ -576,7 +576,9 @@ static irqreturn_t stmfx_pinctrl_irq_thr
 	regmap_bulk_write(pctl->stmfx->map, STMFX_REG_IRQ_GPI_SRC,
 			  src, NR_GPIO_REGS);
 
-	status = *(unsigned long *)pending;
+	BUILD_BUG_ON(NR_GPIO_REGS > sizeof(status));
+	for (i = 0, status = 0; i < NR_GPIO_REGS; i++)
+		status |= (unsigned long)pending[i] << (i * 8);
 	for_each_set_bit(n, &status, gc->ngpio) {
 		handle_nested_irq(irq_find_mapping(gc->irq.domain, n));
 		stmfx_pinctrl_irq_toggle_trigger(pctl, n);


