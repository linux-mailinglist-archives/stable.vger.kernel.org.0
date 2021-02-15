Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B369931BCB0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBOPdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhBOPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B1664E9C;
        Mon, 15 Feb 2021 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402983;
        bh=rQVoB0SuRcCAcymv+tN5U5jBlBkeADhdXhh2T8mTNus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7sqkJHFjCNvoK4+8JP+/FB7z7B5dgdY0zCn58Ux81SNM5UNLogqbNwwU61Ydog03
         2YpDiYaPt/PhqrT3049LCcPcV6BNPgr1Q+G8ZyVMocPfQlHzB02hqbWEEiWI8rEb80
         AH8MQLilzcdWrhDQSGWH0Net2DgV5m3YtB1rUuLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/60] drm/sun4i: Fix H6 HDMI PHY configuration
Date:   Mon, 15 Feb 2021 16:27:30 +0100
Message-Id: <20210215152716.714183665@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 6a155216c48f2f65c8dcb02c4c27549c170d24a9 ]

As it turns out, vendor HDMI PHY driver for H6 has a pretty big table
of predefined values for various pixel clocks. However, most of them are
not useful/tested because they come from reference driver code. Vendor
PHY driver is concerned with only few of those, namely 27 MHz, 74.25
MHz, 148.5 MHz, 297 MHz and 594 MHz. These are all frequencies for
standard CEA modes.

Fix sun50i_h6_cur_ctr and sun50i_h6_phy_config with the values only for
aforementioned frequencies.

Table sun50i_h6_mpll_cfg doesn't need to be changed because values are
actually frequency dependent and not so much SoC dependent. See i.MX6
documentation for explanation of those values for similar PHY.

Fixes: c71c9b2fee17 ("drm/sun4i: Add support for Synopsys HDMI PHY")
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209175900.7092-5-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index 43643ad317306..a4012ec13d4b3 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -104,29 +104,21 @@ static const struct dw_hdmi_mpll_config sun50i_h6_mpll_cfg[] = {
 
 static const struct dw_hdmi_curr_ctrl sun50i_h6_cur_ctr[] = {
 	/* pixelclk    bpp8    bpp10   bpp12 */
-	{ 25175000,  { 0x0000, 0x0000, 0x0000 }, },
 	{ 27000000,  { 0x0012, 0x0000, 0x0000 }, },
-	{ 59400000,  { 0x0008, 0x0008, 0x0008 }, },
-	{ 72000000,  { 0x0008, 0x0008, 0x001b }, },
-	{ 74250000,  { 0x0013, 0x0013, 0x0013 }, },
-	{ 90000000,  { 0x0008, 0x001a, 0x001b }, },
-	{ 118800000, { 0x001b, 0x001a, 0x001b }, },
-	{ 144000000, { 0x001b, 0x001a, 0x0034 }, },
-	{ 180000000, { 0x001b, 0x0033, 0x0034 }, },
-	{ 216000000, { 0x0036, 0x0033, 0x0034 }, },
-	{ 237600000, { 0x0036, 0x0033, 0x001b }, },
-	{ 288000000, { 0x0036, 0x001b, 0x001b }, },
-	{ 297000000, { 0x0019, 0x001b, 0x0019 }, },
-	{ 330000000, { 0x0036, 0x001b, 0x001b }, },
-	{ 594000000, { 0x003f, 0x001b, 0x001b }, },
+	{ 74250000,  { 0x0013, 0x001a, 0x001b }, },
+	{ 148500000, { 0x0019, 0x0033, 0x0034 }, },
+	{ 297000000, { 0x0019, 0x001b, 0x001b }, },
+	{ 594000000, { 0x0010, 0x001b, 0x001b }, },
 	{ ~0UL,      { 0x0000, 0x0000, 0x0000 }, }
 };
 
 static const struct dw_hdmi_phy_config sun50i_h6_phy_config[] = {
 	/*pixelclk   symbol   term   vlev*/
-	{ 74250000,  0x8009, 0x0004, 0x0232},
-	{ 148500000, 0x8029, 0x0004, 0x0273},
-	{ 594000000, 0x8039, 0x0004, 0x014a},
+	{ 27000000,  0x8009, 0x0007, 0x02b0 },
+	{ 74250000,  0x8009, 0x0006, 0x022d },
+	{ 148500000, 0x8029, 0x0006, 0x0270 },
+	{ 297000000, 0x8039, 0x0005, 0x01ab },
+	{ 594000000, 0x8029, 0x0000, 0x008a },
 	{ ~0UL,	     0x0000, 0x0000, 0x0000}
 };
 
-- 
2.27.0



