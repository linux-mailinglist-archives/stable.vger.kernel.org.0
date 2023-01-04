Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5565D827
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjADQLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbjADQKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FD8C25
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369DE6178F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AA2C433F0;
        Wed,  4 Jan 2023 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848650;
        bh=p60OPKbFTEb4l2xA/lCBTXtOU9ZdVOKWJFyuH+oZIeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO5FAnD1BydD3fU914DI97EKmNcFkA3XZj0kY5lrQ8lixGthP0TLVS0PrYmi+Gu+a
         GbrZm3piMqbL7kj1ePDK63zlFtClXX2GOpJ5u9W76XkrgulC1UjJcXqT4PbyOLtmDm
         Pms4WPls0xVn6VSbFavx9ODIocwr7XN/PfcQ+dRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/207] platform/x86: ideapad-laptop: Only toggle ps2 aux port on/off on select models
Date:   Wed,  4 Jan 2023 17:05:08 +0100
Message-Id: <20230104160513.504273943@linuxfoundation.org>
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

[ Upstream commit c69e7d843d2c34b80b8731a5dc57c34ea04a3edf ]

Recently there have been multiple patches to disable the ideapad-laptop's
touchpad control code, because it is causing issues on various laptops:

Commit d69cd7eea93e ("platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634")
Commit a231224a601c ("platform/x86: ideapad-laptop: Disable touchpad_switch")

The turning on/off of the ps2 aux port was added specifically for
the IdeaPad Z570, where the EC does toggle the touchpad on/off LED and
toggles the value returned by reading VPCCMD_R_TOUCHPAD, but it does not
actually turn on/off the touchpad.

The ideapad-laptop code really should not be messing with the i8042
controller on all devices just for this special case.

Add a new ctrl_ps2_aux_port flag set based on a DMI based allow-list
for devices which need this workaround, populating it with just
the Ideapad Z570 for now.

This also adds a module parameter so that this behavior can easily
be enabled on other models which may need it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20221117110244.67811-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 29 ++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index eb0b1ec32c13..1d86fb988d56 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -143,6 +143,7 @@ struct ideapad_private {
 		bool hw_rfkill_switch     : 1;
 		bool kbd_bl               : 1;
 		bool touchpad_ctrl_via_ec : 1;
+		bool ctrl_ps2_aux_port    : 1;
 		bool usb_charging         : 1;
 	} features;
 	struct {
@@ -174,6 +175,12 @@ MODULE_PARM_DESC(set_fn_lock_led,
 	"Enable driver based updates of the fn-lock LED on fn-lock changes. "
 	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
 
+static bool ctrl_ps2_aux_port;
+module_param(ctrl_ps2_aux_port, bool, 0444);
+MODULE_PARM_DESC(ctrl_ps2_aux_port,
+	"Enable driver based PS/2 aux port en-/dis-abling on touchpad on/off toggle. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
 /*
  * shared data
  */
@@ -1507,7 +1514,8 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
 	 * KEY_TOUCHPAD_ON to not to get out of sync with LED
 	 */
-	i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
+	if (priv->features.ctrl_ps2_aux_port)
+		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
 
 	if (send_events) {
 		ideapad_input_report(priv, value ? 67 : 66);
@@ -1615,6 +1623,23 @@ static const struct dmi_system_id hw_rfkill_list[] = {
 	{}
 };
 
+/*
+ * On some models the EC toggles the touchpad muted LED on touchpad toggle
+ * hotkey presses, but the EC does not actually disable the touchpad itself.
+ * On these models the driver needs to explicitly enable/disable the i8042
+ * (PS/2) aux port.
+ */
+static const struct dmi_system_id ctrl_ps2_aux_port_list[] = {
+	{
+	/* Lenovo Ideapad Z570 */
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
+		},
+	},
+	{}
+};
+
 static const struct dmi_system_id no_touchpad_switch_list[] = {
 	{
 	.ident = "Lenovo Yoga 3 Pro 1370",
@@ -1642,6 +1667,8 @@ static void ideapad_check_features(struct ideapad_private *priv)
 		set_fn_lock_led || dmi_check_system(set_fn_lock_led_list);
 	priv->features.hw_rfkill_switch =
 		hw_rfkill_switch || dmi_check_system(hw_rfkill_list);
+	priv->features.ctrl_ps2_aux_port =
+		ctrl_ps2_aux_port || dmi_check_system(ctrl_ps2_aux_port_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
 	if (acpi_dev_present("ELAN0634", NULL, -1))
-- 
2.35.1



