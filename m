Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFC176BD4
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCCCwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbgCCCty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF67E2468D;
        Tue,  3 Mar 2020 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203793;
        bh=h9VO2Y3iLgmkckLlYUSL5GxvLwG/mcpr+WlanXYTang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPeQJzpEU+5YJRYR2IzN0AKMx4mig7m3W4wmZq9aq8C/JXMKoaQ7gRYF/Ikahw5q4
         VAeYs/lhYAWI/lB8mx/6HUX/zYZ9+Z6AMwowKna3h7r36l+dJ1THDL2PnIzyGV7sgG
         v9eeiq8aDBa6d7vYju1xfKO0WlYT7J8OlUj/0HmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/22] watchdog: da9062: do not ping the hw during stop()
Date:   Mon,  2 Mar 2020 21:49:26 -0500
Message-Id: <20200303024933.10371-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024933.10371-1-sashal@kernel.org>
References: <20200303024933.10371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit e9a0e65eda3f78d0b04ec6136c591c000cbc3b76 ]

The da9062 hw has a minimum ping cool down phase of at least 200ms. The
driver takes that into account by setting the min_hw_heartbeat_ms to
300ms and the core guarantees that the hw limit is observed for the
ping() calls. But the core can't guarantee the required minimum ping
cool down phase if a stop() command is send immediately after the ping()
command. So it is not allowed to ping the watchdog within the stop()
command as the driver does. Remove the ping can be done without doubts
because the watchdog gets disabled anyway and a (re)start resets the
watchdog counter too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200120091729.16256-1-m.felsch@pengutronix.de
[groeck: Updated description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9062_wdt.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/watchdog/da9062_wdt.c b/drivers/watchdog/da9062_wdt.c
index 9083d3d922b0b..79383ff620199 100644
--- a/drivers/watchdog/da9062_wdt.c
+++ b/drivers/watchdog/da9062_wdt.c
@@ -126,13 +126,6 @@ static int da9062_wdt_stop(struct watchdog_device *wdd)
 	struct da9062_watchdog *wdt = watchdog_get_drvdata(wdd);
 	int ret;
 
-	ret = da9062_reset_watchdog_timer(wdt);
-	if (ret) {
-		dev_err(wdt->hw->dev, "Failed to ping the watchdog (err = %d)\n",
-			ret);
-		return ret;
-	}
-
 	ret = regmap_update_bits(wdt->hw->regmap,
 				 DA9062AA_CONTROL_D,
 				 DA9062AA_TWDSCALE_MASK,
-- 
2.20.1

