Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB402F45E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfE3Eho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729248AbfE3DMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC982449A;
        Thu, 30 May 2019 03:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185969;
        bh=R0qs3whX4ECIj9uSpugfnFNFmdy6ANl8+OnbmX9xhpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhyXqhMOY85EEqaXlzJGujIqJZwaj3fjinG3ZtqYpE9gpJRrYSkvZP6hv8Ja05AkZ
         iZUiK2EtxvLoBpEXKts8kTlA4icHTIGpGrUOItX3buKd1UnFR4frxxbiUIgpHIcEEI
         OMsULWnsik0N9Fu5AUBx9Pk06ewsHWMuFHkqceoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 400/405] drm/sun4i: dsi: Restrict DSI tcon clock divider
Date:   Wed, 29 May 2019 20:06:38 -0700
Message-Id: <20190530030600.797307841@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 85fb352666732a9e5caf6027b9c253b3d7881d8f ]

The current code allows the TCON clock divider to have a range between 4
and 127 when feeding the DSI controller.

The only display supported so far had a display clock rate that ended up
using a divider of 4, but testing with other displays show that only 4
seems to be functional.

This also aligns with what Allwinner is doing in their BSP, so let's just
hardcode that we want a divider of 4 when using the DSI output.

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/074e88ae472f5e0492e26939c74b44fb4125ffbd.1549896081.git-series.maxime.ripard@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c     | 4 ++--
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 7136fc91c6036..e75f77ff8e0fc 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -341,8 +341,8 @@ static void sun4i_tcon0_mode_set_cpu(struct sun4i_tcon *tcon,
 	u32 block_space, start_delay;
 	u32 tcon_div;
 
-	tcon->dclk_min_div = 4;
-	tcon->dclk_max_div = 127;
+	tcon->dclk_min_div = SUN6I_DSI_TCON_DIV;
+	tcon->dclk_max_div = SUN6I_DSI_TCON_DIV;
 
 	sun4i_tcon0_mode_set_common(tcon, mode);
 
diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
index a07090579f84b..5c3ad5be06901 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
@@ -13,6 +13,8 @@
 #include <drm/drm_encoder.h>
 #include <drm/drm_mipi_dsi.h>
 
+#define SUN6I_DSI_TCON_DIV	4
+
 struct sun6i_dsi {
 	struct drm_connector	connector;
 	struct drm_encoder	encoder;
-- 
2.20.1



