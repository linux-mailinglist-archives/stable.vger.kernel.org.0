Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5942635D81
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiKWMpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiKWMoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:44:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9246F35C;
        Wed, 23 Nov 2022 04:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED03461C81;
        Wed, 23 Nov 2022 12:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A87C433D6;
        Wed, 23 Nov 2022 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207336;
        bh=Wtmd8Hvl39rSXic1Y4jzR3w/qDTzPtU/PWHE7K4Yt6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SW/PATCsQA7h8k4K40n63zL/SCQv1CkEJV2RkF2cfVnyfuLOcruNf6sxDSg87HVxw
         FdbK5iMT01Kaw9gWKOg2BK4beVaFCLoGgB0E8tZBPVnLPzUHpXYeHXy/sCLEQ0WPLm
         +wpRV6ymWEc0VQRugxEsUl/iKT/8rtRPmAfmwB9sGroNXGirkGFw2/7JDDj1KPWqZP
         CF2s7vtLhNSySUUijOvXAhv1Np24Msk/AnE0cTBM7BkDfymnF0qeD1XwmudTuqB0RV
         kAAtzR7JzOZgOXWtv3D8JX3qbPP/MrX2ms/5BjUF8kpDu+IERmv17WnhuexIf9g4WW
         7ZttF725eIRrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ike.pan@canonical.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 33/44] platform/x86: ideapad-laptop: Add module parameters to match DMI quirk tables
Date:   Wed, 23 Nov 2022 07:40:42 -0500
Message-Id: <20221123124057.264822-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b44fd994e45112b58b6c1dec4451d9a925784589 ]

Add module parameters to allow setting the hw_rfkill_switch and
set_fn_lock_led feature flags for testing these on laptops which are not
on the DMI-id based allow lists for these 2 flags.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221115193400.376159-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index e789d4f56b40..9ab3cc02ad1b 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -155,7 +155,21 @@ MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
 
 static bool allow_v4_dytc;
 module_param(allow_v4_dytc, bool, 0444);
-MODULE_PARM_DESC(allow_v4_dytc, "Enable DYTC version 4 platform-profile support.");
+MODULE_PARM_DESC(allow_v4_dytc,
+	"Enable DYTC version 4 platform-profile support. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
+static bool hw_rfkill_switch;
+module_param(hw_rfkill_switch, bool, 0444);
+MODULE_PARM_DESC(hw_rfkill_switch,
+	"Enable rfkill support for laptops with a hw on/off wifi switch/slider. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
+static bool set_fn_lock_led;
+module_param(set_fn_lock_led, bool, 0444);
+MODULE_PARM_DESC(set_fn_lock_led,
+	"Enable driver based updates of the fn-lock LED on fn-lock changes. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
 
 /*
  * ACPI Helpers
@@ -1554,8 +1568,10 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	acpi_handle handle = priv->adev->handle;
 	unsigned long val;
 
-	priv->features.set_fn_lock_led = dmi_check_system(set_fn_lock_led_list);
-	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
+	priv->features.set_fn_lock_led =
+		set_fn_lock_led || dmi_check_system(set_fn_lock_led_list);
+	priv->features.hw_rfkill_switch =
+		hw_rfkill_switch || dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
 	priv->features.touchpad_ctrl_via_ec = !acpi_dev_present("ELAN0634", NULL, -1);
-- 
2.35.1

