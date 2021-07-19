Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C503CE2EF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbhGSPcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346701AbhGSP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F60D61396;
        Mon, 19 Jul 2021 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710909;
        bh=HxbYvG5Rj6h4UHhku3DIzRD+CcvctKcna1ezGhDmGWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnDyzOPI9qGzsY8ZVbXPf6phVfdfq7Zyoq+pZtbl9l968nMulEsHWe/8ngQnUk+sb
         e49dG9GnDroeWt3EqOR7RGrINHSSbPRhbAzuqMDuXHhrquoZziCIadEn4JSZD7ZErQ
         Y/iShhy5CiVji94nkgiIMsHtEhPSDT6FLF/oXQug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 154/351] power: supply: ab8500: Enable USB and AC
Date:   Mon, 19 Jul 2021 16:51:40 +0200
Message-Id: <20210719144950.069165370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



