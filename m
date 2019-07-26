Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC417697B
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbfGZNnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388298AbfGZNnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:43:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 350F722CD0;
        Fri, 26 Jul 2019 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148625;
        bh=BfZ4s6f42mD9uFecUPofM7fiW/0Wm5NgAwY4qFaz8CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO0AQThwYsMWCBpRsAw7mu/r1RNpI7IZeWgonKp79RD8MbmehZ2jeDUt7tEPb3kp2
         1pGoOollSRf0pCrCRnFcBkHUCawdwUQRYTxw4qN9VL7w509zJtLFVB2qu/cBT7SQFA
         KrrwfWga70SDITky8zp5dYpPT/Np4/XwsGz3iXgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JC Kuo <jckuo@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/37] clk: tegra210: fix PLLU and PLLU_OUT1
Date:   Fri, 26 Jul 2019 09:43:04 -0400
Message-Id: <20190726134332.12626-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JC Kuo <jckuo@nvidia.com>

[ Upstream commit 0d34dfbf3023cf119b83f6470692c0b10c832495 ]

Full-speed and low-speed USB devices do not work with Tegra210
platforms because of incorrect PLLU/PLLU_OUT1 clock settings.

When full-speed device is connected:
[   14.059886] usb 1-3: new full-speed USB device number 2 using tegra-xusb
[   14.196295] usb 1-3: device descriptor read/64, error -71
[   14.436311] usb 1-3: device descriptor read/64, error -71
[   14.675749] usb 1-3: new full-speed USB device number 3 using tegra-xusb
[   14.812335] usb 1-3: device descriptor read/64, error -71
[   15.052316] usb 1-3: device descriptor read/64, error -71
[   15.164799] usb usb1-port3: attempt power cycle

When low-speed device is connected:
[   37.610949] usb usb1-port3: Cannot enable. Maybe the USB cable is bad?
[   38.557376] usb usb1-port3: Cannot enable. Maybe the USB cable is bad?
[   38.564977] usb usb1-port3: attempt power cycle

This commit fixes the issue by:
 1. initializing PLLU_OUT1 before initializing XUSB_FS_SRC clock
    because PLLU_OUT1 is parent of XUSB_FS_SRC.
 2. changing PLLU post-divider to /2 (DIVP=1) according to Technical
    Reference Manual.

Fixes: e745f992cf4b ("clk: tegra: Rework pll_u")
Signed-off-by: JC Kuo <jckuo@nvidia.com>
Acked-By: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra210.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index b92867814e2d..cb2be154db3b 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -2057,9 +2057,9 @@ static struct div_nmp pllu_nmp = {
 };
 
 static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
-	{ 12000000, 480000000, 40, 1, 0, 0 },
-	{ 13000000, 480000000, 36, 1, 0, 0 }, /* actual: 468.0 MHz */
-	{ 38400000, 480000000, 25, 2, 0, 0 },
+	{ 12000000, 480000000, 40, 1, 1, 0 },
+	{ 13000000, 480000000, 36, 1, 1, 0 }, /* actual: 468.0 MHz */
+	{ 38400000, 480000000, 25, 2, 1, 0 },
 	{        0,         0,  0, 0, 0, 0 },
 };
 
@@ -2983,6 +2983,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA210_CLK_DFLL_REF, TEGRA210_CLK_PLL_P, 51000000, 1 },
 	{ TEGRA210_CLK_SBC4, TEGRA210_CLK_PLL_P, 12000000, 1 },
 	{ TEGRA210_CLK_PLL_RE_VCO, TEGRA210_CLK_CLK_MAX, 672000000, 1 },
+	{ TEGRA210_CLK_PLL_U_OUT1, TEGRA210_CLK_CLK_MAX, 48000000, 1 },
 	{ TEGRA210_CLK_XUSB_GATE, TEGRA210_CLK_CLK_MAX, 0, 1 },
 	{ TEGRA210_CLK_XUSB_SS_SRC, TEGRA210_CLK_PLL_U_480M, 120000000, 0 },
 	{ TEGRA210_CLK_XUSB_FS_SRC, TEGRA210_CLK_PLL_U_48M, 48000000, 0 },
@@ -3008,7 +3009,6 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA210_CLK_PLL_DP, TEGRA210_CLK_CLK_MAX, 270000000, 0 },
 	{ TEGRA210_CLK_SOC_THERM, TEGRA210_CLK_PLL_P, 51000000, 0 },
 	{ TEGRA210_CLK_CCLK_G, TEGRA210_CLK_CLK_MAX, 0, 1 },
-	{ TEGRA210_CLK_PLL_U_OUT1, TEGRA210_CLK_CLK_MAX, 48000000, 1 },
 	{ TEGRA210_CLK_PLL_U_OUT2, TEGRA210_CLK_CLK_MAX, 60000000, 1 },
 	/* This MUST be the last entry. */
 	{ TEGRA210_CLK_CLK_MAX, TEGRA210_CLK_CLK_MAX, 0, 0 },
-- 
2.20.1

