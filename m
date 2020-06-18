Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B331FE351
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgFRCIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgFRBWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F5020CC7;
        Thu, 18 Jun 2020 01:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443323;
        bh=LhWCgqMpOimMUIh/VYqwEEVS7oF4YKfUj2TxcSiqHWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vv4ml2OiS98z7H+EwL31LByglnuzuCWN2DkWo2HfCuraNAKAslKQCAP9cVJcUSnXT
         evrKSuRXXjCLeuQGRQCZnO4z8utkziWYMntXT2yxBdCnAeilpnOQRdjXkR2yxeqENj
         y+T2rsjpTiHTzIyvtxKO2RfEWDE1Q5N1MkMwv1Hc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 257/266] drm/sun4i: hdmi ddc clk: Fix size of m divider
Date:   Wed, 17 Jun 2020 21:16:22 -0400
Message-Id: <20200618011631.604574-257-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 54e1e06bcf1cf6e7ac3f86daa5f7454add24b494 ]

m divider in DDC clock register is 4 bits wide. Fix that.

Fixes: 9c5681011a0c ("drm/sun4i: Add HDMI support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200413095457.1176754-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi.h         | 2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi.h b/drivers/gpu/drm/sun4i/sun4i_hdmi.h
index 7ad3f06c127e..00ca35f07ba5 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi.h
@@ -148,7 +148,7 @@
 #define SUN4I_HDMI_DDC_CMD_IMPLICIT_WRITE	3
 
 #define SUN4I_HDMI_DDC_CLK_REG		0x528
-#define SUN4I_HDMI_DDC_CLK_M(m)			(((m) & 0x7) << 3)
+#define SUN4I_HDMI_DDC_CLK_M(m)			(((m) & 0xf) << 3)
 #define SUN4I_HDMI_DDC_CLK_N(n)			((n) & 0x7)
 
 #define SUN4I_HDMI_DDC_LINE_CTRL_REG	0x540
diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c
index 2ff780114106..12430b9d4e93 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c
@@ -33,7 +33,7 @@ static unsigned long sun4i_ddc_calc_divider(unsigned long rate,
 	unsigned long best_rate = 0;
 	u8 best_m = 0, best_n = 0, _m, _n;
 
-	for (_m = 0; _m < 8; _m++) {
+	for (_m = 0; _m < 16; _m++) {
 		for (_n = 0; _n < 8; _n++) {
 			unsigned long tmp_rate;
 
-- 
2.25.1

