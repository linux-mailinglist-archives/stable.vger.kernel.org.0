Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAED53CA852
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhGOTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242334AbhGOS7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6CD5613EE;
        Thu, 15 Jul 2021 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375382;
        bh=+DqxFN9ITQT8/uYsw9hTN5wttBWimqS6cfsrA3DFqjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymZiBQLD0g+tKfTkEvTtG5qqadED7kVCspexPDNJtr6JIW7D9x4/KA7c9+2tzbChf
         yXx0c3j7ukwwUao54STzAvpHg0xjddkYF7khyDjEkl0RsOIA45hDivl7UrCsumEipv
         nejBw7//3UcP+BLUnSI+Q4RPCGFmUpG8MEMtRm1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radim Pavlik <radim.pavlik@tbs-biometrics.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 061/242] pinctrl: mcp23s08: fix race condition in irq handler
Date:   Thu, 15 Jul 2021 20:37:03 +0200
Message-Id: <20210715182603.193204547@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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



