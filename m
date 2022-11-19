Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8263B6309B4
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiKSCQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiKSCQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:16:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE48B87F;
        Fri, 18 Nov 2022 18:13:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D75ACE222D;
        Sat, 19 Nov 2022 02:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E4AC433B5;
        Sat, 19 Nov 2022 02:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823986;
        bh=lr5xJGzUjP8NLAV/SJAWmf1Bjx0GqUsuY3JFGcUnmbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dW87T4iicceihr3GFAuTtZkuLP9/C36OTERdOjHknJtGekchVsCtvOq3ZRgYJlwPf
         JutxgRLWBophT18+V2Q0KNAWBlSWkvfQc/jRw8sV7ovIrZwi1y1extOABDl1Frm7Jk
         Pdd0NtL6C8FeW5RJ95Ge138pV+Xf0tN06ghy4rI7sZeKBrMQejd2qi1SR0WyWUzjuu
         Y5sxT+GmNeYUq5hFXYEgx5wViWFC+D6HEjrMPUNjs0aG90jTf3IEltc2QKnn4tv0BY
         PfSkhMUbIZ/gx03DgxfsZl79MNYtd6FkX8xpVcxQqpYiWpdALrxxqZkKJSiTh2P7Gl
         na1q9uI/EGqoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Su <steve.su@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, qingqing.zhuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 36/44] drm/amd/display: Fix gpio port mapping issue
Date:   Fri, 18 Nov 2022 21:11:16 -0500
Message-Id: <20221119021124.1773699-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Steve Su <steve.su@amd.com>

[ Upstream commit c0b2753f5db281b07013899c79b5f06a614055f9 ]

[Why]
1. Port of gpio has different mapping.

[How]
1. Add a dummy entry in mapping table.
2. Fix incorrect mask bit field access.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Steve Su <steve.su@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/gpio/dcn32/hw_factory_dcn32.c   | 14 ++++++++++++++
 drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c       |  9 ++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
index d635b73af46f..0ea52ba5ac82 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
@@ -107,6 +107,13 @@ static const struct ddc_registers ddc_data_regs_dcn[] = {
 	ddc_data_regs_dcn2(3),
 	ddc_data_regs_dcn2(4),
 	ddc_data_regs_dcn2(5),
+	{
+		// add a dummy entry for cases no such port
+		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
+		.ddc_setup = 0,
+		.phy_aux_cntl = 0,
+		.dc_gpio_aux_ctrl_5 = 0
+	},
 	{
 			DDC_GPIO_VGA_REG_LIST(DATA),
 			.ddc_setup = 0,
@@ -121,6 +128,13 @@ static const struct ddc_registers ddc_clk_regs_dcn[] = {
 	ddc_clk_regs_dcn2(3),
 	ddc_clk_regs_dcn2(4),
 	ddc_clk_regs_dcn2(5),
+	{
+		// add a dummy entry for cases no such port
+		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
+		.ddc_setup = 0,
+		.phy_aux_cntl = 0,
+		.dc_gpio_aux_ctrl_5 = 0
+	},
 	{
 			DDC_GPIO_VGA_REG_LIST(CLK),
 			.ddc_setup = 0,
diff --git a/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c b/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
index 6fd38cdd68c0..525bc8881950 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c
@@ -94,11 +94,14 @@ static enum gpio_result set_config(
 		 * is required for detection of AUX mode */
 		if (hw_gpio->base.en != GPIO_DDC_LINE_VIP_PAD) {
 			if (!ddc_data_pd_en || !ddc_clk_pd_en) {
-
-				REG_SET_2(gpio.MASK_reg, regval,
+				if (hw_gpio->base.en == GPIO_DDC_LINE_DDC_VGA) {
+					// bit 4 of mask has different usage in some cases
+					REG_SET(gpio.MASK_reg, regval, DC_GPIO_DDC1DATA_PD_EN, 1);
+				} else {
+					REG_SET_2(gpio.MASK_reg, regval,
 						DC_GPIO_DDC1DATA_PD_EN, 1,
 						DC_GPIO_DDC1CLK_PD_EN, 1);
-
+				}
 				if (config_data->type ==
 						GPIO_CONFIG_TYPE_I2C_AUX_DUAL_MODE)
 					msleep(3);
-- 
2.35.1

