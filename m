Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA326309EA
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbiKSCUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiKSCUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:20:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6BDB961D;
        Fri, 18 Nov 2022 18:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEF60B82676;
        Sat, 19 Nov 2022 02:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AC2C433C1;
        Sat, 19 Nov 2022 02:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824062;
        bh=oEHHPQjWGKDVFIqs5Jk35mpXkqk4aH9OREDQAM6iBzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ui0oRITO06vqKlZvOPUmhmUAhwcvP0WBPcbvCAw/tDDyttbsf84DU5GkB7/XTz202
         i/JduY+jLssLueSgwp0sq1tIVO9mIZ/g3qOk2DfiJWM81b9yOEn2czkrEH3dB0NDMo
         ba2gwpbvmdDfYX+j+ILpuQj0Lp7/2VCk57cgVsPWyhl57LwBptcrbXm4ZKjS/5+rEC
         jHTPdnDo/iCHQfoCajf+n13easBh4+bnyoPH0mOAmfAmtQ9c15zO+ilP4FLoJU94gK
         AJtkUmNlZ95P74lyRpX/y6hhRbqOzVH7N6vXrAOymVbu7PtWXr9SQrfq1Jq97s4dms
         bJfjiQExdk0Eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manyi Li <limanyi@uniontech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ike.pan@canonical.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/27] platform/x86: ideapad-laptop: Disable touchpad_switch
Date:   Fri, 18 Nov 2022 21:13:39 -0500
Message-Id: <20221119021352.1774592-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
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

From: Manyi Li <limanyi@uniontech.com>

[ Upstream commit a231224a601c1924b9df620281ad04472900d75f ]

Ideapads for "Lenovo Yoga 3 Pro 1370" and "ZhaoYang K4e-IML" do not
use EC to switch touchpad.

Reading VPCCMD_R_TOUCHPAD will return zero thus touchpad may be blocked
unexpectedly.

Signed-off-by: Manyi Li <limanyi@uniontech.com>
Link: https://lore.kernel.org/r/20221018095323.14591-1-limanyi@uniontech.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index e7a1299e3776..ab4dfff2174b 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1499,6 +1499,24 @@ static const struct dmi_system_id hw_rfkill_list[] = {
 	{}
 };
 
+static const struct dmi_system_id no_touchpad_switch_list[] = {
+	{
+	.ident = "Lenovo Yoga 3 Pro 1370",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo YOGA 3"),
+		},
+	},
+	{
+	.ident = "ZhaoYang K4e-IML",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ZhaoYang K4e-IML"),
+		},
+	},
+	{}
+};
+
 static void ideapad_check_features(struct ideapad_private *priv)
 {
 	acpi_handle handle = priv->adev->handle;
@@ -1507,7 +1525,12 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
-	priv->features.touchpad_ctrl_via_ec = !acpi_dev_present("ELAN0634", NULL, -1);
+	if (acpi_dev_present("ELAN0634", NULL, -1))
+		priv->features.touchpad_ctrl_via_ec = 0;
+	else if (dmi_check_system(no_touchpad_switch_list))
+		priv->features.touchpad_ctrl_via_ec = 0;
+	else
+		priv->features.touchpad_ctrl_via_ec = 1;
 
 	if (!read_ec_data(handle, VPCCMD_R_FAN, &val))
 		priv->features.fan_mode = true;
-- 
2.35.1

