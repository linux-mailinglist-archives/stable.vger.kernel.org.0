Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C243C4DAA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbhGLHNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242236AbhGLHMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F499610CA;
        Mon, 12 Jul 2021 07:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073788;
        bh=ZalyV7O2QyA+eOzD/9i/AUg1dJdQAOO3HHi8Lp7G87A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXacnSAXLmAoQkox7nJ0eTZZApLX8lmoTblFflLI0U6JtfTfifcvvDTzUuo1iimsc
         +ebaqYeOMWV1TTItQ7Wm2FDXUaOJqjDh7LYgOqofye7GBVVi95bYvFYRr8zLVxCEvD
         RodmCF+Mdg93JZD/v/QZzJmMtOfBoZpG9cGCtMiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 361/700] pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
Date:   Mon, 12 Jul 2021 08:07:24 +0200
Message-Id: <20210712061014.760173171@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2cee31cd49733e89dfedf4f68a56839fc2e42040 ]

R-Car Gen3 Hardware Manual Errata for Rev. 0.52 of Nov 30, 2016, added
the configuration bit for bias pull-down control for the PRESET# pin on
R-Car M3-W.  Add driver support for controlling pull-down on this pin.

Fixes: 2d40bd24274d2577 ("pinctrl: sh-pfc: r8a7796: Add bias pinconf support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/c479de5b3f235c2f7d5faea9e7e08e6fccb135df.1619785375.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a7796.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a7796.c b/drivers/pinctrl/renesas/pfc-r8a7796.c
index 96b5b1509bb7..c4f1f5607601 100644
--- a/drivers/pinctrl/renesas/pfc-r8a7796.c
+++ b/drivers/pinctrl/renesas/pfc-r8a7796.c
@@ -68,6 +68,7 @@
 	PIN_NOGP_CFG(QSPI1_MOSI_IO0, "QSPI1_MOSI_IO0", fn, CFG_FLAGS),	\
 	PIN_NOGP_CFG(QSPI1_SPCLK, "QSPI1_SPCLK", fn, CFG_FLAGS),	\
 	PIN_NOGP_CFG(QSPI1_SSL, "QSPI1_SSL", fn, CFG_FLAGS),		\
+	PIN_NOGP_CFG(PRESET_N, "PRESET#", fn, SH_PFC_PIN_CFG_PULL_DOWN),\
 	PIN_NOGP_CFG(RPC_INT_N, "RPC_INT#", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(RPC_RESET_N, "RPC_RESET#", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(RPC_WP_N, "RPC_WP#", fn, CFG_FLAGS),		\
@@ -6191,7 +6192,7 @@ static const struct pinmux_bias_reg pinmux_bias_regs[] = {
 		[ 4] = RCAR_GP_PIN(6, 29),	/* USB30_OVC */
 		[ 5] = RCAR_GP_PIN(6, 30),	/* GP6_30 */
 		[ 6] = RCAR_GP_PIN(6, 31),	/* GP6_31 */
-		[ 7] = SH_PFC_PIN_NONE,
+		[ 7] = PIN_PRESET_N,		/* PRESET# */
 		[ 8] = SH_PFC_PIN_NONE,
 		[ 9] = SH_PFC_PIN_NONE,
 		[10] = SH_PFC_PIN_NONE,
-- 
2.30.2



