Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C438E42F15F
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 14:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhJOMvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 08:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbhJOMvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 08:51:42 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1A6C061769;
        Fri, 15 Oct 2021 05:49:36 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 487F4BFBCC;
        Fri, 15 Oct 2021 14:49:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1634302174; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=8lm9gsabnoEYqTgKZqukYHlfOlUcDx4Taw7hbxvkE1k=;
        b=w25PoQ4x0Y24OkCpbgSjF3j1j5aK06mr9VRzWv/9oF4l7gwyZnsnZb4/pPuUBP8QViLjJz
        TmfqSukyj5mVgAvFVEWGb7nc49edLWlzIE6kJfb9fSnUnVCsSWPpqbYFGoo/xsh+2UyM9u
        S3egVukF1ECdl3szDwe1PD5S8u6HEA6Cl3cg+Ewf3TJZoEvUYNv9d6vc9RgEzh5SjgtfhA
        EBBqF/idvQesqjP7gVKhaIhC0VzolWkGEBoxn27Ya4xQYMcwL9r2a3tQQkb4aoKnA7nHUp
        Q35r0jZKy9DdakVHQQMaTDEKIZkGlkrsNFjd8hzf2Nyl1tm8rf2+gum5ZsK0Pw==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH v2 6/6] arm64: dts: imx8mm-kontron: Fix connection type for VSC8531 RGMII PHY
Date:   Fri, 15 Oct 2021 14:48:40 +0200
Message-Id: <20211015124841.28226-7-frieder@fris.de>
In-Reply-To: <20211015124841.28226-1-frieder@fris.de>
References: <20211015124841.28226-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Previously we falsely relied on the PHY driver to unconditionally
enable the internal RX delay. Since the following fix for the PHY
driver this is not the case anymore:

commit 7b005a1742be ("net: phy: mscc: configure both RX and TX internal
delays for RGMII")

In order to enable the delay we need to set the connection type to
"rgmii-rxid". Without the RX delay the ethernet is not functional at
all.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Fix the commit ref in the Fixes tag
  * Extend the commit message to make clear that ethernet is not working
    without this fix.
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index 14263cd40daf..41ddaf980e14 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -113,7 +113,7 @@ &ecspi3 {
 &fec1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-connection-type = "rgmii";
+	phy-connection-type = "rgmii-rxid";
 	phy-handle = <&ethphy>;
 	status = "okay";
 
-- 
2.33.0

