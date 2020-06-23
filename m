Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3B2063DE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391681AbgFWVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390958AbgFWUbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5798820702;
        Tue, 23 Jun 2020 20:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944299;
        bh=woCUbQ/CU003x4IIGmTMDxsREkOwxaUvumKf9HEwUKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBzL2TJty46Og7QpB0+W8BGJFPizGVqu+iTiMQhtQlnu3Ox6GWGrG7FAQKNdebDf5
         niJPd8UH+99VATTlu7v3uOsU6Xi0TFcAulsE7Jk1UhY1ev14HBrSibtQ0hiRgl2kCG
         8MTYv69Ga+lmbTQVduCLvUFdTSBAgdKK9hfcMVf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 250/314] drm/sun4i: hdmi ddc clk: Fix size of m divider
Date:   Tue, 23 Jun 2020 21:57:25 +0200
Message-Id: <20200623195350.884914938@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7ad3f06c127e7..00ca35f07ba5b 100644
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
index 2ff780114106c..12430b9d4e930 100644
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



