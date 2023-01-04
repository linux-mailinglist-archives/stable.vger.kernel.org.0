Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D815665D822
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbjADQLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbjADQKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC453C394
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B276B8172E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC251C433F0;
        Wed,  4 Jan 2023 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848632;
        bh=367F8FRmKA/J4vXC4dAjCAjpZuRDsXrGuF+pyuIGmIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWBr1zsGzGUUj9bnUyp8D43TADNJvsF0Nz3WHLvqr3xOP9w3YicYzbs9OUc0N6wj5
         lFOou5pegxEvh/sjObcmxYNuxOvgFVPeHGbQHzgf363YLqnkqwqIGV4RRp6vjti4VH
         Wa5vDXVqIiLQP1WFl78zaFedVeLBWuBFsGPury3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Philipp Jungkamp <p.jungkamp@gmx.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/207] platform/x86: ideapad-laptop: support for more special keys in WMI
Date:   Wed,  4 Jan 2023 17:05:03 +0100
Message-Id: <20230104160513.339248124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Jungkamp <p.jungkamp@gmx.net>

[ Upstream commit f32e02417614d3588a3954dab2a70320c43d1010 ]

The event data of the WMI event 0xD0, which is assumed to be the
fn_lock, is used to indicate several special keys on newer Yoga 7/9
laptops.

The notify_id 0xD0 is non-unique in the DSDT of the Yoga 9 14IAP7, this
causes wmi_get_event_data() to report wrong values.
Port the ideapad-laptop WMI code to the wmi bus infrastructure which
does not suffer from the shortcomings of wmi_get_event_data().

Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
Link: https://lore.kernel.org/r/20221116110647.3438-1-p.jungkamp@gmx.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 261 ++++++++++++++++++++------
 1 file changed, 202 insertions(+), 59 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 125b4534424f..13e3ae731fd8 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -30,6 +30,7 @@
 #include <linux/seq_file.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
+#include <linux/wmi.h>
 
 #include <acpi/video.h>
 
@@ -37,14 +38,6 @@
 
 #define IDEAPAD_RFKILL_DEV_NUM	3
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-static const char *const ideapad_wmi_fnesc_events[] = {
-	"26CAB2E5-5CF1-46AE-AAC3-4A12B6BA50E6", /* Yoga 3 */
-	"56322276-8493-4CE8-A783-98C991274F5E", /* Yoga 700 */
-	"8FC0DE0C-B4E4-43FD-B0F3-8871711C1294", /* Legion 5 */
-};
-#endif
-
 enum {
 	CFG_CAP_BT_BIT       = 16,
 	CFG_CAP_3G_BIT       = 17,
@@ -141,7 +134,6 @@ struct ideapad_private {
 	struct ideapad_dytc_priv *dytc;
 	struct dentry *debug;
 	unsigned long cfg;
-	const char *fnesc_guid;
 	struct {
 		bool conservation_mode    : 1;
 		bool dytc                 : 1;
@@ -182,6 +174,42 @@ MODULE_PARM_DESC(set_fn_lock_led,
 	"Enable driver based updates of the fn-lock LED on fn-lock changes. "
 	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
 
+/*
+ * shared data
+ */
+
+static struct ideapad_private *ideapad_shared;
+static DEFINE_MUTEX(ideapad_shared_mutex);
+
+static int ideapad_shared_init(struct ideapad_private *priv)
+{
+	int ret;
+
+	mutex_lock(&ideapad_shared_mutex);
+
+	if (!ideapad_shared) {
+		ideapad_shared = priv;
+		ret = 0;
+	} else {
+		dev_warn(&priv->adev->dev, "found multiple platform devices\n");
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&ideapad_shared_mutex);
+
+	return ret;
+}
+
+static void ideapad_shared_exit(struct ideapad_private *priv)
+{
+	mutex_lock(&ideapad_shared_mutex);
+
+	if (ideapad_shared == priv)
+		ideapad_shared = NULL;
+
+	mutex_unlock(&ideapad_shared_mutex);
+}
+
 /*
  * ACPI Helpers
  */
@@ -1110,6 +1138,8 @@ static void ideapad_sysfs_exit(struct ideapad_private *priv)
 /*
  * input device
  */
+#define IDEAPAD_WMI_KEY 0x100
+
 static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,   6, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY,   7, { KEY_CAMERA } },
@@ -1123,6 +1153,28 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
 	{ KE_KEY, 128, { KEY_ESC } },
+
+	/*
+	 * WMI keys
+	 */
+
+	/* FnLock (handled by the firmware) */
+	{ KE_IGNORE,	0x02 | IDEAPAD_WMI_KEY },
+	/* Esc (handled by the firmware) */
+	{ KE_IGNORE,	0x03 | IDEAPAD_WMI_KEY },
+	/* Customizable Lenovo Hotkey ("star" with 'S' inside) */
+	{ KE_KEY,	0x01 | IDEAPAD_WMI_KEY, { KEY_FAVORITES } },
+	/* Dark mode toggle */
+	{ KE_KEY,	0x13 | IDEAPAD_WMI_KEY, { KEY_PROG1 } },
+	/* Sound profile switch */
+	{ KE_KEY,	0x12 | IDEAPAD_WMI_KEY, { KEY_PROG2 } },
+	/* Lenovo Virtual Background application */
+	{ KE_KEY,	0x28 | IDEAPAD_WMI_KEY, { KEY_PROG3 } },
+	/* Lenovo Support */
+	{ KE_KEY,	0x27 | IDEAPAD_WMI_KEY, { KEY_HELP } },
+	/* Refresh Rate Toggle */
+	{ KE_KEY,	0x0a | IDEAPAD_WMI_KEY, { KEY_DISPLAYTOGGLE } },
+
 	{ KE_END },
 };
 
@@ -1526,33 +1578,6 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 	}
 }
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-static void ideapad_wmi_notify(u32 value, void *context)
-{
-	struct ideapad_private *priv = context;
-	unsigned long result;
-
-	switch (value) {
-	case 128:
-		ideapad_input_report(priv, value);
-		break;
-	case 208:
-		if (!priv->features.set_fn_lock_led)
-			break;
-
-		if (!eval_hals(priv->adev->handle, &result)) {
-			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
-
-			exec_sals(priv->adev->handle, state ? SALS_FNLOCK_ON : SALS_FNLOCK_OFF);
-		}
-		break;
-	default:
-		dev_info(&priv->platform_device->dev,
-			 "Unknown WMI event: %u\n", value);
-	}
-}
-#endif
-
 /* On some models we need to call exec_sals(SALS_FNLOCK_ON/OFF) to set the LED */
 static const struct dmi_system_id set_fn_lock_led_list[] = {
 	{
@@ -1643,6 +1668,118 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	}
 }
 
