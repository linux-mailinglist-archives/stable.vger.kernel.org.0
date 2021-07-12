Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EC33C456A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhGLGZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235221AbhGLGYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD64610A7;
        Mon, 12 Jul 2021 06:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070898;
        bh=kpxVh31sn0dbFFVhbUqnvztstTwZpdo28zIFX4+I+aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyB37jnG2inxb/R0vQZmeYERrW0GAMr+GO0lWbyD/KTVKYETC5FxVVIO6lTph3Hxg
         G0jd7iDQVgtD7RY2tmXIuZUGD3thCkGeMEHA2PNanrgmHHkuUrv7kc5rIJpqZ7XmPT
         nhRM8hPzdY7NJky7QcRrXcC0D47mVIXZQ6G8nZ28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/348] pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
Date:   Mon, 12 Jul 2021 08:09:32 +0200
Message-Id: <20210712060725.932052838@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
 drivers/pinctrl/sh-pfc/pfc-r8a7796.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7796.c b/drivers/pinctrl/sh-pfc/pfc-r8a7796.c
index 61db7c7a35ec..60d35a2c14ba 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7796.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7796.c
@@ -68,6 +68,7 @@
 	PIN_NOGP_CFG(QSPI1_MOSI_IO0, "QSPI1_MOSI_IO0", fn, CFG_FLAGS),	\
 	PIN_NOGP_CFG(QSPI1_SPCLK, "QSPI1_SPCLK", fn, CFG_FLAGS),	\
 	PIN_NOGP_CFG(QSPI1_SSL, "QSPI1_SSL", fn, CFG_FLAGS),		\
+	PIN_NOGP_CFG(PRESET_N, "PRESET#", fn, SH_PFC_PIN_CFG_PULL_DOWN),\
 	PIN_NOGP_CFG(RPC_INT_N, "RPC_INT#", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(RPC_RESET_N, "RPC_RESET#", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(RPC_WP_N, "RPC_WP#", fn, CFG_FLAGS),		\
@@ -6109,7 +6110,7 @@ static const struct pinmux_bias_reg pinmux_bias_regs[] = {
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



