Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799043BD17A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbhGFLjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237123AbhGFLf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C501D61EAE;
        Tue,  6 Jul 2021 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570738;
        bh=FlMvHtQsuOPJncd+fzNsujxC2o2xRhcZN14NdAJ0cRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFR4/AXsHN2sLrjv8KjIn55SXuGwODSsXvl4qzxEyw0iwI3SQ31PszhMg5e4YbcK1
         yVWGaIlh4TuumIlwNTq7kb+sbXuFPaFEXwfqi36z0cQNCCanh4QHX5YFMrk00EUR/J
         VdMaznvlX3WfyeFYThJo157AALITSAk3+tgNDX4uri6wzszlvfl6SFQ4FbDQdm6Upe
         b5e5NLDS06htiyV/bZNY0Ye0P/vfHZ7ld9o0zIcCqyXBOjuk/H2AEkB6fP0fkSRmfp
         kW3Ms55PMydbWUSqJNbfXsL5zWNAaMk0mD4q/AQj6JGe4uWLKw3+C5MWBkpg5G9PvB
         ofiugkPbq5WmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radim Pavlik <radim.pavlik@tbs-biometrics.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/74] pinctrl: mcp23s08: fix race condition in irq handler
Date:   Tue,  6 Jul 2021 07:24:16 -0400
Message-Id: <20210706112502.2064236-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radim Pavlik <radim.pavlik@tbs-biometrics.com>

[ Upstream commit 897120d41e7afd9da435cb00041a142aeeb53c07 ]

Checking value of MCP_INTF in mcp23s08_irq suggests that the handler may be
called even when there is no interrupt pending.

But the actual interrupt could happened between reading MCP_INTF and MCP_GPIO.
In this situation we got nothing from MCP_INTF, but the event gets acknowledged
on the expander by reading MCP_GPIO. This leads to losing events.

Fix the problem by not reading any register until we see something in MCP_INTF.

The error was reproduced and fix tested on MCP23017.

Signed-off-by: Radim Pavlik <radim.pavlik@tbs-biometrics.com>
Link: https://lore.kernel.org/r/AM7PR06MB6769E1183F68DEBB252F665ABA3E9@AM7PR06MB6769.eurprd06.prod.outlook.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index d8bcbefcba89..9d5e2d9b6b93 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -459,6 +459,11 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 	if (mcp_read(mcp, MCP_INTF, &intf))
 		goto unlock;
 
+	if (intf == 0) {
+		/* There is no interrupt pending */
+		return IRQ_HANDLED;
+	}
+
 	if (mcp_read(mcp, MCP_INTCAP, &intcap))
 		goto unlock;
 
@@ -476,11 +481,6 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 	mcp->cached_gpio = gpio;
 	mutex_unlock(&mcp->lock);
 
-	if (intf == 0) {
-		/* There is no interrupt pending */
-		return IRQ_HANDLED;
-	}
-
 	dev_dbg(mcp->chip.parent,
 		"intcap 0x%04X intf 0x%04X gpio_orig 0x%04X gpio 0x%04X\n",
 		intcap, intf, gpio_orig, gpio);
-- 
2.30.2

