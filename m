Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD4451F4B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355916AbhKPAio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344057AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D8C633B9;
        Mon, 15 Nov 2021 18:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002253;
        bh=MiKAFx3DtbtzBKVuyf7U8m5qGcjyBxadkSSOMvslgeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4w2Br3n4pEKRX3Ijv0gA2hWzqID51ttfViiJJzGkwTIoYGmhJd72Bg23PN9TGRzY
         kTnmneK+oth8btv5OBcMQqgFkvaaYrtUKqDp6UFu5qlfEntFV6kfowKGNYD3migVew
         67LL/inG8Y0kgp9CyxMbFEIKu2TfqnOpqyBWti30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jessica Zhang <jesszhan@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/917] drm/msm/dsi: fix wrong type in msm_dsi_host
Date:   Mon, 15 Nov 2021 17:59:52 +0100
Message-Id: <20211115165445.625429263@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Zhang <jesszhan@codeaurora.org>

[ Upstream commit 409af447c2a0a6e08ba190993a1153c91d3b11bd ]

Change byte_clk_rate, pixel_clk_rate, esc_clk_rate, and src_clk_rate
from u32 to unsigned long, since clk_get_rate() returns an unsigned long.

Fixes: a6bcddbc2ee1 ("drm/msm: dsi: Handle dual-channel for 6G as well")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jessica Zhang <jesszhan@codeaurora.org>
Link: https://lore.kernel.org/r/20211020183438.32263-1-jesszhan@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index bccd379bdba75..ea641151e77e7 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -115,16 +115,16 @@ struct msm_dsi_host {
 	struct clk *pixel_clk_src;
 	struct clk *byte_intf_clk;
 
-	u32 byte_clk_rate;
-	u32 pixel_clk_rate;
-	u32 esc_clk_rate;
+	unsigned long byte_clk_rate;
+	unsigned long pixel_clk_rate;
+	unsigned long esc_clk_rate;
 
 	/* DSI v2 specific clocks */
 	struct clk *src_clk;
 	struct clk *esc_clk_src;
 	struct clk *dsi_clk_src;
 
-	u32 src_clk_rate;
+	unsigned long src_clk_rate;
 
 	struct gpio_desc *disp_en_gpio;
 	struct gpio_desc *te_gpio;
@@ -498,10 +498,10 @@ int msm_dsi_runtime_resume(struct device *dev)
 
 int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 {
-	u32 byte_intf_rate;
+	unsigned long byte_intf_rate;
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%d",
+	DBG("Set clk rates: pclk=%d, byteclk=%lu",
 		msm_host->mode->clock, msm_host->byte_clk_rate);
 
 	ret = dev_pm_opp_set_rate(&msm_host->pdev->dev,
@@ -583,7 +583,7 @@ int dsi_link_clk_set_rate_v2(struct msm_dsi_host *msm_host)
 {
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%d, esc_clk=%d, dsi_src_clk=%d",
+	DBG("Set clk rates: pclk=%d, byteclk=%lu, esc_clk=%lu, dsi_src_clk=%lu",
 		msm_host->mode->clock, msm_host->byte_clk_rate,
 		msm_host->esc_clk_rate, msm_host->src_clk_rate);
 
@@ -673,10 +673,10 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
 	clk_disable_unprepare(msm_host->byte_clk);
 }
 
-static u32 dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
+static unsigned long dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 {
 	struct drm_display_mode *mode = msm_host->mode;
-	u32 pclk_rate;
+	unsigned long pclk_rate;
 
 	pclk_rate = mode->clock * 1000;
 
@@ -696,7 +696,7 @@ static void dsi_calc_pclk(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 {
 	u8 lanes = msm_host->lanes;
 	u32 bpp = dsi_get_bpp(msm_host->format);
-	u32 pclk_rate = dsi_get_pclk_rate(msm_host, is_bonded_dsi);
+	unsigned long pclk_rate = dsi_get_pclk_rate(msm_host, is_bonded_dsi);
 	u64 pclk_bpp = (u64)pclk_rate * bpp;
 
 	if (lanes == 0) {
@@ -713,7 +713,7 @@ static void dsi_calc_pclk(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 	msm_host->pixel_clk_rate = pclk_rate;
 	msm_host->byte_clk_rate = pclk_bpp;
 
-	DBG("pclk=%d, bclk=%d", msm_host->pixel_clk_rate,
+	DBG("pclk=%lu, bclk=%lu", msm_host->pixel_clk_rate,
 				msm_host->byte_clk_rate);
 
 }
@@ -772,7 +772,7 @@ int dsi_calc_clk_rate_v2(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 
 	msm_host->esc_clk_rate = msm_host->byte_clk_rate / esc_div;
 
-	DBG("esc=%d, src=%d", msm_host->esc_clk_rate,
+	DBG("esc=%lu, src=%lu", msm_host->esc_clk_rate,
 		msm_host->src_clk_rate);
 
 	return 0;
-- 
2.33.0



