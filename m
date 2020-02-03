Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894F5150D1D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgBCQei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730820AbgBCQei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:38 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73272051A;
        Mon,  3 Feb 2020 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747677;
        bh=WYbTuLuNxFsPNJfXjUbDq6+/+krcm/RTvzoJb9T8RR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aK9tCDZz6kpHnkXntbx9NdfmFqVLCpwycbxgNnUleZpfiODE3AVTugARTDZ2u/pz3
         L3mkCPL++XfyY0E7uaWdDe+9pVJSwecsf/VRO7KoDMgYWXoYycjFzVAAAWwx6ZSMmm
         I+eI9iBKYpYK7kMrw4KG35blCgif0dEVSiVIveB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunhao Tian <18373444@buaa.edu.cn>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/90] clk: sunxi-ng: v3s: Fix incorrect number of hw_clks.
Date:   Mon,  3 Feb 2020 16:19:27 +0000
Message-Id: <20200203161920.818308603@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



