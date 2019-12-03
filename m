Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3B7111F60
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLCXHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfLCWra (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93E9D2084B;
        Tue,  3 Dec 2019 22:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413250;
        bh=J41T5dDACX6mMdDwcHJ66tJM39TIQDMBCyI3Q1j6VLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQZ+Ar8Y2tJQrZ6c6UITF6PJScOgRpUfqkf903DYkxGtcxM/Ay18GaFzyopAYV2/O
         6rvH0zaAwNWC61mT6OB3ybAvIOcVqvctXUQKZd1/KQDscuifshh1EE7n2+TEApkH0e
         mLZ8i0GxDFbtBdCoE4316X+Z68qdXyBjcFYfvSCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/321] ARM: dts: imx35: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:03 +0100
Message-Id: <20191203223430.137957855@linuxfoundation.org>
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

[ Upstream commit 8721610a6c2b8c42fc57819d8c3bfbb9166f95a3 ]

Boards based on imx35 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx35.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi | 1 +
 arch/arm/boot/dts/imx35-pdk.dts              | 1 +
 arch/arm/boot/dts/imx35.dtsi                 | 2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi b/arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi
index ba39d938f2891..5f8a47a9fcd40 100644
--- a/arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi
+++ b/arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi
@@ -18,6 +18,7 @@
 	compatible = "eukrea,cpuimx35", "fsl,imx35";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x8000000>; /* 128M */
 	};
 };
diff --git a/arch/arm/boot/dts/imx35-pdk.dts b/arch/arm/boot/dts/imx35-pdk.dts
index df613e88fd2c1..ddce0a844758b 100644
--- a/arch/arm/boot/dts/imx35-pdk.dts
+++ b/arch/arm/boot/dts/imx35-pdk.dts
@@ -11,6 +11,7 @@
 	compatible = "fsl,imx35-pdk", "fsl,imx35";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x8000000>,
 		      <0x90000000 0x8000000>;
 	};
diff --git a/arch/arm/boot/dts/imx35.dtsi b/arch/arm/boot/dts/imx35.dtsi
index 1c50b785cad47..b36b97b655dda 100644
--- a/arch/arm/boot/dts/imx35.dtsi
+++ b/arch/arm/boot/dts/imx35.dtsi
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
-- 
2.20.1



