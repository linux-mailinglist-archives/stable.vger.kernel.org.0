Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165D465D826
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjADQLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239803AbjADQLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:11:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D9C60F1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A9C461798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D54C43398;
        Wed,  4 Jan 2023 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848653;
        bh=Vg9crEMB3C5hnVRemIeO6+xhr9ONlYlCtj/QxBXpBVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtuaRFD/BVHp2Kn4yQJqskvhUMbPx10RXCbG+wnZCDCcg/uvYHKCA00CaxYYu7lvQ
         v3CUPt5RwRDk/PSUOvXCiNfHxxqDvKxNEtt2EyptutSTLiYNYImwbHZU3oL7Z0Aa7q
         WFNTaue6NOOqcdShtMMOYe/KWxfA1ublmP+lUBFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/207] platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models
Date:   Wed,  4 Jan 2023 17:05:09 +0100
Message-Id: <20230104160513.534380357@linuxfoundation.org>
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

[ Upstream commit 5829f8a897e4f030cd2d32a930eea8954ab5dcd3 ]

On recent Ideapad models the EC does not control the touchpad at all,
so instead of sending KEY_TOUCHPAD_ON/ _OFF on touchpad toggle hotkey
events, ideapad-laptop should send KEY_TOUCHPAD_TOGGLE and let userspace
handle the toggling.

Check for this by checking if the value read from VPCCMD_R_TOUCHPAD
actually changes when receiving a touchpad-toggle hotkey event; and
if it does not change send KEY_TOUCHPAD_TOGGLE to userspace to let
userspace enable/disable the touchpad in software.

Note this also drops the priv->features.touchpad_ctrl_via_ec check from
ideapad_sync_touchpad_state() so that KEY_TOUCHPAD_TOGGLE will be send
on laptops where this is not set too. This can be safely dropped now
because the i8042_command(I8042_CMD_AUX_ENABLE/_DISABLE) call is now
guarded by its own feature flag.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20221117110244.67811-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 1d86fb988d56..9b36cfddd36f 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -134,6 +134,7 @@ struct ideapad_private {
 	struct ideapad_dytc_priv *dytc;
 	struct dentry *debug;
 	unsigned long cfg;
+	unsigned long r_touchpad_val;
 	struct {
 		bool conservation_mode    : 1;
 		bool dytc                 : 1;
@@ -650,6 +651,8 @@ static ssize_t touchpad_show(struct device *dev,
 	if (err)
 		return err;
 
+	priv->r_touchpad_val = result;
+
 	return sysfs_emit(buf, "%d\n", !!result);
 }
 
@@ -669,6 +672,8 @@ static ssize_t touchpad_store(struct device *dev,
 	if (err)
 		return err;
 
+	priv->r_touchpad_val = state;
+
 	return count;
 }
 
@@ -1159,6 +1164,7 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,  65, { KEY_PROG4 } },
 	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
+	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 128, { KEY_ESC } },
 
 	/*
@@ -1500,9 +1506,6 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	unsigned char param;
 	int ret;
 
-	if (!priv->features.touchpad_ctrl_via_ec)
-		return;
-
 	/* Without reading from EC touchpad LED doesn't switch state */
 	ret = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value);
 	if (ret)
@@ -1518,9 +1521,20 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
 
 	if (send_events) {
-		ideapad_input_report(priv, value ? 67 : 66);
-		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+		/*
+		 * On older models the EC controls the touchpad and toggles it
+		 * on/off itself, in this case we report KEY_TOUCHPAD_ON/_OFF.
+		 * If the EC did not toggle, report KEY_TOUCHPAD_TOGGLE.
+		 */
+		if (value != priv->r_touchpad_val) {
+			ideapad_input_report(priv, value ? 67 : 66);
+			sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+		} else {
+			ideapad_input_report(priv, 68);
+		}
 	}
+
+	priv->r_touchpad_val = value;
 }
 
 static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
-- 
2.35.1



