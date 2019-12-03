Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28AA111F52
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfLCWre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbfLCWrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145A020656;
        Tue,  3 Dec 2019 22:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413252;
        bh=g/LS6jI+ABLx2gf5i8mdPXUrd5s/zvOXFa8u8m4VnH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqG/5nRhP7CIYyLI+twp8tlPdszoTuPVCFvjUVKWVDOlXh+uitQg8AtYy93EtIy83
         YJi5bSUHiy0Mk1Bq9FC49kYPvXuuT9X2jH3sCvL2rnk5fVvTGw/nqSuKPIo5MleU8/
         A4oO2pCk+X+Ohv+4qetb6A2uKJTCMmHX6WZr0flw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/321] ARM: dts: imx7: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:04 +0100
Message-Id: <20191203223430.188959198@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 29988e867cb17de7119e971f9acfad2c3fccdb47 ]

Boards based on imx7 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx7s.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts   | 3 ++-
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi | 1 +
 arch/arm/boot/dts/imx7d-colibri.dtsi      | 1 +
 arch/arm/boot/dts/imx7d-nitrogen7.dts     | 1 +
 arch/arm/boot/dts/imx7d-pico.dtsi         | 1 +
 arch/arm/boot/dts/imx7d-sdb.dts           | 1 +
 arch/arm/boot/dts/imx7s-colibri.dtsi      | 1 +
 arch/arm/boot/dts/imx7s-warp.dts          | 1 +
 arch/arm/boot/dts/imx7s.dtsi              | 2 --
 9 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d-cl-som-imx7.dts b/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
index 584418f517a88..62d5e9a4a7818 100644
--- a/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
+++ b/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
@@ -19,6 +19,7 @@
 	compatible = "compulab,cl-som-imx7", "fsl,imx7d";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x10000000>; /* 256 MB - minimal configuration */
 	};
 
@@ -284,4 +285,4 @@
 			MX7D_PAD_LPSR_GPIO1_IO05__GPIO1_IO5	0x14 /* OTG PWREN */
 		>;
 	};
-};
\ No newline at end of file
+};
diff --git a/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi b/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
index 04d24ee17b142..898f4b8d7421f 100644
--- a/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
+++ b/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
@@ -8,6 +8,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx7d-colibri.dtsi b/arch/arm/boot/dts/imx7d-colibri.dtsi
index d9f8fb69511b6..e2e327f437e35 100644
--- a/arch/arm/boot/dts/imx7d-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7d-colibri.dtsi
@@ -45,6 +45,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx7d-nitrogen7.dts b/arch/arm/boot/dts/imx7d-nitrogen7.dts
index 177d21fdeb288..6b4acea1ef795 100644
--- a/arch/arm/boot/dts/imx7d-nitrogen7.dts
+++ b/arch/arm/boot/dts/imx7d-nitrogen7.dts
@@ -12,6 +12,7 @@
 	compatible = "boundary,imx7d-nitrogen7", "fsl,imx7d";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x40000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx7d-pico.dtsi b/arch/arm/boot/dts/imx7d-pico.dtsi
index f27b3849d3ff3..934a019f341e4 100644
--- a/arch/arm/boot/dts/imx7d-pico.dtsi
+++ b/arch/arm/boot/dts/imx7d-pico.dtsi
@@ -49,6 +49,7 @@
 	compatible = "technexion,imx7d-pico", "fsl,imx7d";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x80000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx7d-sdb.dts b/arch/arm/boot/dts/imx7d-sdb.dts
index c9b3c60b0eb22..317f1bcc56e2a 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -15,6 +15,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x80000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx7s-colibri.dtsi b/arch/arm/boot/dts/imx7s-colibri.dtsi
index fe8344cee8641..1fb1ec5d3d707 100644
--- a/arch/arm/boot/dts/imx7s-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7s-colibri.dtsi
@@ -45,6 +45,7 @@
 
 / {
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x10000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index fa390da636de7..97d5c711eb0ca 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -51,6 +51,7 @@
 	compatible = "warp,imx7s-warp", "fsl,imx7s";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x20000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 90f5bdfa9b3ce..7eaf96b425bed 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -17,10 +17,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		gpio0 = &gpio1;
-- 
2.20.1



