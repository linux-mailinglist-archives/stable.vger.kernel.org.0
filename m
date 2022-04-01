Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0EF4EF151
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348120AbiDAOhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348189AbiDAOdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949A8292DB7;
        Fri,  1 Apr 2022 07:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A76B8250B;
        Fri,  1 Apr 2022 14:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB9CC3410F;
        Fri,  1 Apr 2022 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823470;
        bh=rCEQD5Z7Au9yX33/IhgwV/aeEEhrjMYdth/fvUikTvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgOHngsQVnt38u6yVw19smY0360HJlPQ+8xgcNEndq8bPPr1Js00VUF7uciRizuAz
         0nyH8wCZpXKXPelWXCjYUTBcoDtPh/VGa2bwAxhIR7RbH4UIK/bkRR7i1q71F5YiJ5
         WAnWrpR8kJSy7q/8vvq0qf14GzKP7n5y/A8GLmePQQt4KwWfyHPvVJeF3A6mlI46Lr
         4CZqPZkuY42pF8QzSrSE7q6ScGx585HA+2226aaQyxQqaGSvfq7HitVX7dmJ9YVU5O
         WcjqOudLMRimDxTxhPwDSUR6RRRj8nS3ecJDzjlwCkTVTS5lPq7wpLK+Etaxuut5Md
         tC85OEA82rQWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org, wens@csie.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 104/149] power: supply: axp288_charger: Use acpi_quirk_skip_acpi_ac_and_battery()
Date:   Fri,  1 Apr 2022 10:24:51 -0400
Message-Id: <20220401142536.1948161-104-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 00d0566614b7bb7b226cb5a6895b0180ffe6915a ]

Normally the native AXP288 fg/charger drivers are preferred but one some
devices the ACPI drivers should be used instead.

The ACPI battery/ac drivers use the acpi_quirk_skip_acpi_ac_and_battery()
helper to determine if they should skip loading because native fuel-gauge/
charger drivers like the AXP288 drivers will be used.

The new acpi_quirk_skip_acpi_ac_and_battery() helper includes a list of
exceptions for boards where the ACPI drivers should be used instead.

Use this new helper to avoid loading on such boards. Note this requires
adding a Kconfig dependency on ACPI, this is not a problem because ACPI
should be enabled on all boards with an AXP288 PMIC anyways.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/Kconfig          | 2 +-
 drivers/power/supply/axp288_charger.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index b366e2fd8e97..d7534f12e9ef 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -351,7 +351,7 @@ config AXP20X_POWER
 
 config AXP288_CHARGER
 	tristate "X-Powers AXP288 Charger"
-	depends on MFD_AXP20X && EXTCON_AXP288 && IOSF_MBI
+	depends on MFD_AXP20X && EXTCON_AXP288 && IOSF_MBI && ACPI
 	help
 	  Say yes here to have support X-Power AXP288 power management IC (PMIC)
 	  integrated charger.
diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index c498e62ab4e2..19746e658a6a 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -838,6 +838,13 @@ static int axp288_charger_probe(struct platform_device *pdev)
 	struct power_supply_config charger_cfg = {};
 	unsigned int val;
 
+	/*
+	 * Normally the native AXP288 fg/charger drivers are preferred but
+	 * on some devices the ACPI drivers should be used instead.
+	 */
+	if (!acpi_quirk_skip_acpi_ac_and_battery())
+		return -ENODEV;
+
 	/*
 	 * On some devices the fuelgauge and charger parts of the axp288 are
 	 * not used, check that the fuelgauge is enabled (CC_CTRL != 0).
-- 
2.34.1

