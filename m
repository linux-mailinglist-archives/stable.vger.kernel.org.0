Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC65354413
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242034AbhDEQE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241961AbhDEQET (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01731613C1;
        Mon,  5 Apr 2021 16:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638652;
        bh=lcU4DKczLEKRUAQnyQb4jFFbgCf8JhMH6o2UIlf5vnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktC8spTjkb6atPqDSbEfYN/sLHct7nzgSELLXo14Dmu5nzUaxbSuzKxCAb4d7O31e
         zPgZdfdo3CFTbniaimnhhNsgnUjdle87Z//iezSxzQhO73BEbkVY7aLJLg8k9zWRY9
         FgS9qV6LBPkLnXQT/ok3D5xsU77+NP8CQjwrtHF/7GQoOA0Ni0K63de18NidgTz2M/
         3vjuI0T3LRKDNShqiBStZUYI3ZWK02FNvWgsDIErMdTPnF9oD9Aqyrhz0TKsLvM86X
         2dFsLsvPRIBQjdPny5RvpRtolmKIvCLmKLbvC3OC6vPdRzU4JiM5wj6uAdT+8p5VCy
         /eeKtu4f7Sr3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Liu Ying <victor.liu@nxp.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 05/22] drm/imx: imx-ldb: fix out of bounds array access warning
Date:   Mon,  5 Apr 2021 12:03:48 -0400
Message-Id: <20210405160406.268132-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 41e2978cb1eb..75036aaa0c63 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -190,6 +190,11 @@ static void imx_ldb_encoder_enable(struct drm_encoder *encoder)
 	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux = drm_of_encoder_active_port_id(imx_ldb_ch->child, encoder);
 
+	if (mux < 0 || mux >= ARRAY_SIZE(ldb->clk_sel)) {
+		dev_warn(ldb->dev, "%s: invalid mux %d\n", __func__, mux);
+		return;
+	}
+
 	drm_panel_prepare(imx_ldb_ch->panel);
 
 	if (dual) {
@@ -248,6 +253,11 @@ imx_ldb_encoder_atomic_mode_set(struct drm_encoder *encoder,
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

