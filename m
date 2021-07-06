Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BED3BCC63
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhGFLS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhGFLSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1482761C4E;
        Tue,  6 Jul 2021 11:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570157;
        bh=+DqxFN9ITQT8/uYsw9hTN5wttBWimqS6cfsrA3DFqjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERBabhvHAm1lVbiX1VwYMDLzPIK9PAwBU0RE1kgEKTxtmtc6KLce7NIhL95lYMvv5
         lznFegRdZrdvNEOAn1vIeRiVJeQSH49tt8u6XXcOerPGbLEvBqrWlYNyQTj5pbiOkb
         g3T3oAGSuA7CEK+LLKdv8Mt4C3quxD/L7I/s6H6WCiUFq893HgNWB0Y3XPfr/xLuaF
         4OnmkbJ4991BU8gbFZci3M1YeY3oAhOjv1xgbBQ/113I6BxxS6vV4y87u63cgelQZV
         6leLEx1j1TSGZigCrBG+XhXDye7kulCNsjeDBHnAAkgLSJEqplc4eNIEWeJNOf1EEm
         KoTO2DUREW6PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radim Pavlik <radim.pavlik@tbs-biometrics.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 079/189] pinctrl: mcp23s08: fix race condition in irq handler
Date:   Tue,  6 Jul 2021 07:12:19 -0400
Message-Id: <20210706111409.2058071-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index ce2d8014b7e0..799d596a1a4b 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -351,6 +351,11 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
 	if (mcp_read(mcp, MCP_INTF, &intf))
 		goto unlock;
 
+	if (intf == 0) {
+		/* There is no interrupt pending */
+		return IRQ_HANDLED;
+	}
+
 	if (mcp_read(mcp, MCP_INTCAP, &intcap))
 		goto unlock;
 
@@ -368,11 +373,6 @@ static irqreturn_t mcp23s08_irq(int irq, void *data)
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

