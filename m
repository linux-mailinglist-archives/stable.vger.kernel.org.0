Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB7E63E027
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiK3SyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiK3SyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1715A4E437
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD741B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35436C433D7;
        Wed, 30 Nov 2022 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834440;
        bh=rArcBhuX1KGrSNr0zkORcCBhd3wOi8Bq2U2P2ww9gDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYjNu5/IFuAsAimd/tikgjfOmtG5kfJ3SFoJi/l7mNkwVfGG2VD6csEbwPMAl/J2m
         PyeUsn7b3LhHykIWgGW7NESddQSr+u0iMDEviqf4sp5HwDbDWOiOX4AAok0WWg3qnE
         dI2s2Axb8kFKoTXv7psqKYS4jJReTdTiArMea2/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Meng Dong <whenov@gmail.com>,
        Arnav Rawat <arnavr3@illinois.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 254/289] platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops
Date:   Wed, 30 Nov 2022 19:23:59 +0100
Message-Id: <20221130180549.862277037@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Arnav Rawat <arnavr3@illinois.edu>

[ Upstream commit 81a5603a0f50fd7cf17ff21d106052215eaf2028 ]

Commit 3ae86d2d4704 ("platform/x86: ideapad-laptop: Fix Legion 5 Fn lock
LED") uses the WMI event-id for the fn-lock event on some Legion 5 laptops
to manually toggle the fn-lock LED because the EC does not do it itself.
However, the same WMI ID is also sent on some Yoga laptops. Here, setting
the fn-lock state is not valid behavior, and causes the EC to spam
interrupts until the laptop is rebooted.

Add a set_fn_lock_led_list[] DMI-id list and only enable the workaround to
manually set the LED on models on this list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212671
Cc: Meng Dong <whenov@gmail.com>
Signed-off-by: Arnav Rawat <arnavr3@illinois.edu>
Link: https://lore.kernel.org/r/12093851.O9o76ZdvQC@fedora
[hdegoede@redhat.com: Check DMI-id list only once and store the result]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 33b3dfdd1b08..6c460cdc05bb 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -136,6 +136,7 @@ struct ideapad_private {
 		bool dytc                 : 1;
 		bool fan_mode             : 1;
 		bool fn_lock              : 1;
+		bool set_fn_lock_led      : 1;
 		bool hw_rfkill_switch     : 1;
 		bool kbd_bl               : 1;
 		bool touchpad_ctrl_via_ec : 1;
@@ -1501,6 +1502,9 @@ static void ideapad_wmi_notify(u32 value, void *context)
 		ideapad_input_report(priv, value);
 		break;
 	case 208:
+		if (!priv->features.set_fn_lock_led)
+			break;
+
 		if (!eval_hals(priv->adev->handle, &result)) {
 			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
 
@@ -1514,6 +1518,18 @@ static void ideapad_wmi_notify(u32 value, void *context)
 }
 #endif
 
+/* On some models we need to call exec_sals(SALS_FNLOCK_ON/OFF) to set the LED */
+static const struct dmi_system_id set_fn_lock_led_list[] = {
+	{
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=212671 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion R7000P2020H"),
+		}
+	},
+	{}
+};
+
 /*
  * Some ideapads have a hardware rfkill switch, but most do not have one.
  * Reading VPCCMD_R_RF always results in 0 on models without a hardware rfkill,
@@ -1556,6 +1572,7 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	acpi_handle handle = priv->adev->handle;
 	unsigned long val;
 
+	priv->features.set_fn_lock_led = dmi_check_system(set_fn_lock_led_list);
 	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
-- 
2.35.1



