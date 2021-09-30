Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD5441DE42
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347655AbhI3P7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:59:10 -0400
Received: from mail.fris.de ([116.203.77.234]:36364 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347647AbhI3P7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 11:59:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7B0DABFBF7;
        Thu, 30 Sep 2021 17:57:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633017442; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=vmXGHfv62cic9GjQFFUjFhCG+ijbcaRskAQhxjIcXoE=;
        b=FZMI34FBsad6MwaZOnpht2abn/MRxRhLG8/VLYj4PqLhqLs/neL/4NhFlQK9BtHnMnvPAf
        QZTlGyWPQTWEZzOt2pSQELwMdqiuznO8qEKOSGWd1RlcZ1kxlz2Wdq0Lq8873P1GAR2JsI
        Np8wzJYBmaSCGOa1s/mvtzavGbfeyCd2qSXMzSFcTZEeNnzrD2QGwxu1hl4nws+sSuckJ0
        VVyAGWGcK88/H0ZQ7dIKr7HJy5qgHrjtjM8Xut741fgemnIrsiD1U90+PV4glybS4oqPL4
        0y4YGsoVNa12ObvEgVlk3zwWMN9c69B6mRkeuoLVhTQM34AFGVE3ypCvXFGvLw==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH 8/8] arm64: dts: imx8mm-kontron: Leave reg_vdd_arm always powered on
Date:   Thu, 30 Sep 2021 17:56:31 +0200
Message-Id: <20210930155633.2745201-9-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-1-frieder@fris.de>
References: <20210930155633.2745201-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

When the cpufreq driver is enabled, the buck2 regulator is kept powered on
by the dependency between the CPU nodes with 'cpu-supply' set. Without the
cpufreq driver the kernel will power off the regulator as it doesn't see
any users. This is obviously not what we want, therefore keep the regulator
powered on in any case.

Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index 213014f59b46..c3418d263eb4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -105,6 +105,7 @@ reg_vdd_arm: BUCK2 {
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <950000>;
 				regulator-boot-on;
+				regulator-always-on;
 				regulator-ramp-delay = <3125>;
 				nxp,dvs-run-voltage = <950000>;
 				nxp,dvs-standby-voltage = <850000>;
-- 
2.33.0

