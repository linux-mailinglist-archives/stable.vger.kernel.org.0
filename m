Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772E5635DDC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiKWMse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbiKWMrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:47:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169AC720AD;
        Wed, 23 Nov 2022 04:43:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD3A1B81F31;
        Wed, 23 Nov 2022 12:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E5EC433D7;
        Wed, 23 Nov 2022 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207402;
        bh=TMTOGyAMBT7FkcieUrUvsVMsN4GRwGti/n6MG7GcGKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emus4FJ1KBFdr1dFwCM7872hRM1PGRP6fedm1q1rIEjGlE+avZILIDOcrK/zmXtPa
         dOWvaWhVXyqJ3fxoA10D00evQ7qibQ5O2XJ6YfO0AWu8Cb6Z5mZCyVgdUZLkrgDAY+
         5107mfrNl9FELiHRJmRsX8WSuMFGVNsdlmQpSMdoqR3pt3+REUcRrb/qfnWr6gOL5i
         TutDZnojd5UI/CyEdkjJAEYBhxzF3k1qyS4NFV7ssaywbb1E2ui3aHHJQOOGx6vaIT
         jQnQQTZtZDXOLq5oX4aXssJ/FQYO3NEM6ldsTvr8+9dmRAOKGdmMTtAx6xRIq5uk3N
         R3RotZYerIGRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnav Rawat <arnavr3@illinois.edu>, Meng Dong <whenov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ike.pan@canonical.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/31] platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops
Date:   Wed, 23 Nov 2022 07:42:22 -0500
Message-Id: <20221123124234.265396-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e7a1299e3776..609ce8f0e0bf 100644
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
@@ -1467,6 +1468,9 @@ static void ideapad_wmi_notify(u32 value, void *context)
 		ideapad_input_report(priv, value);
 		break;
 	case 208:
+		if (!priv->features.set_fn_lock_led)
+			break;
+
 		if (!eval_hals(priv->adev->handle, &result)) {
 			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
 
@@ -1480,6 +1484,18 @@ static void ideapad_wmi_notify(u32 value, void *context)
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
@@ -1504,6 +1520,7 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	acpi_handle handle = priv->adev->handle;
 	unsigned long val;
 
+	priv->features.set_fn_lock_led = dmi_check_system(set_fn_lock_led_list);
 	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
-- 
2.35.1

