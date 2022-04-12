Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D594FD5D7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377014AbiDLHrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357221AbiDLHjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4901D1582D;
        Tue, 12 Apr 2022 00:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D766461045;
        Tue, 12 Apr 2022 07:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E335CC385A1;
        Tue, 12 Apr 2022 07:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747636;
        bh=Hh8TQDDukf6SBZKFe+GfLCSWmvkOIWW41tky6bIOHxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5f4NSYM0fJ/iefeF4bI70uYnrHRpzSAwVZt4bIPShIxrDPkgQtiWbRryoI7hFmna
         XDTDgEKjyXWnBYrarGnRpmPAGKaKCtgqzD9z2Y52xHbvQUTMioQfL3X56JqXvINexl
         pdbXKBIwCd31m3eQMtRMUAtyH/1j3z3PFrtqfQak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/343] power: supply: axp288_charger: Use acpi_quirk_skip_acpi_ac_and_battery()
Date:   Tue, 12 Apr 2022 08:28:49 +0200
Message-Id: <20220412062954.597367971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.35.1



