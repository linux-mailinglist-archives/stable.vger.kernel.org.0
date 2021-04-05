Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583EE354024
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbhDEJQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238841AbhDEJPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA27D613C0;
        Mon,  5 Apr 2021 09:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614146;
        bh=AfdecFrfGmOZYjAL2BqLAuvMuaEY/6RIiQT6dO47MiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyLl6XkcGo+RXlPdtlhwcJXBrlZQ/lQJYhra57WuiLZMG6BgVDjoKsLI1HF1Po45U
         tUipo9HtnGBDH72GVtGiQgpT0MwDi2j+fng+9JO6Kv3/Ak+dvkGRDBa/dp6F3BJ5zd
         VFWFC2DunFxi5Jk8YHMTTXJMJKfWgkKpXOV7+2eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 099/152] pinctrl: microchip-sgpio: Fix wrong register offset for IRQ trigger
Date:   Mon,  5 Apr 2021 10:54:08 +0200
Message-Id: <20210405085037.463854199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Povlsen <lars.povlsen@microchip.com>

commit 5d5f2919273d1089a00556cad68e7f462f3dd2eb upstream.

This patch fixes using a wrong register offset when configuring an IRQ
trigger type.

Fixes: be2dc859abd4 ("pinctrl: pinctrl-microchip-sgpio: Add irq support (for sparx5)")
Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20210203123825.611576-1-lars.povlsen@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -572,7 +572,7 @@ static void microchip_sgpio_irq_settype(
 	/* Type value spread over 2 registers sets: low, high bit */
 	sgpio_clrsetbits(bank->priv, REG_INT_TRIGGER, addr.bit,
 			 BIT(addr.port), (!!(type & 0x1)) << addr.port);
-	sgpio_clrsetbits(bank->priv, REG_INT_TRIGGER + SGPIO_MAX_BITS, addr.bit,
+	sgpio_clrsetbits(bank->priv, REG_INT_TRIGGER, SGPIO_MAX_BITS + addr.bit,
 			 BIT(addr.port), (!!(type & 0x2)) << addr.port);
 
 	if (type == SGPIO_INT_TRG_LEVEL)