+#if IS_ENABLED(CONFIG_ACPI_WMI)
+/*
+ * WMI driver
+ */
+enum ideapad_wmi_event_type {
+	IDEAPAD_WMI_EVENT_ESC,
+	IDEAPAD_WMI_EVENT_FN_KEYS,
+};
+
+struct ideapad_wmi_private {
+	enum ideapad_wmi_event_type event;
+};
+
+static int ideapad_wmi_probe(struct wmi_device *wdev, const void *context)
+{
+	struct ideapad_wmi_private *wpriv;
+
+	wpriv = devm_kzalloc(&wdev->dev, sizeof(*wpriv), GFP_KERNEL);
+	if (!wpriv)
+		return -ENOMEM;
+
+	*wpriv = *(const struct ideapad_wmi_private *)context;
+
+	dev_set_drvdata(&wdev->dev, wpriv);
+	return 0;
+}
+
+static void ideapad_wmi_notify(struct wmi_device *wdev, union acpi_object *data)
+{
+	struct ideapad_wmi_private *wpriv = dev_get_drvdata(&wdev->dev);
+	struct ideapad_private *priv;
+	unsigned long result;
+
+	mutex_lock(&ideapad_shared_mutex);
+
+	priv = ideapad_shared;
+	if (!priv)
+		goto unlock;
+
+	switch (wpriv->event) {
+	case IDEAPAD_WMI_EVENT_ESC:
+		ideapad_input_report(priv, 128);
+		break;
+	case IDEAPAD_WMI_EVENT_FN_KEYS:
+		if (priv->features.set_fn_lock_led &&
+		    !eval_hals(priv->adev->handle, &result)) {
+			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
+
+			exec_sals(priv->adev->handle, state ? SALS_FNLOCK_ON : SALS_FNLOCK_OFF);
+		}
+
+		if (data->type != ACPI_TYPE_INTEGER) {
+			dev_warn(&wdev->dev,
+				 "WMI event data is not an integer\n");
+			break;
+		}
+
+		dev_dbg(&wdev->dev, "WMI fn-key event: 0x%llx\n",
+			data->integer.value);
+
+		ideapad_input_report(priv,
+				     data->integer.value | IDEAPAD_WMI_KEY);
+
+		break;
+	}
+unlock:
+	mutex_unlock(&ideapad_shared_mutex);
+}
+
+static const struct ideapad_wmi_private ideapad_wmi_context_esc = {
+	.event = IDEAPAD_WMI_EVENT_ESC
+};
+
+static const struct ideapad_wmi_private ideapad_wmi_context_fn_keys = {
+	.event = IDEAPAD_WMI_EVENT_FN_KEYS
+};
+
+static const struct wmi_device_id ideapad_wmi_ids[] = {
+	{ "26CAB2E5-5CF1-46AE-AAC3-4A12B6BA50E6", &ideapad_wmi_context_esc }, /* Yoga 3 */
+	{ "56322276-8493-4CE8-A783-98C991274F5E", &ideapad_wmi_context_esc }, /* Yoga 700 */
+	{ "8FC0DE0C-B4E4-43FD-B0F3-8871711C1294", &ideapad_wmi_context_fn_keys }, /* Legion 5 */
+	{},
+};
+MODULE_DEVICE_TABLE(wmi, ideapad_wmi_ids);
+
+static struct wmi_driver ideapad_wmi_driver = {
+	.driver = {
+		.name = "ideapad_wmi",
+	},
+	.id_table = ideapad_wmi_ids,
+	.probe = ideapad_wmi_probe,
+	.notify = ideapad_wmi_notify,
+};
+
+static int ideapad_wmi_driver_register(void)
+{
+	return wmi_driver_register(&ideapad_wmi_driver);
+}
+
+static void ideapad_wmi_driver_unregister(void)
+{
+	return wmi_driver_unregister(&ideapad_wmi_driver);
+}
+
+#else
+static inline int ideapad_wmi_driver_register(void) { return 0; }
+static inline void ideapad_wmi_driver_unregister(void) { }
+#endif
+
+/*
+ * ACPI driver
+ */
 static int ideapad_acpi_add(struct platform_device *pdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
@@ -1724,30 +1861,16 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 		goto notification_failed;
 	}
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-	for (i = 0; i < ARRAY_SIZE(ideapad_wmi_fnesc_events); i++) {
-		status = wmi_install_notify_handler(ideapad_wmi_fnesc_events[i],
-						    ideapad_wmi_notify, priv);
-		if (ACPI_SUCCESS(status)) {
-			priv->fnesc_guid = ideapad_wmi_fnesc_events[i];
-			break;
-		}
-	}
-
-	if (ACPI_FAILURE(status) && status != AE_NOT_EXIST) {
-		err = -EIO;
-		goto notification_failed_wmi;
-	}
-#endif
+	err = ideapad_shared_init(priv);
+	if (err)
+		goto shared_init_failed;
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-notification_failed_wmi:
+shared_init_failed:
 	acpi_remove_notify_handler(priv->adev->handle,
 				   ACPI_DEVICE_NOTIFY,
 				   ideapad_acpi_notify);
