Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A6E4290AC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242832AbhJKOL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242992AbhJKOJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D93F610F8;
        Mon, 11 Oct 2021 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960908;
        bh=FT1gXPshyOhotkOXSnjWFTWPuNGK6o07X5WDtS0la5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vL9ThDNwgtNYiho1NbYFAwsq04H2QbX6fNXPAWqJ9Xysqhn9oCFZjlelXV+epg63
         wzyJgbAG0diZNxppBdTqdOhOcVuG2ogB8JLVBnvbHY8l5Iq4olYj+3FhzZtr+o0JPc
         h51b4vkTlp3jeIShsGqniGV8bIw3wG6Sm7BjaY9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 077/151] arm64: dts: imx8: change the spi-nor tx
Date:   Mon, 11 Oct 2021 15:45:49 +0200
Message-Id: <20211011134520.337008926@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 04aa946d57b20c40e541fb4ba2bcb390a22f404c ]

Before commit 0e30f47232ab5 ("mtd: spi-nor: add support for DTR protocol"),
for all PP command, it only support 1-1-1 mode, no matter the tx setting
in dts. But after the upper commit, the logic change. It will choose
the best mode(fastest mode) which flash device and spi-nor host controller
both support.

qspi and fspi host controller do not support read 1-4-4 mode. so need to
set the tx to 1, let the common code finally select read 1-1-4 mode.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi        | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts                | 2 +-
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi        | 2 +-
 arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi       | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq-evk.dts                | 2 ++
 arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts | 2 +-
 6 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 988f8ab679ad..40f5e7a3b064 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -91,7 +91,7 @@
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		spi-max-frequency = <80000000>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
index 4e2820d19244..a2b24d4d4e3e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
@@ -48,7 +48,7 @@
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		spi-max-frequency = <80000000>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index 54eaf3d6055b..3b2d627a0342 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -101,7 +101,7 @@
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		spi-max-frequency = <80000000>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
index aa78e0d8c72b..fc178eebf8aa 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
@@ -74,7 +74,7 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <80000000>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-evk.dts b/arch/arm64/boot/dts/freescale/imx8mq-evk.dts
index 4d2035e3dd7c..4886f3e31587 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-evk.dts
@@ -337,6 +337,8 @@
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
 		spi-max-frequency = <29000000>;
+		spi-tx-bus-width = <1>;
+		spi-rx-bus-width = <4>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts b/arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts
index f593e4ff62e1..564746d5000d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts
@@ -281,7 +281,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 		spi-max-frequency = <50000000>;
-- 
2.33.0



