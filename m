Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F8113F865
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbgAPTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgAPQym (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 357D0205F4;
        Thu, 16 Jan 2020 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193681;
        bh=2+gpWsmpb5DF4ayCzhFM7rLPmr+bUI4pfCSdEsSq01U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYggzVXXCODFuSTZWZYU5+bxpeO6VaNDduKGM30USXdWBfawyJU0JgGR3YdxZBeKW
         Mm4GTk1Cj/pSbyYFv/wbRmYAomlUQY/n9ElWjevunkZ491Fd3XleQMglM6EwX1PINO
         P3JroINuGe3dYoo2ICls2iQAcmQ8pO1smhTQp+gk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 205/205] phy/rockchip: inno-hdmi: round clock rate down to closest 1000 Hz
Date:   Thu, 16 Jan 2020 11:43:00 -0500
Message-Id: <20200116164300.6705-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 4f510aa10468954b1da4e94689c38ac6ea8d3627 ]

Commit 287422a95fe2 ("drm/rockchip: Round up _before_ giving to the clock framework")
changed what rate clk_round_rate() is called with, an additional 999 Hz
added to the requsted mode clock. This has caused a regression on RK3328
and presumably also on RK3228 because the inno-hdmi-phy clock requires an
exact match of the requested rate in the pre pll config table.

When an exact match is not found the parent clock rate (24MHz) is returned
to the clk_round_rate() caller. This cause wrong pixel clock to be used and
result in no-signal when configuring a mode on RK3328.

Fix this by rounding the rate down to closest 1000 Hz in round_rate func,
this allows an exact match to be found in pre pll config table.

Fixes: 287422a95fe2 ("drm/rockchip: Round up _before_ giving to the clock framework")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-hdmi.c b/drivers/phy/rockchip/phy-rockchip-inno-hdmi.c
index 2b97fb1185a0..9ca20c947283 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-hdmi.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-hdmi.c
@@ -603,6 +603,8 @@ static long inno_hdmi_phy_rk3228_clk_round_rate(struct clk_hw *hw,
 {
 	const struct pre_pll_config *cfg = pre_pll_cfg_table;
 
+	rate = (rate / 1000) * 1000;
+
 	for (; cfg->pixclock != 0; cfg++)
 		if (cfg->pixclock == rate && !cfg->fracdiv)
 			break;
@@ -755,6 +757,8 @@ static long inno_hdmi_phy_rk3328_clk_round_rate(struct clk_hw *hw,
 {
 	const struct pre_pll_config *cfg = pre_pll_cfg_table;
 
+	rate = (rate / 1000) * 1000;
+
 	for (; cfg->pixclock != 0; cfg++)
 		if (cfg->pixclock == rate)
 			break;
-- 
2.20.1

