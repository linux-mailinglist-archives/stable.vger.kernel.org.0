Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4D428F2B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbhJKNzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237550AbhJKNxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 200E561040;
        Mon, 11 Oct 2021 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960306;
        bh=oWq240JKaEmzwNlfCCFXfyD6Sto6/tWL2lWIpBhANzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIt01UtwxmA3uyy9GvhCGSaxmpf0DSZWfe/PEJ9lr3zc3YS1BHsbQ5ZaToae08O3H
         4Sgz51QyXV/sjF0Tdurk49ELEHwO9fOeRxXyPH+pxgNJe/azFlradn1vk3VR6XTpp4
         +YX410wjBXWUu0jTFyDXQPmuti23TeST5o/x6GbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/83] ARM: at91: pm: do not panic if ram controllers are not enabled
Date:   Mon, 11 Oct 2021 15:45:44 +0200
Message-Id: <20211011134509.191646491@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 1605de1b3ca66e3eddbca4b3c353c13c26476fe2 ]

In case PM is enabled but there is no RAM controller information
in DT the code will panic. Avoid such scenarios by not initializing
platform specific PM code in case RAM controller is not provided
via DT.

Reported-by: Eugen Hristev <eugen.hristev@microchip.com>
Fixes: 827de1f123ba0 ("ARM: at91: remove at91_dt_initialize and machine init_early()")
Fixes: 892e1f4a3ae58 ("ARM: at91: pm: add sama7g5 ddr phy controller")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210823131915.23857-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 58 +++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 120f9aa6fff3..3f015cb6ec2b 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -517,18 +517,22 @@ static const struct of_device_id ramc_ids[] __initconst = {
 	{ /*sentinel*/ }
 };
 
-static __init void at91_dt_ramc(void)
+static __init int at91_dt_ramc(void)
 {
 	struct device_node *np;
 	const struct of_device_id *of_id;
 	int idx = 0;
 	void *standby = NULL;
 	const struct ramc_info *ramc;
+	int ret;
 
 	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
 		soc_pm.data.ramc[idx] = of_iomap(np, 0);
-		if (!soc_pm.data.ramc[idx])
-			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
+		if (!soc_pm.data.ramc[idx]) {
+			pr_err("unable to map ramc[%d] cpu registers\n", idx);
+			ret = -ENOMEM;
+			goto unmap_ramc;
+		}
 
 		ramc = of_id->data;
 		if (!standby)
@@ -538,15 +542,26 @@ static __init void at91_dt_ramc(void)
 		idx++;
 	}
 
-	if (!idx)
-		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
+	if (!idx) {
+		pr_err("unable to find compatible ram controller node in dtb\n");
+		ret = -ENODEV;
+		goto unmap_ramc;
+	}
 
 	if (!standby) {
 		pr_warn("ramc no standby function available\n");
-		return;
+		return 0;
 	}
 
 	at91_cpuidle_device.dev.platform_data = standby;
+
+	return 0;
+
+unmap_ramc:
+	while (idx)
+		iounmap(soc_pm.data.ramc[--idx]);
+
+	return ret;
 }
 
 static void at91rm9200_idle(void)
@@ -869,6 +884,8 @@ static void __init at91_pm_init(void (*pm_idle)(void))
 
 void __init at91rm9200_pm_init(void)
 {
+	int ret;
+
 	if (!IS_ENABLED(CONFIG_SOC_AT91RM9200))
 		return;
 
@@ -880,7 +897,9 @@ void __init at91rm9200_pm_init(void)
 	soc_pm.data.standby_mode = AT91_PM_STANDBY;
 	soc_pm.data.suspend_mode = AT91_PM_ULP0;
 
-	at91_dt_ramc();
+	ret = at91_dt_ramc();
+	if (ret)
+		return;
 
 	/*
 	 * AT91RM9200 SDRAM low-power mode cannot be used with self-refresh.
@@ -895,13 +914,17 @@ void __init sam9x60_pm_init(void)
 	static const int modes[] __initconst = {
 		AT91_PM_STANDBY, AT91_PM_ULP0, AT91_PM_ULP0_FAST, AT91_PM_ULP1,
 	};
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_SOC_SAM9X60))
 		return;
 
 	at91_pm_modes_validate(modes, ARRAY_SIZE(modes));
 	at91_pm_modes_init();
-	at91_dt_ramc();
+	ret = at91_dt_ramc();
+	if (ret)
+		return;
+
 	at91_pm_init(NULL);
 
 	soc_pm.ws_ids = sam9x60_ws_ids;
@@ -910,6 +933,8 @@ void __init sam9x60_pm_init(void)
 
 void __init at91sam9_pm_init(void)
 {
+	int ret;
+
 	if (!IS_ENABLED(CONFIG_SOC_AT91SAM9))
 		return;
 
@@ -921,7 +946,10 @@ void __init at91sam9_pm_init(void)
 	soc_pm.data.standby_mode = AT91_PM_STANDBY;
 	soc_pm.data.suspend_mode = AT91_PM_ULP0;
 
-	at91_dt_ramc();
+	ret = at91_dt_ramc();
+	if (ret)
+		return;
+
 	at91_pm_init(at91sam9_idle);
 }
 
@@ -930,12 +958,16 @@ void __init sama5_pm_init(void)
 	static const int modes[] __initconst = {
 		AT91_PM_STANDBY, AT91_PM_ULP0, AT91_PM_ULP0_FAST,
 	};
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_SOC_SAMA5))
 		return;
 
 	at91_pm_modes_validate(modes, ARRAY_SIZE(modes));
-	at91_dt_ramc();
+	ret = at91_dt_ramc();
+	if (ret)
+		return;
+
 	at91_pm_init(NULL);
 }
 
@@ -945,13 +977,17 @@ void __init sama5d2_pm_init(void)
 		AT91_PM_STANDBY, AT91_PM_ULP0, AT91_PM_ULP0_FAST, AT91_PM_ULP1,
 		AT91_PM_BACKUP,
 	};
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_SOC_SAMA5D2))
 		return;
 
 	at91_pm_modes_validate(modes, ARRAY_SIZE(modes));
 	at91_pm_modes_init();
-	at91_dt_ramc();
+	ret = at91_dt_ramc();
+	if (ret)
+		return;
+
 	at91_pm_init(NULL);
 
 	soc_pm.ws_ids = sama5d2_ws_ids;
-- 
2.33.0



