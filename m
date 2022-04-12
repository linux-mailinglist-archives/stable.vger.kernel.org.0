Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AA4FD9D3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354466AbiDLHrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357220AbiDLHjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8B315A02;
        Tue, 12 Apr 2022 00:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 851D36153F;
        Tue, 12 Apr 2022 07:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C568C385A1;
        Tue, 12 Apr 2022 07:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747639;
        bh=VdfdafuRcjTS5UUKaCXYsrTgX5OBbE6LcxYACf3ZdkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgzXWVfJBn62Y7bU96wH1/AAq4IZDR3x+Z4Zk5I8d5wgs99HRiKXiaz+Oce0981E9
         TfsJFnURnLx3U9tfVQ7mbq1QE0VDryKeDgwGcQF5y1Dl0dl5Wx/U2yJdfZjL9JcWen
         mp+QFZ/7UOHuGEfzlYi3XTw7PZyz4ktx/0jZ+R1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 112/343] power: supply: axp288_fuel_gauge: Use acpi_quirk_skip_acpi_ac_and_battery()
Date:   Tue, 12 Apr 2022 08:28:50 +0200
Message-Id: <20220412062954.625100457@linuxfoundation.org>
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

[ Upstream commit da365db704d290fb4dc4cdbd41f60b0ecec1cc03 ]

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
 drivers/power/supply/Kconfig             |  2 +-
 drivers/power/supply/axp288_fuel_gauge.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index d7534f12e9ef..5e4a69352811 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -358,7 +358,7 @@ config AXP288_CHARGER
 
 config AXP288_FUEL_GAUGE
 	tristate "X-Powers AXP288 Fuel Gauge"
-	depends on MFD_AXP20X && IIO && IOSF_MBI
+	depends on MFD_AXP20X && IIO && IOSF_MBI && ACPI
 	help
 	  Say yes here to have support for X-Power power management IC (PMIC)
 	  Fuel Gauge. The device provides battery statistics and status
diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index c1da217fdb0e..ce8ffd0a41b5 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -9,6 +9,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -560,12 +561,6 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
 		},
 	},
-	{
-		/* ECS EF20EA */
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "EF20EA"),
-		},
-	},
 	{
 		/* Intel Cherry Trail Compute Stick, Windows version */
 		.matches = {
@@ -624,6 +619,13 @@ static int axp288_fuel_gauge_probe(struct platform_device *pdev)
 	};
 	unsigned int val;
 
+	/*
+	 * Normally the native AXP288 fg/charger drivers are preferred but
+	 * on some devices the ACPI drivers should be used instead.
+	 */
+	if (!acpi_quirk_skip_acpi_ac_and_battery())
+		return -ENODEV;
+
 	if (dmi_check_system(axp288_no_battery_list))
 		return -ENODEV;
 
-- 
2.35.1



