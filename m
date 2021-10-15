Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7965642F15A
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 14:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhJOMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 08:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbhJOMvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 08:51:33 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99C2C061570;
        Fri, 15 Oct 2021 05:49:26 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 995B1BFC0F;
        Fri, 15 Oct 2021 14:49:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1634302165; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=qyKqlEMeX9Tm7dfttgspJlNv6P8/Mp4wZW/lQk9UnEM=;
        b=cDwO+PEgE4WH6DuMKKiQlD6ZkrIMM5pI2zXITWB8x/9PCxd/UjuzENvF4p1N0uzEPmHei9
        epecBEgKcre1Q7sxXCL0QYdDq0IgZdmkI9jtX+mp3R9XR09rf+zfONXpt6qlBWHYEDhlOf
        dZntCBKz7bMHlXJhTJmC0n0lKeCdpmSgayA8oEfw7jK9us/hEpQE2+aCUA9wNM0Khic4Zz
        kWowyki8KYbu1ELa1fYdLjA3uc7cphHZaNLRBF27RyvcaqaZD1E1IZbkGLHxL+pRMJVsvW
        Vl+ZHw8xTkaGGWg11apwvcJ8J6iBIUuaoesuaHotUmRGbyu61uIhnOScmSWzog==
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
Subject: [PATCH v2 4/6] arm64: dts: imx8mm-kontron: Fix polarity of reg_rst_eth2
Date:   Fri, 15 Oct 2021 14:48:38 +0200
Message-Id: <20211015124841.28226-5-frieder@fris.de>
In-Reply-To: <20211015124841.28226-1-frieder@fris.de>
References: <20211015124841.28226-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
adapter deasserted anytime. Fix the polarity and mark it as always-on.

Anyway, using the regulator is only a workaround for the missing support of
specifying a reset GPIO for USB devices in a generic way. As we don't
have a solution for this at the moment, at least fix the current
workaround.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Fix the commit ref in the Fixes tag
  * Improve commit message
  * Remove useless change of uncontrolled reg_vdd_5v
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index 5f6fc4c2c529..a192a047f264 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
 		regulator-name = "rst-usb-eth2";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usb_eth2>;
-		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
+		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
 	};
 
 	reg_vdd_5v: regulator-5v {
-- 
2.33.0

