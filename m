Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B8E4F2B52
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiDEI0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiDEIUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1CAC6EE3;
        Tue,  5 Apr 2022 01:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD3B1B81B92;
        Tue,  5 Apr 2022 08:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44960C385A0;
        Tue,  5 Apr 2022 08:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146352;
        bh=9gVJ8hVCaDqgoBzxse+4FYk1575fvUVWdDSL9iRYPdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvE7rnbbSddGAFcNPIgDmAEPCKcnAf1TDqy2Zn/e2JpJqSKX5apRYnNvf9Lq585cH
         jTaA59PTKL+Zj9v5by99lhbsGlnsiajpd0eAfYaEz8rcXuFO1nkpHEZQWhxJZgPPww
         po+GC8Rd5Ck9fEXWsVqM18I/cu04y+QiXEHTrt7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0733/1126] phy: phy-brcm-usb: fixup BCM4908 support
Date:   Tue,  5 Apr 2022 09:24:40 +0200
Message-Id: <20220405070429.105106790@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 32942d33d63d27714ed16a4176e5a99547adb6e0 ]

Just like every other family BCM4908 should get its own enum value. That
is required to properly handle it in chipset conditional code.

The real change is excluding BCM4908 from the PLL reprogramming code
(see brcmusb_usb3_pll_54mhz()). I'm not sure what's the BCM4908
reference clock frequency but:
1. BCM4908 custom driver from Broadcom's SDK doesn't reprogram PLL
2. Doing that in Linux driver stopped PHY handling some USB 3.0 devices

This change makes USB 3.0 PHY recognize e.g.:
1. 04e8:6860 - Samsung Electronics Co., Ltd Galaxy series, misc. (MTP mode)
2. 1058:259f - Western Digital My Passport 259F

Broadcom's STB SoCs come with a set of SUN_TOP_CTRL_* registers that
allow reading chip family and product ids. Such a block & register is
missing on BCM4908 so this commit introduces "compatible" string
specific binding.

Fixes: 4b402fa8e0b7 ("phy: phy-brcm-usb: support PHY on the BCM4908")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220218172459.10431-1-zajec5@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init.c | 36 ++++++++++++++++++++++++
 drivers/phy/broadcom/phy-brcm-usb-init.h |  1 +
 drivers/phy/broadcom/phy-brcm-usb.c      | 11 +++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init.c b/drivers/phy/broadcom/phy-brcm-usb-init.c
