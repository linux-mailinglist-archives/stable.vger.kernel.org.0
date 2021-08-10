Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310E23E7FB2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhHJRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhHJRkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772A261019;
        Tue, 10 Aug 2021 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617078;
        bh=O8J9V4VnQHX0jq0+mNkaZg3S+QXVY27tkx3Bagbnzs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jykcKNRMy7jCATapOteBldanMY8nUbHdr/gQN90jqBIyFTNl8Lv6JwGP9w0RbYSFx
         efZTp4pciR7rYyReny1grLkX4Elx8xbp3Duh4B0gMFh/magLOEh6NPUEkRzeHGd4BO
         u2B260KrLuG4WM0b0vFy8/YamkpGJkNHjWw4bmJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/135] arm64: dts: ls1028a: fix node name for the sysclk
Date:   Tue, 10 Aug 2021 19:28:59 +0200
Message-Id: <20210810172955.858626834@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 7e71b85473f863a29eb1c69265ef025389b4091d ]

U-Boot attempts to fix up the "clock-frequency" property of the "/sysclk" node:
https://elixir.bootlin.com/u-boot/v2021.04/source/arch/arm/cpu/armv8/fsl-layerscape/fdt.c#L512

but fails to do so:

  ## Booting kernel from Legacy Image at a1000000 ...
     Image Name:
     Created:      2021-06-08  10:31:38 UTC
     Image Type:   AArch64 Linux Kernel Image (gzip compressed)
     Data Size:    15431370 Bytes = 14.7 MiB
     Load Address: 80080000
     Entry Point:  80080000
     Verifying Checksum ... OK
  ## Flattened Device Tree blob at a0000000
     Booting using the fdt blob at 0xa0000000
     Uncompressing Kernel Image
     Loading Device Tree to 00000000fbb19000, end 00000000fbb22717 ... OK
  Unable to update property /sysclk:clock-frequency, err=FDT_ERR_NOTFOUND

  Starting kernel ...

All Layerscape SoCs except LS1028A use "sysclk" as the node name, and
not "clock-sysclk". So change the node name of LS1028A accordingly.

Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index f3b58bb9b840..5f42904d53ab 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -69,7 +69,7 @@
 		};
 	};
 
-	sysclk: clock-sysclk {
+	sysclk: sysclk {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <100000000>;
-- 
2.30.2



