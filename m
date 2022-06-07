Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B919540B7A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350870AbiFGS3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351364AbiFGSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E09C6858;
        Tue,  7 Jun 2022 10:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 855F4B8236D;
        Tue,  7 Jun 2022 17:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81753C34119;
        Tue,  7 Jun 2022 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624439;
        bh=f6HB5NhIscnksW5jhehvzcWHKlFOREfOBHOcMMS+Xjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1bfCbiwnLAyFGIJiuHkQYRcav/42d/70yrA5uV3yMtZ4B5oK2EbnQ69DKjjx4ULs
         TlbwMR4ukJ2m28GbSCmQtwtRzzbGhaJ5qI0VGs/0a2FSnDBeQZVdM+HQVbFuxU6/H1
         7x+jrxr8oeW16hgnTmNYQMsU862s3fxnTSQdN3zIt3/C22P7y5pAUcoOD+a13lJ1le
         whWUZN60jz4ouiDJSkRR2UD1oC0JAfYfycRZhswD+2yx+ZVgTpjFi1LOWt/MnKkQwM
         toaCz8VNquoi2U23ay6sRHe9QxIuJkcA9PhWs7p+UHCh+oVS5NnJPGDPGp798uJuaA
         i/1kE3JCDuOjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, myungjoo.ham@samsung.com,
        wens@csie.org, sre@kernel.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 22/60] extcon: Fix extcon_get_extcon_dev() error handling
Date:   Tue,  7 Jun 2022 13:52:19 -0400
Message-Id: <20220607175259.478835-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 58e4a2d27d3255e4e8c507fdc13734dccc9fc4c7 ]

The extcon_get_extcon_dev() function returns error pointers on error,
NULL when it's a -EPROBE_DEFER defer situation, and ERR_PTR(-ENODEV)
when the CONFIG_EXTCON option is disabled.  This is very complicated for
the callers to handle and a number of them had bugs that would lead to
an Oops.

In real life, there are two things which prevented crashes.  First,
error pointers would only be returned if there was bug in the caller
where they passed a NULL "extcon_name" and none of them do that.
Second, only two out of the eight drivers will build when CONFIG_EXTCON
is disabled.

The normal way to write this would be to return -EPROBE_DEFER directly
when appropriate and return NULL when CONFIG_EXTCON is disabled.  Then
the error handling is simple and just looks like:

	dev->edev = extcon_get_extcon_dev(acpi_dev_name(adev));
	if (IS_ERR(dev->edev))
		return PTR_ERR(dev->edev);

For the two drivers which can build with CONFIG_EXTCON disabled, then
extcon_get_extcon_dev() will now return NULL which is not treated as an
error and the probe will continue successfully.  Those two drivers are
"typec_fusb302" and "max8997-battery".  In the original code, the
typec_fusb302 driver had an 800ms hang in tcpm_get_current_limit() but
now that function is a no-op.  For the max8997-battery driver everything
should continue working as is.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-axp288.c         |  4 ++--
 drivers/extcon/extcon.c                |  4 +++-
 drivers/power/supply/axp288_charger.c  | 17 ++++++++++-------
 drivers/power/supply/charger-manager.c |  7 ++-----
 drivers/power/supply/max8997_charger.c |  8 ++++----
 drivers/usb/dwc3/drd.c                 |  9 ++-------
 drivers/usb/phy/phy-omap-otg.c         |  4 ++--
 drivers/usb/typec/tcpm/fusb302.c       |  4 ++--
 include/linux/extcon.h                 |  2 +-
 9 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index 7c6d5857ff25..180be768c215 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -394,8 +394,8 @@ static int axp288_extcon_probe(struct platform_device *pdev)
 		if (adev) {
 			info->id_extcon = extcon_get_extcon_dev(acpi_dev_name(adev));
 			put_device(&adev->dev);
-			if (!info->id_extcon)
-				return -EPROBE_DEFER;
+			if (IS_ERR(info->id_extcon))
+				return PTR_ERR(info->id_extcon);
 
 			dev_info(dev, "controlling USB role\n");
 		} else {
diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index a09e704fd0fa..adb957470c65 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -851,6 +851,8 @@ EXPORT_SYMBOL_GPL(extcon_set_property_capability);
  * @extcon_name:	the extcon name provided with extcon_dev_register()
  *
  * Return the pointer of extcon device if success or ERR_PTR(err) if fail.
+ * NOTE: This function returns -EPROBE_DEFER so it may only be called from
+ * probe() functions.
  */
 struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
@@ -864,7 +866,7 @@ struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 		if (!strcmp(sd->name, extcon_name))
 			goto out;
 	}
-	sd = NULL;
+	sd = ERR_PTR(-EPROBE_DEFER);
 out:
 	mutex_unlock(&extcon_dev_list_lock);
 	return sd;
diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index 19746e658a6a..15219ed43ce9 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -865,17 +865,20 @@ static int axp288_charger_probe(struct platform_device *pdev)
 	info->regmap_irqc = axp20x->regmap_irqc;
 
 	info->cable.edev = extcon_get_extcon_dev(AXP288_EXTCON_DEV_NAME);
