Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E43360D6E
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhDOPCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234907AbhDOPAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79B4861406;
        Thu, 15 Apr 2021 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498556;
        bh=/OqoiyF58eJ1ZX2Sbi4gzBwj/jNfSytLlR1vYZznEso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFmk8hZW+/GtwqxS56QSdICPahl65zZ5FCpBGrnGx+4YGawVpLBvbSLPCPuJv1odx
         xaVXF8j+rQx89uvAHwoKHrdbpk8MCMKpXymOpR9JihhNiJa+UhutXCtaTt49ll+JQd
         vLS2Wn+rIfsPXl+5AqFaDvbkNYxsGpeLn2cpNgzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Liu Ying <victor.liu@nxp.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/13] drm/imx: imx-ldb: fix out of bounds array access warning
Date:   Thu, 15 Apr 2021 16:47:52 +0200
Message-Id: <20210415144411.707717946@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
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
index 221a8cbc57f9..a4dba034dca4 100644
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



