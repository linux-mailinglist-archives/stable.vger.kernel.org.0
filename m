Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC82839F8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgJEPaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbgJEP37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6B220637;
        Mon,  5 Oct 2020 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911799;
        bh=P1MWB1b/pucqTbLhKRtoXsiP2So2yqBgqPWth5T/6Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d79vDw2w/0VsTC/LqGpy24xPbhM1OWOEaMLpmhhS6vr8Vgvu9vpHx8/QsGDa2TQKP
         L5bKCIou2VVaV1HjBbNRJ8uSfUgiu70yi6+77oXP8lPWBtFOe0Jp2X6q/01P7YIGgJ
         +5i2605mnzzrOT+hV/8cUTRnNJw47TCgThUHFI+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/57] gpio/aspeed-sgpio: dont enable all interrupts by default
Date:   Mon,  5 Oct 2020 17:26:53 +0200
Message-Id: <20201005142111.783652053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit bf0d394e885015941ed2d5724c0a6ed8d42dd95e ]

Currently, the IRQ setup for the SGPIO driver enables all interrupts in
dual-edge trigger mode. Since the default handler is handle_bad_irq, any
state change on input GPIOs will trigger bad IRQ warnings.

This change applies sensible IRQ defaults: single-edge trigger, and all
IRQs disabled.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Fixes: 7db47faae79b ("gpio: aspeed: Add SGPIO driver")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Acked-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/sgpio-aspeed.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/sgpio-aspeed.c b/drivers/gpio/sgpio-aspeed.c
index 7cd86d5e8dc90..3a5dfb8ded1fb 100644
--- a/drivers/gpio/sgpio-aspeed.c
+++ b/drivers/gpio/sgpio-aspeed.c
@@ -452,17 +452,15 @@ static int aspeed_sgpio_setup_irqs(struct aspeed_sgpio *gpio,
 	irq->parents = &gpio->irq;
 	irq->num_parents = 1;
 
-	/* set IRQ settings and Enable Interrupt */
+	/* Apply default IRQ settings */
 	for (i = 0; i < ARRAY_SIZE(aspeed_sgpio_banks); i++) {
 		bank = &aspeed_sgpio_banks[i];
 		/* set falling or level-low irq */
 		iowrite32(0x00000000, bank_reg(gpio, bank, reg_irq_type0));
 		/* trigger type is edge */
 		iowrite32(0x00000000, bank_reg(gpio, bank, reg_irq_type1));
-		/* dual edge trigger mode. */
-		iowrite32(0xffffffff, bank_reg(gpio, bank, reg_irq_type2));
-		/* enable irq */
-		iowrite32(0xffffffff, bank_reg(gpio, bank, reg_irq_enable));
+		/* single edge trigger */
+		iowrite32(0x00000000, bank_reg(gpio, bank, reg_irq_type2));
 	}
 
 	return 0;
-- 
2.25.1



