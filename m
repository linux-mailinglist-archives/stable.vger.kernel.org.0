Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8874876D66
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbfGZPd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389652AbfGZPd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:33:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925D6205F4;
        Fri, 26 Jul 2019 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155208;
        bh=69rKnTvgyN+qeWnLwOG5ZuEexG9hRf9rbl27ZPHs/BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb4XBR9J52ePmw2aUNJXlPdJhsC6LDOjb1l2cfgX1eTtg7P3WFQoprkcR3+dwJt8r
         qe5PeX6q8TUDji7Q8yntSZjlwQZG5Vt8yh411fyPC6oVTP4/t2+MSlx7p+BRLgatnY
         B7ZqaZzfZjR/eaPbEEAGGYuI/47DtkCJmO6EdwKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, od@zcrc.me,
        linux-mips@vger.kernel.org
Subject: [PATCH 4.19 39/50] MIPS: lb60: Fix pin mappings
Date:   Fri, 26 Jul 2019 17:25:14 +0200
Message-Id: <20190726152304.692128452@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 1323c3b72a987de57141cabc44bf9cd83656bc70 upstream.

The pin mappings introduced in commit 636f8ba67fb6
("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
are completely wrong. The pinctrl driver name is incorrect, and the
function and group fields are swapped.

Fixes: 636f8ba67fb6 ("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: od@zcrc.me
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/jz4740/board-qi_lb60.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -471,27 +471,27 @@ static unsigned long pin_cfg_bias_disabl
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
 
 


