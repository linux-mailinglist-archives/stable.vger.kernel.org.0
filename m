Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C4360D57
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhDOPBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234068AbhDOO6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A18613DC;
        Thu, 15 Apr 2021 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498505;
        bh=ryiPGxLXDF1h365Dz+7XDWnLjwXbgkY02hs5TSBDcUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UH3xVHWs1KMUMZfuO/XDiwW1BJ9ELhb16qZJCeKV7d+DjR8+wEMB+jFMWIv7AIkOh
         W4Df3O4rgh4651VR0vpQxXEtLX7taW9PL2wHRLviJDWobYOVEL6gYlVvoUht4DXx6f
         95SPlU+xYlqvHOJIyxy9E7CTWlPGzJsfc1pb/+RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Liu Ying <victor.liu@nxp.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/68] drm/imx: imx-ldb: fix out of bounds array access warning
Date:   Thu, 15 Apr 2021 16:47:43 +0200
Message-Id: <20210415144416.513536380@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 33ce7f2f95cabb5834cf0906308a5cb6103976da ]

When CONFIG_OF is disabled, building with 'make W=1' produces warnings
about out of bounds array access:

drivers/gpu/drm/imx/imx-ldb.c: In function 'imx_ldb_set_clock.constprop':
drivers/gpu/drm/imx/imx-ldb.c:186:8: error: array subscript -22 is below array bounds of 'struct clk *[4]' [-Werror=array-bounds]

Add an error check before the index is used, which helps with the
warning, as well as any possible other error condition that may be
triggered at runtime.

The warning could be fixed by adding a Kconfig depedency on CONFIG_OF,
but Liu Ying points out that the driver may hit the out-of-bounds
problem at runtime anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/imx-ldb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index d38648a7ef2d..d88ac6f2222a 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -206,6 +206,11 @@ static void imx_ldb_encoder_enable(struct drm_encoder *encoder)
 	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux = drm_of_encoder_active_port_id(imx_ldb_ch->child, encoder);
 
+	if (mux < 0 || mux >= ARRAY_SIZE(ldb->clk_sel)) {
+		dev_warn(ldb->dev, "%s: invalid mux %d\n", __func__, mux);
+		return;
+	}
+
 	drm_panel_prepare(imx_ldb_ch->panel);
 
 	if (dual) {
@@ -264,6 +269,11 @@ imx_ldb_encoder_atomic_mode_set(struct drm_encoder *encoder,
 	int mux = drm_of_encoder_active_port_id(imx_ldb_ch->child, encoder);
 	u32 bus_format = imx_ldb_ch->bus_format;
 
+	if (mux < 0 || mux >= ARRAY_SIZE(ldb->clk_sel)) {
+		dev_warn(ldb->dev, "%s: invalid mux %d\n", __func__, mux);
+		return;
+	}
+
 	if (mode->clock > 170000) {
 		dev_warn(ldb->dev,
 			 "%s: mode exceeds 170 MHz pixel clock\n", __func__);
-- 
2.30.2



