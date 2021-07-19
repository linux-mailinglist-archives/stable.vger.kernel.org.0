Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD893CDA41
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbhGSOfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244234AbhGSOdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C1406120D;
        Mon, 19 Jul 2021 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707589;
        bh=+br4lXrLjVnAKanPtMz7dggClCfj8m6FutAZAkS03dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTaaxF9ydUo4Y3x2hzjFj26rzMcpWcERWb2p+qGDWB76UEowb8wbFr1uqPY+f9CvU
         PWj4IdcGy6elTCu3fqBydqLiW9WISqQU4Ud5NrKcLVg1JfJLGd2BNKhJeFZmMppFwH
         9rJkZLia50YLIlJ8F93uCPiAHqR4I6lET7Zv4ry0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beomho Seo <beomho.seo@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 225/245] power: supply: rt5033_battery: Fix device tree enumeration
Date:   Mon, 19 Jul 2021 16:52:47 +0200
Message-Id: <20210719144947.665299160@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit f3076cd8d1d5fa64b5e1fa5affc045c2fc123baa ]

The fuel gauge in the RT5033 PMIC has its own I2C bus and interrupt
line. Therefore, it is not actually part of the RT5033 MFD and needs
its own of_match_table to probe properly.

Also, given that it's independent of the MFD, there is actually
no need to make the Kconfig depend on MFD_RT5033. Although the driver
uses the shared <linux/mfd/rt5033.h> header, there is no compile
or runtime dependency on the RT5033 MFD driver.

Cc: Beomho Seo <beomho.seo@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Fixes: b847dd96e659 ("power: rt5033_battery: Add RT5033 Fuel gauge device driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/Kconfig          | 3 ++-
 drivers/power/supply/rt5033_battery.c | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index 0de9a958b29a..b825e70a5196 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -490,7 +490,8 @@ config BATTERY_GOLDFISH
 
 config BATTERY_RT5033
 	tristate "RT5033 fuel gauge support"
-	depends on MFD_RT5033
+	depends on I2C
+	select REGMAP_I2C
 	help
 	  This adds support for battery fuel gauge in Richtek RT5033 PMIC.
 	  The fuelgauge calculates and determines the battery state of charge
diff --git a/drivers/power/supply/rt5033_battery.c b/drivers/power/supply/rt5033_battery.c
index bcdd83048492..9310b85f3405 100644
--- a/drivers/power/supply/rt5033_battery.c
+++ b/drivers/power/supply/rt5033_battery.c
@@ -167,9 +167,16 @@ static const struct i2c_device_id rt5033_battery_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, rt5033_battery_id);
 
+static const struct of_device_id rt5033_battery_of_match[] = {
+	{ .compatible = "richtek,rt5033-battery", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, rt5033_battery_of_match);
+
 static struct i2c_driver rt5033_battery_driver = {
 	.driver = {
 		.name = "rt5033-battery",
+		.of_match_table = rt5033_battery_of_match,
 	},
 	.probe = rt5033_battery_probe,
 	.remove = rt5033_battery_remove,
-- 
2.30.2



