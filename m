Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9A41211D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356883AbhITSCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356433AbhITR7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA82613AD;
        Mon, 20 Sep 2021 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158141;
        bh=Dsw9xe01S1S97w7FMJ4EIPuomsucu92qTCqrP671lcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmngW9CEOoNQgEK3/wnyAoK9BtVCKkk5+ZEIeuM0ZxJJu3M+bcgtR1hqJgEsqI88X
         QRwN1kis74B4W2FabSaRjvFG6WB9cIZssLnbVZ2tGKGlQv1G+mIAKhTMc0gB9q2bMX
         phDXstoG12BYNcFWS19HGc0H2vDUU0x5zzYF+feE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 5.4 012/260] pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
Date:   Mon, 20 Sep 2021 18:40:30 +0200
Message-Id: <20210920163931.539678972@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -540,7 +540,7 @@ static irqreturn_t stmfx_pinctrl_irq_thr
 	u8 pending[NR_GPIO_REGS];
 	u8 src[NR_GPIO_REGS] = {0, 0, 0};
 	unsigned long n, status;
-	int ret;
+	int i, ret;
 
 	ret = regmap_bulk_read(pctl->stmfx->map, STMFX_REG_IRQ_GPI_PENDING,
 			       &pending, NR_GPIO_REGS);
@@ -550,7 +550,9 @@ static irqreturn_t stmfx_pinctrl_irq_thr
 	regmap_bulk_write(pctl->stmfx->map, STMFX_REG_IRQ_GPI_SRC,
 			  src, NR_GPIO_REGS);
 
-	status = *(unsigned long *)pending;
+	BUILD_BUG_ON(NR_GPIO_REGS > sizeof(status));
+	for (i = 0, status = 0; i < NR_GPIO_REGS; i++)
+		status |= (unsigned long)pending[i] << (i * 8);
 	for_each_set_bit(n, &status, gc->ngpio) {
 		handle_nested_irq(irq_find_mapping(gc->irq.domain, n));
 		stmfx_pinctrl_irq_toggle_trigger(pctl, n);


