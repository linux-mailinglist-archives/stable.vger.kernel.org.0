Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4005B3C4992
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhGLGp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238414AbhGLGoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE02D610A6;
        Mon, 12 Jul 2021 06:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071988;
        bh=Ut3SNo/eZhUyixiW6csbczXb/CDHfL2gNK/XBsWZkaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdNNaF6NDOW2lSyWQUI3t4UDHh0ln2reRFMwM4OCC7IRMBO1/XRdrlWiHK3yhh8vn
         tJRgknX8uCq0VjCw5jF/I8C6ojj9c+Oc+ZZQj4v8KbUbJne6NkAhrYgZjD/yIami12
         WwDt4XE7TWqupsbpXa+hd10/y1V6NyHLJYKIIByc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/593] pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
Date:   Mon, 12 Jul 2021 08:07:47 +0200
Message-Id: <20210712060918.890895528@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 55f0344a3d3e..3878d6b0db14 100644
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



