Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE2328F63
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbhCATuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241590AbhCATlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A4164F09;
        Mon,  1 Mar 2021 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620922;
        bh=NXJ/XzcRnMM+bqeIih9+MbcbbRotd2BEK71cIbAfxGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzhPHMd/sSZt7SswhhvuAn9VW5qbtEm3dpwnJ510JuBeeoM75gJtrA63wCLuNZUrG
         tLkZJZvy1t99ZVqJkzHwno+H1R9XZBUFsYzmMnFGIDnjhiMNNOReEab6Mw6HJPK34l
         VOpSdytz6HOS+IJy18Ir4I5wZtadaS5+AiG3ZFJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 327/775] rtc: rx6110: fix build against modular I2C
Date:   Mon,  1 Mar 2021 17:08:15 +0100
Message-Id: <20210301161217.778192074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit def8550f543e6c9101f3e1a03160b2aab8c02e8a ]

With CONFIG_I2C=m, the #ifdef section is disabled, as shown
by this warning:

drivers/rtc/rtc-rx6110.c:314:12: error: unused function 'rx6110_probe' [-Werror,-Wunused-function]

Change the driver to use IS_ENABLED() instead, which works
for both module and built-in subsystems.

Fixes: afa819c2c6bf ("rtc: rx6110: add i2c support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201230145938.3254459-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rx6110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rx6110.c b/drivers/rtc/rtc-rx6110.c
index a7b671a210223..79161d4c6ce4d 100644
--- a/drivers/rtc/rtc-rx6110.c
+++ b/drivers/rtc/rtc-rx6110.c
@@ -331,7 +331,7 @@ static int rx6110_probe(struct rx6110_data *rx6110, struct device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_SPI_MASTER
+#if IS_ENABLED(CONFIG_SPI_MASTER)
 static struct regmap_config regmap_spi_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -411,7 +411,7 @@ static void rx6110_spi_unregister(void)
 }
 #endif /* CONFIG_SPI_MASTER */
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 static struct regmap_config regmap_i2c_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-- 
2.27.0



