Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8DF42F155
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbhJOMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbhJOMvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 08:51:24 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FC8C061570;
        Fri, 15 Oct 2021 05:49:18 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DEB32BFC0F;
        Fri, 15 Oct 2021 14:49:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1634302156; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=b3WwxseBuxxlm1edv2TBXG5FbEqMfGNzQKzPCy8l4AI=;
        b=T3B2ZHCYIOEjYoN2Fy5rz6oP3gJ3f7yXxiTpjRyXgUuZSaeRw2XJysmckQs/RE68ttVt8M
        XbyiL/FzBvzoN3KkXeiJENFFhDk8uLygFUt4VdIRkSN5RlJ8j/nSIa0rgBdwTBftC6HPjF
        EsjSTmkNPZw2NYzjqp29n++NzP2l4wJ5Byg4K9SQgWEitSop+Ku87Y9OwbicY3MscaO5Wf
        rdVjrsYgbWlekTIcfnue1mdsHm47FZELmLRnbPGsi+C1APLW7gOUp8wNwafXGwjm+eHcfY
        r/VyFLzjvhfWaP5Tg0Ktds3LFkMQZhv3SGUya+6rXEvJIX68mzI7hc61rgKfbQ==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH v2 2/6] arm64: dts: imx8mm-kontron: Make sure SOC and DRAM supply voltages are correct
Date:   Fri, 15 Oct 2021 14:48:36 +0200
Message-Id: <20211015124841.28226-3-frieder@fris.de>
In-Reply-To: <20211015124841.28226-1-frieder@fris.de>
References: <20211015124841.28226-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

It looks like the voltages for the SOC and DRAM supply weren't properly
validated before. The datasheet and uboot-imx code tells us that VDD_SOC
should be 800 mV in suspend and 850 mV in run mode. VDD_DRAM should be
950 mV for DDR clock frequencies of up to 1.5 GHz.

Let's fix these values to make sure the voltages are within the required
range.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Fix the commit ref in the Fixes tag
  * Improve commit message
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index 6eacc32bc95e..4df45b5e5f6e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -92,10 +92,12 @@ regulators {
 			reg_vdd_soc: BUCK1 {
 				regulator-name = "buck1";
 				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <900000>;
+				regulator-max-microvolt = <850000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <3125>;
+				nxp,dvs-run-voltage = <850000>;
+				nxp,dvs-standby-voltage = <800000>;
 			};
 
 			reg_vdd_arm: BUCK2 {
@@ -112,7 +114,7 @@ reg_vdd_arm: BUCK2 {
 			reg_vdd_dram: BUCK3 {
 				regulator-name = "buck3";
 				regulator-min-microvolt = <850000>;
-				regulator-max-microvolt = <900000>;
+				regulator-max-microvolt = <950000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
-- 
2.33.0