-	if (info->cable.edev == NULL) {
-		dev_dbg(dev, "%s is not ready, probe deferred\n",
-			AXP288_EXTCON_DEV_NAME);
-		return -EPROBE_DEFER;
+	if (IS_ERR(info->cable.edev)) {
+		dev_err_probe(dev, PTR_ERR(info->cable.edev),
+			      "extcon_get_extcon_dev(%s) failed\n",
+			      AXP288_EXTCON_DEV_NAME);
+		return PTR_ERR(info->cable.edev);
 	}
 
 	if (acpi_dev_present(USB_HOST_EXTCON_HID, NULL, -1)) {
 		info->otg.cable = extcon_get_extcon_dev(USB_HOST_EXTCON_NAME);
-		if (info->otg.cable == NULL) {
-			dev_dbg(dev, "EXTCON_USB_HOST is not ready, probe deferred\n");
-			return -EPROBE_DEFER;
+		if (IS_ERR(info->otg.cable)) {
+			dev_err_probe(dev, PTR_ERR(info->otg.cable),
+				      "extcon_get_extcon_dev(%s) failed\n",
+				      USB_HOST_EXTCON_NAME);
+			return PTR_ERR(info->otg.cable);
 		}
 		dev_info(dev, "Using " USB_HOST_EXTCON_HID " extcon for usb-id\n");
 	}
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index d67edb760c94..92db79400a6a 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -985,13 +985,10 @@ static int charger_extcon_init(struct charger_manager *cm,
 	cable->nb.notifier_call = charger_extcon_notifier;
 
 	cable->extcon_dev = extcon_get_extcon_dev(cable->extcon_name);
-	if (IS_ERR_OR_NULL(cable->extcon_dev)) {
+	if (IS_ERR(cable->extcon_dev)) {
 		pr_err("Cannot find extcon_dev for %s (cable: %s)\n",
 			cable->extcon_name, cable->name);
-		if (cable->extcon_dev == NULL)
-			return -EPROBE_DEFER;
-		else
-			return PTR_ERR(cable->extcon_dev);
+		return PTR_ERR(cable->extcon_dev);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(extcon_mapping); i++) {
diff --git a/drivers/power/supply/max8997_charger.c b/drivers/power/supply/max8997_charger.c
index 25207fe2aa68..bfa7a576523d 100644
--- a/drivers/power/supply/max8997_charger.c
+++ b/drivers/power/supply/max8997_charger.c
@@ -248,10 +248,10 @@ static int max8997_battery_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "couldn't get charger regulator\n");
 	}
 	charger->edev = extcon_get_extcon_dev("max8997-muic");
-	if (IS_ERR_OR_NULL(charger->edev)) {
-		if (!charger->edev)
-			return -EPROBE_DEFER;
-		dev_info(charger->dev, "couldn't get extcon device\n");
+	if (IS_ERR(charger->edev)) {
+		dev_err_probe(charger->dev, PTR_ERR(charger->edev),
+			      "couldn't get extcon device: max8997-muic\n");
+		return PTR_ERR(charger->edev);
 	}
 
 	if (!IS_ERR(charger->reg) && !IS_ERR_OR_NULL(charger->edev)) {
diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
index f148b0370f82..81ff21bd405a 100644
--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -454,13 +454,8 @@ static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
 	 * This device property is for kernel internal use only and
 	 * is expected to be set by the glue code.
 	 */
-	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
-		edev = extcon_get_extcon_dev(name);
-		if (!edev)
-			return ERR_PTR(-EPROBE_DEFER);
-
-		return edev;
-	}
+	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0)
+		return extcon_get_extcon_dev(name);
 
 	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"
diff --git a/drivers/usb/phy/phy-omap-otg.c b/drivers/usb/phy/phy-omap-otg.c
index ee0863c6553e..6e6ef8c0bc7e 100644
--- a/drivers/usb/phy/phy-omap-otg.c
+++ b/drivers/usb/phy/phy-omap-otg.c
@@ -95,8 +95,8 @@ static int omap_otg_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	extcon = extcon_get_extcon_dev(config->extcon);
-	if (!extcon)
-		return -EPROBE_DEFER;
+	if (IS_ERR(extcon))
+		return PTR_ERR(extcon);
 
 	otg_dev = devm_kzalloc(&pdev->dev, sizeof(*otg_dev), GFP_KERNEL);
 	if (!otg_dev)
diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 72f9001b0792..96c55eaf3f80 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1708,8 +1708,8 @@ static int fusb302_probe(struct i2c_client *client,
 	 */
 	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
 		chip->extcon = extcon_get_extcon_dev(name);
-		if (!chip->extcon)
-			return -EPROBE_DEFER;
+		if (IS_ERR(chip->extcon))
+			return PTR_ERR(chip->extcon);
 	}
 
 	chip->vbus = devm_regulator_get(chip->dev, "vbus");
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 0c19010da77f..685401d94d39 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -296,7 +296,7 @@ static inline void devm_extcon_unregister_notifier_all(struct device *dev,
 
 static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
-	return ERR_PTR(-ENODEV);
+	return NULL;
 }
 
 static inline struct extcon_dev *extcon_find_edev_by_node(struct device_node *node)
-- 
2.35.1

