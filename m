Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE83299DD0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439157AbgJ0AKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439148AbgJ0AKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75D44216FD;
        Tue, 27 Oct 2020 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757410;
        bh=hxocgt0eIJGqhWzYRhd1/XRyiq1XfUojwJYXGONq5Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5a+Cdy9xh6afM2N7dveFJvngcjLNLjHo+3ARvC0MDQyqYl+dxhpda4VMa0AE86Q4
         ZczLIWOxPWi+smL5ETMRver4d74oODz74lgnEMbbY8RHSvqr9TyWxzpNsDMA1vdHiE
         EaDFcr5Becydo/fDM0jTtClZtYZjVjUqcASnXBs8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antonio Borneo <antonio.borneo@st.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 19/46] drm/bridge/synopsys: dsi: add support for non-continuous HS clock
Date:   Mon, 26 Oct 2020 20:09:18 -0400
Message-Id: <20201027000946.1026923-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit c6d94e37bdbb6dfe7e581e937a915ab58399b8a5 ]

Current code enables the HS clock when video mode is started or to
send out a HS command, and disables the HS clock to send out a LP
command. This is not what DSI spec specify.

Enable HS clock either in command and in video mode.
Set automatic HS clock management for panels and devices that
support non-continuous HS clock.

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Tested-by: Philippe Cornu <philippe.cornu@st.com>
Reviewed-by: Philippe Cornu <philippe.cornu@st.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200701194234.18123-1-yannick.fertre@st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c b/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
index 63c7a01b7053e..d95b0703d0255 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
@@ -311,7 +311,6 @@ static void dw_mipi_message_config(struct dw_mipi_dsi *dsi,
 	if (lpm)
 		val |= CMD_MODE_ALL_LP;
 
-	dsi_write(dsi, DSI_LPCLK_CTRL, lpm ? 0 : PHY_TXREQUESTCLKHS);
 	dsi_write(dsi, DSI_CMD_MODE_CFG, val);
 }
 
@@ -468,16 +467,22 @@ static void dw_mipi_dsi_video_mode_config(struct dw_mipi_dsi *dsi)
 static void dw_mipi_dsi_set_mode(struct dw_mipi_dsi *dsi,
 				 unsigned long mode_flags)
 {
+	u32 val;
+
 	dsi_write(dsi, DSI_PWR_UP, RESET);
 
 	if (mode_flags & MIPI_DSI_MODE_VIDEO) {
 		dsi_write(dsi, DSI_MODE_CFG, ENABLE_VIDEO_MODE);
 		dw_mipi_dsi_video_mode_config(dsi);
-		dsi_write(dsi, DSI_LPCLK_CTRL, PHY_TXREQUESTCLKHS);
 	} else {
 		dsi_write(dsi, DSI_MODE_CFG, ENABLE_CMD_MODE);
 	}
 
+	val = PHY_TXREQUESTCLKHS;
+	if (dsi->mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS)
+		val |= AUTO_CLKLANE_CTRL;
+	dsi_write(dsi, DSI_LPCLK_CTRL, val);
+
 	dsi_write(dsi, DSI_PWR_UP, POWERUP);
 }
 
-- 
2.25.1

