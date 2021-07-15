Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AC73CAA62
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242002AbhGOTNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244048AbhGOTKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 282EE613D1;
        Thu, 15 Jul 2021 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376061;
        bh=+DqxFN9ITQT8/uYsw9hTN5wttBWimqS6cfsrA3DFqjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIZ8WWXHFL7iR2/8GJnWUpKh7tWyAD7NVuaTKf78QwHq81DlxYo+L/9l7qK8Mihn9
         bABBDlwbJX/XrpTYlNojfx0gF5iiXxfFuHvZm3bG4rMs7ngOEk429oiK9oi1JLw1f7
         i4A6FS78w3VepJEAZBvQNMNJmaJglqlgQT7v7pjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radim Pavlik <radim.pavlik@tbs-biometrics.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/266] pinctrl: mcp23s08: fix race condition in irq handler
Date:   Thu, 15 Jul 2021 20:37:08 +0200
Message-Id: <20210715182627.048814039@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



