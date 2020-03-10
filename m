Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FBB17FAE6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbgCJNJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbgCJNJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E162469D;
        Tue, 10 Mar 2020 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845748;
        bh=h9VO2Y3iLgmkckLlYUSL5GxvLwG/mcpr+WlanXYTang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PllSUsVMbJicDiouvoBiPOWOZobHorq0IeN50LQ2zJAgXWkvzdd/sPuqH/CkhnBWu
         o12gaNey9tTV3illUh5ng8WHD100976xY9EmPDoz35zwH8Uwwqs4M0NU1uSNj2jvVR
         COYbuisr9L+XagAsdTi24OrfVwiSjea6aq62EQ/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 085/126] watchdog: da9062: do not ping the hw during stop()
Date:   Tue, 10 Mar 2020 13:41:46 +0100
Message-Id: <20200310124209.289046253@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



