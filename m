Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C47C1106637
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKVFt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfKVFtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977632068F;
        Fri, 22 Nov 2019 05:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401763;
        bh=mSHihSWPIz7bjaQpm4r+c0kwC0caDuKYcbZxaq51kQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt5+r2izl3yW+FR5a1fouFZEly2IJweGR+l5dxrpesm1TOVl2sMQiAn5vXItOohmp
         dRShAoxepsL3DVW+cuZe1MAXaeKQsETm3odB+AzTe10tSQUScHVuhUXVr7T1Mq3LTs
         e/jcXYIt6hl889FzHs10XC0jlj4MgdifS4SGCtYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 015/219] ARM: dts: imx6sl: Fix memory node duplication
Date:   Fri, 22 Nov 2019 00:45:47 -0500
Message-Id: <20191122054911.1750-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7fa8ab65ee15e386558ac5e971004712da91e2dd ]

Boards based on imx6sl have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx6sl.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl-evk.dts  | 1 +
 arch/arm/boot/dts/imx6sl-warp.dts | 1 +
 arch/arm/boot/dts/imx6sl.dtsi     | 2 --
 arch/arm/boot/dts/imx6sll-evk.dts | 1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
index 679b4482ab13a..f7a48e4622e1b 100644
--- a/arch/arm/boot/dts/imx6sl-evk.dts
+++ b/arch/arm/boot/dts/imx6sl-evk.dts
@@ -17,6 +17,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sl-warp.dts b/arch/arm/boot/dts/imx6sl-warp.dts
index 404e602e67813..408da704c459b 100644
--- a/arch/arm/boot/dts/imx6sl-warp.dts
+++ b/arch/arm/boot/dts/imx6sl-warp.dts
@@ -55,6 +55,7 @@
 	compatible = "warp,imx6sl-warp", "fsl,imx6sl";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 2fa88c6f18820..55d1872aa81a8 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -13,10 +13,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		ethernet0 = &fec;
diff --git a/arch/arm/boot/dts/imx6sll-evk.dts b/arch/arm/boot/dts/imx6sll-evk.dts
index c8e115564ba2c..0c2406ac8a638 100644
--- a/arch/arm/boot/dts/imx6sll-evk.dts
+++ b/arch/arm/boot/dts/imx6sll-evk.dts
@@ -20,6 +20,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x80000000>;
 	};
 
-- 
2.20.1