index 9391ab42a12b..dd0f66288fbd 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init.c
@@ -79,6 +79,7 @@
 
 enum brcm_family_type {
 	BRCM_FAMILY_3390A0,
+	BRCM_FAMILY_4908,
 	BRCM_FAMILY_7250B0,
 	BRCM_FAMILY_7271A0,
 	BRCM_FAMILY_7364A0,
@@ -96,6 +97,7 @@ enum brcm_family_type {
 
 static const char *family_names[BRCM_FAMILY_COUNT] = {
 	USB_BRCM_FAMILY(3390A0),
+	USB_BRCM_FAMILY(4908),
 	USB_BRCM_FAMILY(7250B0),
 	USB_BRCM_FAMILY(7271A0),
 	USB_BRCM_FAMILY(7364A0),
@@ -203,6 +205,27 @@ usb_reg_bits_map_table[BRCM_FAMILY_COUNT][USB_CTRL_SELECTOR_COUNT] = {
 		USB_CTRL_USB_PM_USB20_HC_RESETB_VAR_MASK,
 		ENDIAN_SETTINGS, /* USB_CTRL_SETUP ENDIAN bits */
 	},
+	/* 4908 */
+	[BRCM_FAMILY_4908] = {
+		0, /* USB_CTRL_SETUP_SCB1_EN_MASK */
+		0, /* USB_CTRL_SETUP_SCB2_EN_MASK */
+		0, /* USB_CTRL_SETUP_SS_EHCI64BIT_EN_MASK */
+		0, /* USB_CTRL_SETUP_STRAP_IPP_SEL_MASK */
+		0, /* USB_CTRL_SETUP_OC3_DISABLE_MASK */
+		0, /* USB_CTRL_PLL_CTL_PLL_IDDQ_PWRDN_MASK */
+		0, /* USB_CTRL_USB_PM_BDC_SOFT_RESETB_MASK */
+		USB_CTRL_USB_PM_XHC_SOFT_RESETB_MASK,
+		USB_CTRL_USB_PM_USB_PWRDN_MASK,
+		0, /* USB_CTRL_USB30_CTL1_XHC_SOFT_RESETB_MASK */
+		0, /* USB_CTRL_USB30_CTL1_USB3_IOC_MASK */
+		0, /* USB_CTRL_USB30_CTL1_USB3_IPP_MASK */
+		0, /* USB_CTRL_USB_DEVICE_CTL1_PORT_MODE_MASK */
+		0, /* USB_CTRL_USB_PM_SOFT_RESET_MASK */
+		0, /* USB_CTRL_SETUP_CC_DRD_MODE_ENABLE_MASK */
+		0, /* USB_CTRL_SETUP_STRAP_CC_DRD_MODE_ENABLE_SEL_MASK */
+		0, /* USB_CTRL_USB_PM_USB20_HC_RESETB_VAR_MASK */
+		0, /* USB_CTRL_SETUP ENDIAN bits */
+	},
 	/* 7250b0 */
 	[BRCM_FAMILY_7250B0] = {
 		USB_CTRL_SETUP_SCB1_EN_MASK,
@@ -559,6 +582,7 @@ static void brcmusb_usb3_pll_54mhz(struct brcm_usb_init_params *params)
 	 */
 	switch (params->selected_family) {
 	case BRCM_FAMILY_3390A0:
+	case BRCM_FAMILY_4908:
 	case BRCM_FAMILY_7250B0:
 	case BRCM_FAMILY_7366C0:
 	case BRCM_FAMILY_74371A0:
@@ -1004,6 +1028,18 @@ static const struct brcm_usb_init_ops bcm7445_ops = {
 	.set_dual_select = usb_set_dual_select,
 };
 
+void brcm_usb_dvr_init_4908(struct brcm_usb_init_params *params)
+{
+	int fam;
+
+	fam = BRCM_FAMILY_4908;
+	params->selected_family = fam;
+	params->usb_reg_bits_map =
+		&usb_reg_bits_map_table[fam][0];
+	params->family_name = family_names[fam];
+	params->ops = &bcm7445_ops;
+}
+
 void brcm_usb_dvr_init_7445(struct brcm_usb_init_params *params)
 {
 	int fam;
diff --git a/drivers/phy/broadcom/phy-brcm-usb-init.h b/drivers/phy/broadcom/phy-brcm-usb-init.h
index a39f30fa2e99..1ccb5ddab865 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init.h
+++ b/drivers/phy/broadcom/phy-brcm-usb-init.h
@@ -64,6 +64,7 @@ struct  brcm_usb_init_params {
 	bool suspend_with_clocks;
 };
 
+void brcm_usb_dvr_init_4908(struct brcm_usb_init_params *params);
 void brcm_usb_dvr_init_7445(struct brcm_usb_init_params *params);
 void brcm_usb_dvr_init_7216(struct brcm_usb_init_params *params);
 void brcm_usb_dvr_init_7211b0(struct brcm_usb_init_params *params);
diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index 0f1deb6e0eab..2cb3779fcdf8 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -283,6 +283,15 @@ static const struct attribute_group brcm_usb_phy_group = {
 	.attrs = brcm_usb_phy_attrs,
 };
 
+static const struct match_chip_info chip_info_4908 = {
+	.init_func = &brcm_usb_dvr_init_4908,
+	.required_regs = {
+		BRCM_REGS_CTRL,
+		BRCM_REGS_XHCI_EC,
+		-1,
+	},
+};
+
 static const struct match_chip_info chip_info_7216 = {
 	.init_func = &brcm_usb_dvr_init_7216,
 	.required_regs = {
@@ -318,7 +327,7 @@ static const struct match_chip_info chip_info_7445 = {
 static const struct of_device_id brcm_usb_dt_ids[] = {
 	{
 		.compatible = "brcm,bcm4908-usb-phy",
-		.data = &chip_info_7445,
+		.data = &chip_info_4908,
 	},
 	{
 		.compatible = "brcm,bcm7216-usb-phy",
-- 
2.34.1



