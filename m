Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB562A53B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387921AbgKCVD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387915AbgKCVD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:03:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BD4206B5;
        Tue,  3 Nov 2020 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437437;
        bh=yqBwzzgFt+eDq0D+gtUwTG62XzSszG/FzkUVBMHpgT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPIJh1orQ9cOHL4RoQDHxbBaLZLZlKJgQos34bWmopmXI8PuHtTfuztxjlwNhBDqV
         OCFUa44iQAD9wqaF6S9gQHHvniKyJc+COcMZGlTK8vsiy2p/knJetBwatbkG/VSr0n
         nXq89xq7SzzQoBWx17Bh65+XDc49kDOZ8tPEWiB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/191] drm/bridge/synopsys: dsi: add support for non-continuous HS clock
Date:   Tue,  3 Nov 2020 21:36:07 +0100
Message-Id: <20201103203241.349550764@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fd7999642cf8a..8b5f9241a8876 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
@@ -326,7 +326,6 @@ static void dw_mipi_message_config(struct dw_mipi_dsi *dsi,
 	if (lpm)
 		val |= CMD_MODE_ALL_LP;
 
-	dsi_write(dsi, DSI_LPCLK_CTRL, lpm ? 0 : PHY_TXREQUESTCLKHS);
 	dsi_write(dsi, DSI_CMD_MODE_CFG, val);
 }
 
@@ -488,16 +487,22 @@ static void dw_mipi_dsi_video_mode_config(struct dw_mipi_dsi *dsi)
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
2.27.0



