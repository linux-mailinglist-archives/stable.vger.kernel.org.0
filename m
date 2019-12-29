Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E015212C489
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfL2Rai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbfL2Rai (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:30:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A7720722;
        Sun, 29 Dec 2019 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640637;
        bh=y4YmVfrhMhPsaeYQtxL6N+JN6WbVBq+cvS8DDysVOb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPM+CyEWsegUD/NLGeFv9QQKmKa+8Ppgo/EwejoA4+jpzuIJtWPSnKfPp3YB+41WY
         NoondVZ37gUKTE1L8aLNamoXvXNyYoT5oDdTDs0ggc4YJS03joEv9GQDvHHk6Y59GM
         QdFaM171gHiLRVlEVZ5hWIti4XfN6n+xJMsbcNMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng-Yi Chiang <cychiang@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Yakir Yang <ykk@rock-chips.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/219] drm/bridge: dw-hdmi: Restore audio when setting a mode
Date:   Sun, 29 Dec 2019 18:17:58 +0100
Message-Id: <20191229162517.488181114@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

[ Upstream commit fadfee3f9d8f114435a8a3e9f83a227600d89de7 ]

When setting a new display mode, dw_hdmi_setup() calls
dw_hdmi_enable_video_path(), which disables all hdmi clocks, including
the audio clock.

We should only (re-)enable the audio clock if audio was already enabled
when setting the new mode.

Without this patch, on RK3288, there will be HDMI audio on some monitors
if i2s was played to headphone when the monitor was plugged.
ACER H277HU and ASUS PB278 are two of the monitors showing this issue.

Signed-off-by: Cheng-Yi Chiang <cychiang@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191008102145.55134-1-cychiang@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index fb396d550275..2a0a1654d3ce 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1757,7 +1757,7 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 
 		/* HDMI Initialization Step E - Configure audio */
 		hdmi_clk_regenerator_update_pixel_clock(hdmi);
-		hdmi_enable_audio_clk(hdmi, true);
+		hdmi_enable_audio_clk(hdmi, hdmi->audio_enable);
 	}
 
 	/* not for DVI mode */
-- 
2.20.1



