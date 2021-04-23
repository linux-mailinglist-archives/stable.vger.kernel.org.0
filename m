Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDB13698CC
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 20:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhDWSEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 14:04:33 -0400
Received: from phobos.denx.de ([85.214.62.61]:52388 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhDWSEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 14:04:33 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2021 14:04:33 EDT
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4CED580A51;
        Fri, 23 Apr 2021 19:57:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1619200637;
        bh=MMKXggxnAvG4lSMnqHC+ihz1hl4OQSg7ruu7S+mD5Hg=;
        h=From:To:Cc:Subject:Date:From;
        b=IXtyRhulY9UECDCKFuZgMrlXoQIsTFUwW6AcR03BB4eNClw4Z3YTjxKzrb3SlK99m
         F8swmmALgeQVF9IAMfE/8RWpyLNGzThg29GFzddYF52BTxgY1stpnS0bjt2ds8w5i6
         tFpI6mJgnA+L39MPolHweTh+Kzjb1D2mFYCOdHJnQHyltSFZBNw3iP8Q0basIdovaM
         STHHxar/L4e18VD0I4kjwm9BLcJp48EMB9OqHbhI0/mFwGw9sAQF4aIKDFVO4Nz0t4
         bC6EYTu7Nxr41BySNKiDlw1i+IiHimHkqtlYGyzzdgxj5mR42KsVqpuHZIfY3BRJbv
         tesxg2C0jzf6Q==
From:   Marek Vasut <marex@denx.de>
To:     linux-arm-kernel@lists.infradead.org
Cc:     arnd@arndb.de, Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Fabio Estevam <festevam@gmail.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V2] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
Date:   Fri, 23 Apr 2021 19:57:01 +0200
Message-Id: <20210423175701.76637-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.4 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.

While no instability or problems are currently observed, the regulators
should be fully described in DT and that description should fully match
the hardware, else this might lead to unforseen issues later. Fix this.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Ludwig Zenz <lzenz@dh-electronics.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: stable@vger.kernel.org
---
V2: Amend commit message
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index 236fc205c389..d0768ae429fa 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -406,6 +406,18 @@ &reg_soc {
 	vin-supply = <&sw1_reg>;
 };
 
+&reg_pu {
+	vin-supply = <&sw1_reg>;
+};
+
+&reg_vdd1p1 {
+	vin-supply = <&sw2_reg>;
+};
+
+&reg_vdd2p5 {
+	vin-supply = <&sw2_reg>;
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-- 
2.30.2

