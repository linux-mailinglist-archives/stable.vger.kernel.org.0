Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8472F65D824
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbjADQLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbjADQKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B81212
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D2F161798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C097C433EF;
        Wed,  4 Jan 2023 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848647;
        bh=7Ic5L3//M9u72KLff0KLD8g4TBXzmhhZTvNXtepJ0JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMcBDbE2OKhOiHF1m3rkhU/y136UZGje9yA3A8btrHMYtB/6YD5bhPMidr9ydBVRM
         oF8W4kyl7mXrE32yLE73IXQ94plwPWPV+SBj3BWUyQb/uqLy+LIXNfmJm9fOVtOhnT
         KXK/q4wQbD/i9m6yWh0TSxIQbRwVT8JWUrLvb2dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/207] platform/x86: ideapad-laptop: Do not send KEY_TOUCHPAD* events on probe / resume
Date:   Wed,  4 Jan 2023 17:05:07 +0100
Message-Id: <20230104160513.474300639@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f4dd8c44bb831ff885680bc77111fa39c193a93f ]

The sending of KEY_TOUCHPAD* events is causing spurious touchpad OSD
showing on resume.

Disable the sending of events on probe / resume to fix this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20221117110244.67811-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index dcb3a82024da..eb0b1ec32c13 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1487,7 +1487,7 @@ static void ideapad_kbd_bl_exit(struct ideapad_private *priv)
 /*
  * module init/exit
  */
-static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
+static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_events)
 {
 	unsigned long value;
 	unsigned char param;
@@ -1508,8 +1508,11 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
 	 * KEY_TOUCHPAD_ON to not to get out of sync with LED
 	 */
 	i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
-	ideapad_input_report(priv, value ? 67 : 66);
-	sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+
+	if (send_events) {
+		ideapad_input_report(priv, value ? 67 : 66);
+		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+	}
 }
 
 static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
@@ -1550,7 +1553,7 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 			ideapad_sync_rfk_state(priv);
 			break;
 		case 5:
-			ideapad_sync_touchpad_state(priv);
+			ideapad_sync_touchpad_state(priv, true);
 			break;
 		case 4:
 			ideapad_backlight_notify_brightness(priv);
@@ -1840,7 +1843,7 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 			ideapad_register_rfkill(priv, i);
 
 	ideapad_sync_rfk_state(priv);
-	ideapad_sync_touchpad_state(priv);
+	ideapad_sync_touchpad_state(priv, false);
 
 	err = ideapad_dytc_profile_init(priv);
 	if (err) {
@@ -1925,7 +1928,7 @@ static int ideapad_acpi_resume(struct device *dev)
 	struct ideapad_private *priv = dev_get_drvdata(dev);
 
 	ideapad_sync_rfk_state(priv);
-	ideapad_sync_touchpad_state(priv);
+	ideapad_sync_touchpad_state(priv, false);
 
 	if (priv->dytc)
 		dytc_profile_refresh(priv);
-- 
2.35.1



