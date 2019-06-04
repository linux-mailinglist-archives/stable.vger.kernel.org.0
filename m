Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939BE34D8D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfFDQd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 12:33:59 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:47148 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfFDQd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 12:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1559666037; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=j0HsjNCBgw6fb89AS0Z7APClR+xnsmHO6MK4li8L+Yg=;
        b=dnheEqEuK7O6vdqyl/0cBNMRU4cw17F0bPm4lIdzfwqPlS/zyW9SIf2s9PnClisWI0PQNA
        LnUy2qiihxP4YCHu9pkxA8k2GK12dcHGeBUprchnxPOUX3YDqrgfNbqsBZYuTiAk+KH1Ft
        oHxUNTjM+ks36004qmTWCR0YqqD0oRo=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] MIPS: lb60: Fix pin mappings
Date:   Tue,  4 Jun 2019 18:33:11 +0200
Message-Id: <20190604163311.19059-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pin mappings introduced in commit 636f8ba67fb6
("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
are completely wrong. The pinctrl driver name is incorrect, and the
function and group fields are swapped.

Fixes: 636f8ba67fb6 ("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/jz4740/board-qi_lb60.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 071e9d94eea7..daed44ee116d 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -466,27 +466,27 @@ static unsigned long pin_cfg_bias_disable[] = {
 static struct pinctrl_map pin_map[] __initdata = {
 	/* NAND pin configuration */
 	PIN_MAP_MUX_GROUP_DEFAULT("jz4740-nand",
-			"10010000.jz4740-pinctrl", "nand", "nand-cs1"),
+			"10010000.pin-controller", "nand-cs1", "nand"),
 
 	/* fbdev pin configuration */
 	PIN_MAP_MUX_GROUP("jz4740-fb", PINCTRL_STATE_DEFAULT,
-			"10010000.jz4740-pinctrl", "lcd", "lcd-8bit"),
+			"10010000.pin-controller", "lcd-8bit", "lcd"),
 	PIN_MAP_MUX_GROUP("jz4740-fb", PINCTRL_STATE_SLEEP,
-			"10010000.jz4740-pinctrl", "lcd", "lcd-no-pins"),
+			"10010000.pin-controller", "lcd-no-pins", "lcd"),
 
 	/* MMC pin configuration */
 	PIN_MAP_MUX_GROUP_DEFAULT("jz4740-mmc.0",
-			"10010000.jz4740-pinctrl", "mmc", "mmc-1bit"),
+			"10010000.pin-controller", "mmc-1bit", "mmc"),
 	PIN_MAP_MUX_GROUP_DEFAULT("jz4740-mmc.0",
-			"10010000.jz4740-pinctrl", "mmc", "mmc-4bit"),
+			"10010000.pin-controller", "mmc-4bit", "mmc"),
 	PIN_MAP_CONFIGS_PIN_DEFAULT("jz4740-mmc.0",
-			"10010000.jz4740-pinctrl", "PD0", pin_cfg_bias_disable),
+			"10010000.pin-controller", "PD0", pin_cfg_bias_disable),
 	PIN_MAP_CONFIGS_PIN_DEFAULT("jz4740-mmc.0",
-			"10010000.jz4740-pinctrl", "PD2", pin_cfg_bias_disable),
+			"10010000.pin-controller", "PD2", pin_cfg_bias_disable),
 
 	/* PWM pin configuration */
 	PIN_MAP_MUX_GROUP_DEFAULT("jz4740-pwm",
-			"10010000.jz4740-pinctrl", "pwm4", "pwm4"),
+			"10010000.pin-controller", "pwm4", "pwm4"),
 };
 
 
-- 
2.21.0.593.g511ec345e18

