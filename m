Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16E9148A03
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbgAXOSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390445AbgAXOSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE18D20838;
        Fri, 24 Jan 2020 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875500;
        bh=WYbTuLuNxFsPNJfXjUbDq6+/+krcm/RTvzoJb9T8RR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+MTpcYjyZ16xcLCgHxE0xY/UKy5dwCMN1ZrQQyxUB1iE9/JdQldqCfLzNRbHbcDI
         iV0XLMIjHD+wOC8XHt6M45dz3mHTjl1CTB42yQEcZHAaCS0F/rtHrMXp78ZtxrQj+f
         ALDz/e0b6X4ay5pWqdo4Az22C5mG4S0QyCb44QFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunhao Tian <18373444@buaa.edu.cn>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 002/107] clk: sunxi-ng: v3s: Fix incorrect number of hw_clks.
Date:   Fri, 24 Jan 2020 09:16:32 -0500
Message-Id: <20200124141817.28793-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunhao Tian <18373444@buaa.edu.cn>

[ Upstream commit 4ff40d140e2a2060ef6051800a4a9eab07624f42 ]

The hws field of sun8i_v3s_hw_clks has only 74
members. However, the number specified by CLK_NUMBER
is 77 (= CLK_I2S0 + 1). This leads to runtime segmentation
fault that is not always reproducible.

This patch fixes the problem by specifying correct clock number.

Signed-off-by: Yunhao Tian <18373444@buaa.edu.cn>
[Maxime: Also remove the CLK_NUMBER definition]
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 4 ++--
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index 5c779eec454b6..0e36ca3bf3d52 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -618,7 +618,7 @@ static struct clk_hw_onecell_data sun8i_v3s_hw_clks = {
 		[CLK_MBUS]		= &mbus_clk.common.hw,
 		[CLK_MIPI_CSI]		= &mipi_csi_clk.common.hw,
 	},
-	.num	= CLK_NUMBER,
+	.num	= CLK_PLL_DDR1 + 1,
 };
 
 static struct clk_hw_onecell_data sun8i_v3_hw_clks = {
@@ -700,7 +700,7 @@ static struct clk_hw_onecell_data sun8i_v3_hw_clks = {
 		[CLK_MBUS]		= &mbus_clk.common.hw,
 		[CLK_MIPI_CSI]		= &mipi_csi_clk.common.hw,
 	},
-	.num	= CLK_NUMBER,
+	.num	= CLK_I2S0 + 1,
 };
 
 static struct ccu_reset_map sun8i_v3s_ccu_resets[] = {
diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
index b0160d305a677..108eeeedcbf76 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
@@ -51,6 +51,4 @@
 
 #define CLK_PLL_DDR1		74
 
-#define CLK_NUMBER		(CLK_I2S0 + 1)
-
 #endif /* _CCU_SUN8I_H3_H_ */
-- 
2.20.1

