Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBF2111CD5
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfLCWr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbfLCWr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FA1420684;
        Tue,  3 Dec 2019 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413275;
        bh=qQ7ADBan6Cki+gjs7P4HZzdhbGN9+BaZSrq2OioHsOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE0mln7vNUGN9cFet09Jo0RBuYaMsc2i3J5Ct4qRSPDWIYmuyzjrd+WtXXAyvI2tc
         WNn2wJkWP5SEuaB518YzYyGwiH63y4qFVwLWv8RR9aDsMUKtuQD/ZySEVJo+CI5eel
         PpNOEA4koFiD7pPCEAw2WeIjRd195WrHr04zH/lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/321] ARM: dts: imx25: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:12 +0100
Message-Id: <20191203223430.602770010@linuxfoundation.org>
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

[ Upstream commit 59d8bb363f563e4a147a291037bf979cb8ff9a59 ]

Boards based on imx25 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx25.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi | 1 +
 arch/arm/boot/dts/imx25-karo-tx25.dts        | 1 +
 arch/arm/boot/dts/imx25-pdk.dts              | 1 +
 arch/arm/boot/dts/imx25.dtsi                 | 2 --
 4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi b/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
index e316fe08837a3..e4d7da267532d 100644
--- a/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
+++ b/arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi
@@ -18,6 +18,7 @@
 	compatible = "eukrea,cpuimx25", "fsl,imx25";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x4000000>; /* 64M */
 	};
 };
diff --git a/arch/arm/boot/dts/imx25-karo-tx25.dts b/arch/arm/boot/dts/imx25-karo-tx25.dts
index 5cb6967866c0a..f37e9a75a3ca7 100644
--- a/arch/arm/boot/dts/imx25-karo-tx25.dts
+++ b/arch/arm/boot/dts/imx25-karo-tx25.dts
@@ -37,6 +37,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x02000000 0x90000000 0x02000000>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx25-pdk.dts b/arch/arm/boot/dts/imx25-pdk.dts
index a5626b46ac4e1..f8544a9e46330 100644
--- a/arch/arm/boot/dts/imx25-pdk.dts
+++ b/arch/arm/boot/dts/imx25-pdk.dts
@@ -12,6 +12,7 @@
 	compatible = "fsl,imx25-pdk", "fsl,imx25";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x4000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index 85c15ee632727..8c8ad80de4614 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -12,10 +12,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		ethernet0 = &fec;
-- 
2.20.1



