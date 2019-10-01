Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22670C3B7D
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390005AbfJAQoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389860AbfJAQod (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9F221855;
        Tue,  1 Oct 2019 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948272;
        bh=gT/n4oqc6OGEqUUO2qysr1qAGttbCYzxG2DAiUEliRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfUud0q3IzpEK800OsiY63wNhA2+5IE1qeBqbZ78AVkozXaLkW1581sVHv2KurdQU
         9V0vvoVO7GezVAL+/n7PEoP7n0YQxaxy7MIkmnWZxEPoB9MNKiGftYzoCDexH1fdYJ
         wEou2rTa4zix7GGLOIZ1UkG59kOiwnhAiIfltD7s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryan Chen <ryan_chen@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/29] watchdog: aspeed: Add support for AST2600
Date:   Tue,  1 Oct 2019 12:44:02 -0400
Message-Id: <20191001164423.16406-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Chen <ryan_chen@aspeedtech.com>

[ Upstream commit b3528b4874480818e38e4da019d655413c233e6a ]

The ast2600 can be supported by the same code as the ast2500.

Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20190819051738.17370-3-joel@jms.id.au
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/aspeed_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index fd91007b4e41b..cee7334b2a000 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -38,6 +38,7 @@ static const struct aspeed_wdt_config ast2500_config = {
 static const struct of_device_id aspeed_wdt_of_table[] = {
 	{ .compatible = "aspeed,ast2400-wdt", .data = &ast2400_config },
 	{ .compatible = "aspeed,ast2500-wdt", .data = &ast2500_config },
+	{ .compatible = "aspeed,ast2600-wdt", .data = &ast2500_config },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, aspeed_wdt_of_table);
@@ -257,7 +258,8 @@ static int aspeed_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &wdt->wdd.status);
 	}
 
-	if (of_device_is_compatible(np, "aspeed,ast2500-wdt")) {
+	if ((of_device_is_compatible(np, "aspeed,ast2500-wdt")) ||
+		(of_device_is_compatible(np, "aspeed,ast2600-wdt"))) {
 		u32 reg = readl(wdt->base + WDT_RESET_WIDTH);
 
 		reg &= config->ext_pulse_width_mask;
-- 
2.20.1

