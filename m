Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7715463DF2B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiK3Soo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiK3SoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83BD99F67
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F4F61D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F00C433D6;
        Wed, 30 Nov 2022 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833851;
        bh=tRv5WwdaxG97eI2KuLkHEG9zd4M/A14LtI9mB7OzuRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vscDPfkGgsHGw/O32/8WitoCzGUlSNIwa1F0aB1a7tT3fnx/0uKxcOThCq6zzgO5P
         qfPyB0yqHi0lLDbj4ABwb96+GGBwEYDQjJzSE4Sa0Rxwt2HckL4jCJx8k0cGTUpPP7
         kPFayWkhrOk6cmXMjBGhTcldKnxNgF4r8gOAZBJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Manyi Li <limanyi@uniontech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 020/289] platform/x86: ideapad-laptop: Disable touchpad_switch
Date:   Wed, 30 Nov 2022 19:20:05 +0100
Message-Id: <20221130180544.590580781@linuxfoundation.org>
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
index abd0c81d62c4..33b3dfdd1b08 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1533,6 +1533,24 @@ static const struct dmi_system_id hw_rfkill_list[] = {
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
@@ -1541,7 +1559,12 @@ static void ideapad_check_features(struct ideapad_private *priv)
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



