Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF707206697
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgFWVpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbgFWUBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D57E20706;
        Tue, 23 Jun 2020 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942491;
        bh=6KYGowrzrr9cciLk8MGC+ETxd//Kcx5ni1exb4LNYrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qy3GdmyXLWzSLoG1wzDbNmb5bHTdhW3t0f7HG2wmJ02B3gT5ekoB2/up5jwUTQWsM
         dStm3nBH6Ej3snIMGzb9mRiY4ZpEI/1AdL3q3cB6kSjBp6crp6j+/UnwY+aZqtYCZS
         /4RTkz3lOu9czvx7dIu+AG8V4euWmMMGXJawDfVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 002/477] power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select
Date:   Tue, 23 Jun 2020 21:49:59 +0200
Message-Id: <20200623195407.699660932@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f3424fdce341a..d37ec0d03237f 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -577,7 +577,7 @@ config CHARGER_BQ24257
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



