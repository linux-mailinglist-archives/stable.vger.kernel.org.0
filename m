Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51113C3761
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGJXwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhGJXvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC02E6135C;
        Sat, 10 Jul 2021 23:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960949;
        bh=HxbYvG5Rj6h4UHhku3DIzRD+CcvctKcna1ezGhDmGWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQcbTtgQ80LwJkAYSreqiKYIaQlWMKd3KhvRF+JrXKhTT8H0Pp72vePXEbXA7SS+b
         q2fVPzUBErBZNkjuKE7NJUTHgjiLvWMqe6hfxCT53IUxm9KKcU+DVt9DbQTGv0PxcV
         1NVAXbG7uCpjK9Qakfhvg9TzaQ7GVHwpHttaDgT/1LnP9I86+q89+lrATqepccQ5+d
         KnsiwiUZM6xn963RZkooFGstWu2fUvxYZCIXgOK/9AAaArij9HMWvDkBScB3hVkDgc
         VW/Xj6hXmgNJ2Ox6l1YCg7iAj7A2wYFtqb2cBmzOgLA8DodrouacfNa0EV6D0jef86
         JE0nVMuwQokdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/53] power: supply: ab8500: Enable USB and AC
Date:   Sat, 10 Jul 2021 19:48:12 -0400
Message-Id: <20210710234857.3220040-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234857.3220040-1-sashal@kernel.org>
References: <20210710234857.3220040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit f9184a228d7a60ad56b810d549a7debb355f1be6 ]

The vendor code tree supplies platform data to enable he
USB charging for AB8500 and AB8500 and disable the AC
charging on the AB8505. This was missed when the driver
was submitted to the mainline kernel.

Fix this by doing what the vendor kernel does: always
register the USB charger, do not register the AC charger
on the AB8505.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500-bm.h      |  2 --
 drivers/power/supply/ab8500_charger.c | 24 ++++++++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/power/supply/ab8500-bm.h b/drivers/power/supply/ab8500-bm.h
index 012595a9d269..871bdc1f5cbd 100644
--- a/drivers/power/supply/ab8500-bm.h
+++ b/drivers/power/supply/ab8500-bm.h
@@ -507,8 +507,6 @@ struct abx500_bm_data {
 	int bkup_bat_v;
 	int bkup_bat_i;
 	bool autopower_cfg;
-	bool ac_enabled;
-	bool usb_enabled;
 	bool no_maintenance;
 	bool capacity_scaling;
 	bool chg_unknown_bat;
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 57fbfe3d8c03..e6f23ae05f95 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3511,7 +3511,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.max_out_curr =
 		di->bm->chg_output_curr[di->bm->n_chg_out_curr - 1];
 	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
-	di->ac_chg.enabled = di->bm->ac_enabled;
+	/*
+	 * The AB8505 only supports USB charging. If we are not the
+	 * AB8505, register an AC charger.
+	 *
+	 * TODO: if this should be opt-in, add DT properties for this.
+	 */
+	if (!is_ab8505(di->parent))
+		di->ac_chg.enabled = true;
 	di->ac_chg.external = false;
 
 	/* USB supply */
@@ -3525,7 +3532,6 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.max_out_curr =
 		di->bm->chg_output_curr[di->bm->n_chg_out_curr - 1];
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
-	di->usb_chg.enabled = di->bm->usb_enabled;
 	di->usb_chg.external = false;
 	di->usb_state.usb_current = -1;
 
@@ -3599,14 +3605,12 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Register USB charger class */
-	if (di->usb_chg.enabled) {
-		di->usb_chg.psy = devm_power_supply_register(dev,
-							&ab8500_usb_chg_desc,
-							&usb_psy_cfg);
-		if (IS_ERR(di->usb_chg.psy)) {
-			dev_err(dev, "failed to register USB charger\n");
-			return PTR_ERR(di->usb_chg.psy);
-		}
+	di->usb_chg.psy = devm_power_supply_register(dev,
+						     &ab8500_usb_chg_desc,
+						     &usb_psy_cfg);
+	if (IS_ERR(di->usb_chg.psy)) {
+		dev_err(dev, "failed to register USB charger\n");
+		return PTR_ERR(di->usb_chg.psy);
 	}
 
 	/* Identify the connected charger types during startup */
-- 
2.30.2

