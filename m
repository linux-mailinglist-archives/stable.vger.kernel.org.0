Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F76E1FE03D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgFRB2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732078AbgFRB2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:28:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DBEF22202;
        Thu, 18 Jun 2020 01:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443701;
        bh=sMSxNnOzziIw0t8UcdbljMWt/JhQm723fWWYaZC/qdc=;
        h=From:To:Cc:Subject:Date:From;
        b=mc0bSY2ElJtAhEcbjKd9AjhQpjNVGPO3m1K6V3BY/KX4W6NK2VYbKMEcVGZFRGggi
         RBy7wj3YiEWez2ZVPybnNn5of1Fk7rNp1Lf0Imzik3OX15sJjJZSRP9shGeQizm793
         BVITMngu1W1a+y7fJq+Y90Jooq2DKXJ5tWyO6guE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/80] power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select
Date:   Wed, 17 Jun 2020 21:27:00 -0400
Message-Id: <20200618012819.609778-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 87c3d579c8ed0eaea6b1567d529a8daa85a2bc6c ]

regmap is a library function that gets selected by drivers that need
it. No driver modules should depend on it. Depending on REGMAP_I2C makes
this driver only build if another driver already selected REGMAP_I2C,
as the symbol can't be selected through the menu kernel configuration.

Fixes: 2219a935963e ("power_supply: Add TI BQ24257 charger driver")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index 76806a0be820..0de9a958b29a 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -424,7 +424,7 @@ config CHARGER_BQ24257
 	tristate "TI BQ24250/24251/24257 battery charger driver"
 	depends on I2C
 	depends on GPIOLIB || COMPILE_TEST
-	depends on REGMAP_I2C
+	select REGMAP_I2C
 	help
 	  Say Y to enable support for the TI BQ24250, BQ24251, and BQ24257 battery
 	  chargers.
-- 
2.25.1