-#endif
 
 notification_failed:
 	ideapad_backlight_exit(priv);
@@ -1773,10 +1896,7 @@ static int ideapad_acpi_remove(struct platform_device *pdev)
 	struct ideapad_private *priv = dev_get_drvdata(&pdev->dev);
 	int i;
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-	if (priv->fnesc_guid)
-		wmi_remove_notify_handler(priv->fnesc_guid);
-#endif
+	ideapad_shared_exit(priv);
 
 	acpi_remove_notify_handler(priv->adev->handle,
 				   ACPI_DEVICE_NOTIFY,
@@ -1828,7 +1948,30 @@ static struct platform_driver ideapad_acpi_driver = {
 	},
 };
 
-module_platform_driver(ideapad_acpi_driver);
+static int __init ideapad_laptop_init(void)
+{
+	int err;
+
+	err = ideapad_wmi_driver_register();
+	if (err)
+		return err;
+
+	err = platform_driver_register(&ideapad_acpi_driver);
+	if (err) {
+		ideapad_wmi_driver_unregister();
+		return err;
+	}
+
+	return 0;
+}
+module_init(ideapad_laptop_init)
+
+static void __exit ideapad_laptop_exit(void)
+{
+	ideapad_wmi_driver_unregister();
+	platform_driver_unregister(&ideapad_acpi_driver);
+}
+module_exit(ideapad_laptop_exit)
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("IdeaPad ACPI Extras");
-- 
2.35.1



