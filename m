Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196F9328D43
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241098AbhCATIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240742AbhCATET (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E948065033;
        Mon,  1 Mar 2021 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618932;
        bh=KjGAiiTXy4QwyJGy9jZ4jl6VkPznzwEy85JopPo+PxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xn/Dh3OTVPmMwXjyYhBaK+cOy6WuYbjOs8X3ks/C/H18ktz8gvwREluqKnZYk2LGw
         /kWBEJBi0HaESHhxY9qU9UpvrehAtXiI51lVr4dZihLOV2bTIX1AXl5P+PiqL13DQY
         zZHeHAQe2RdPwqezTxScwvy1dyTUcw+ffHFaAATg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/663] clk: sunxi-ng: h6: Fix CEC clock
Date:   Mon,  1 Mar 2021 17:08:39 +0100
Message-Id: <20210301161155.224305549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 756650820abd4770c4200763505b634a3c04e05e ]

The CEC clock on the H6 SoC is a bit special, since it uses a fixed
pre-dividier for one source clock (the PLL), but conveys the other clock
(32K OSC) directly.
We are using a fixed predivider array for that, but fail to use the right
flag to actually activate that.

Fixes: 524353ea480b ("clk: sunxi-ng: add support for the Allwinner H6 CCU")
Reported-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210106143246.11255-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
index f2497d0a4683a..a26dbbdff80d1 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
@@ -682,7 +682,7 @@ static struct ccu_mux hdmi_cec_clk = {
 
 	.common		= {
 		.reg		= 0xb10,
-		.features	= CCU_FEATURE_VARIABLE_PREDIV,
+		.features	= CCU_FEATURE_FIXED_PREDIV,
 		.hw.init	= CLK_HW_INIT_PARENTS("hdmi-cec",
 						      hdmi_cec_parents,
 						      &ccu_mux_ops,
-- 
2.27.0



