Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D8524B3FE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgHTJzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730187AbgHTJzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 559842067C;
        Thu, 20 Aug 2020 09:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917308;
        bh=YEXaHg2iBlaYXdD+t5XXIh39qL4/7luoV72oGLb54/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2XEBbXOulAZS39+fcNp6LdFLMIQ8UqeKQG8IfKimamkYw6IIV14ZHhqbD3q8JeLk
         cWn7yogoKcYhfw52E55fyCjvOu9s6mJ8mlsbXTbWL6iEocCFMNHkB7IuYXu4+iiNBE
         gHUTk31uqKivPxh0+hWqkss12lmQBfBYYCAJpj4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Liu Ying <victor.liu@nxp.com>
Subject: [PATCH 4.19 48/92] drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()
Date:   Thu, 20 Aug 2020 11:21:33 +0200
Message-Id: <20200820091540.154739814@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

commit 3b2a999582c467d1883716b37ffcc00178a13713 upstream.

Both of the two LVDS channels should be disabled for split mode
in the encoder's ->disable() callback, because they are enabled
in the encoder's ->enable() callback.

Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/imx/imx-ldb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -311,18 +311,19 @@ static void imx_ldb_encoder_disable(stru
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux, ret;
 
 	drm_panel_disable(imx_ldb_ch->panel);
 
-	if (imx_ldb_ch == &ldb->channel[0])
+	if (imx_ldb_ch == &ldb->channel[0] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
-	else if (imx_ldb_ch == &ldb->channel[1])
+	if (imx_ldb_ch == &ldb->channel[1] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
 
-	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
+	if (dual) {
 		clk_disable_unprepare(ldb->clk[0]);
 		clk_disable_unprepare(ldb->clk[1]);
 	}


