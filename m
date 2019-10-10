Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C723D258D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbfJJImE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387736AbfJJImD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D6B2054F;
        Thu, 10 Oct 2019 08:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696922;
        bh=mxI74ZPxEKKZVu9DJn031+gWGvc4derrOM7DPZKYr6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SC0OVt1SVStAmwYPTdPMAekPkNjjzjYHKUSv6iH6ZxTiiiKXkONEzWIFvMrivefdc
         KiC7pA87SQaxaWgYg6fUWnKcG6TaxEMe8HtRP/AAGZKcr9UNb9W/ANMuh89quj5uKZ
         LMuGe2P7ah7XI220+LC5vp6IJ8t70VJeS0Q3Ps8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Chen <ryan_chen@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 102/148] watchdog: aspeed: Add support for AST2600
Date:   Thu, 10 Oct 2019 10:36:03 +0200
Message-Id: <20191010083617.402760750@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cc71861e033a5..5b64bc2e87888 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -34,6 +34,7 @@ static const struct aspeed_wdt_config ast2500_config = {
 static const struct of_device_id aspeed_wdt_of_table[] = {
 	{ .compatible = "aspeed,ast2400-wdt", .data = &ast2400_config },
 	{ .compatible = "aspeed,ast2500-wdt", .data = &ast2500_config },
+	{ .compatible = "aspeed,ast2600-wdt", .data = &ast2500_config },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, aspeed_wdt_of_table);
@@ -259,7 +260,8 @@ static int aspeed_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &wdt->wdd.status);
 	}
 
-	if (of_device_is_compatible(np, "aspeed,ast2500-wdt")) {
+	if ((of_device_is_compatible(np, "aspeed,ast2500-wdt")) ||
+		(of_device_is_compatible(np, "aspeed,ast2600-wdt"))) {
 		u32 reg = readl(wdt->base + WDT_RESET_WIDTH);
 
 		reg &= config->ext_pulse_width_mask;
-- 
2.20.1



