Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770BB11B68B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbfLKPNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731407AbfLKPNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E50C52467E;
        Wed, 11 Dec 2019 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077202;
        bh=BZ0oz8NjKl7UrehNzTIeGh2lJAIqcAF9T36DM21l1JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luMowHQWyuxZ5H6or+1O9/X6HSoxVxA9AzhjWLue8/BSUpQw7A5GERGunsiJULyB8
         WceqPf51itmbx4NaAWkN98kjrF8pRI/o8eNGEE5BOxaxwZdnzf2kul0ghJUE5U4Af2
         oxU114/eBVNs/y3/bY1F6qXkNbz+U/lvsn4Fhdwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 085/134] watchdog: aspeed: Fix clock behaviour for ast2600
Date:   Wed, 11 Dec 2019 10:11:01 -0500
Message-Id: <20191211151150.19073-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit c04571251b3d842096f1597f5d4badb508be016d ]

The ast2600 no longer uses bit 4 in the control register to indicate a
1MHz clock (It now controls whether this watchdog is reset by a SOC
reset). This means we do not want to set it. It also does not need to be
set for the ast2500, as it is read-only on that SoC.

The comment next to the clock rate selection wandered away from where it
was set, so put it back next to the register setting it's describing.

Fixes: b3528b487448 ("watchdog: aspeed: Add support for AST2600")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191108032905.22463-1-joel@jms.id.au
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/aspeed_wdt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index 4ec0906bf12c0..7e00960651fa2 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -258,11 +258,6 @@ static int aspeed_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(wdt->base))
 		return PTR_ERR(wdt->base);
 
-	/*
-	 * The ast2400 wdt can run at PCLK, or 1MHz. The ast2500 only
-	 * runs at 1MHz. We chose to always run at 1MHz, as there's no
-	 * good reason to have a faster watchdog counter.
-	 */
 	wdt->wdd.info = &aspeed_wdt_info;
 	wdt->wdd.ops = &aspeed_wdt_ops;
 	wdt->wdd.max_hw_heartbeat_ms = WDT_MAX_TIMEOUT_MS;
@@ -278,7 +273,16 @@ static int aspeed_wdt_probe(struct platform_device *pdev)
 		return -EINVAL;
 	config = ofdid->data;
 
-	wdt->ctrl = WDT_CTRL_1MHZ_CLK;
+	/*
+	 * On clock rates:
+	 *  - ast2400 wdt can run at PCLK, or 1MHz
+	 *  - ast2500 only runs at 1MHz, hard coding bit 4 to 1
+	 *  - ast2600 always runs at 1MHz
+	 *
+	 * Set the ast2400 to run at 1MHz as it simplifies the driver.
+	 */
+	if (of_device_is_compatible(np, "aspeed,ast2400-wdt"))
+		wdt->ctrl = WDT_CTRL_1MHZ_CLK;
 
 	/*
 	 * Control reset on a per-device basis to ensure the
-- 
2.20.1

