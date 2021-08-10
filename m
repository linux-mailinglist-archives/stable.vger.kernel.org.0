Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB8E3E7EB1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhHJRez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232339AbhHJReT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAA260FC4;
        Tue, 10 Aug 2021 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616837;
        bh=vwTuz80X8NSUJbf7mv0kN4u2+P1s6bKATQNj9B24vas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fz1tNHluMENH8Q1BWCIVNOJvr8Y3nuVwoFQhCc9fkxQh56ezT5D8Hx5VmcxKMKvud
         AXVVk1EKASPgKZXAeujBHKDpddw6QRCVNiCvGyJwqruXRkCK5sZtg/ey0oGCyR5phN
         bxZvmf0Mbdk0jAu68PyhK6arePr0fN21d7LmRwws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/85] arm64: dts: ls1028a: fix node name for the sysclk
Date:   Tue, 10 Aug 2021 19:29:36 +0200
Message-Id: <20210810172948.317524696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
index 5a2a188debd1..5716ac20bddd 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -65,7 +65,7 @@
 		};
 	};
 
-	sysclk: clock-sysclk {
+	sysclk: sysclk {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <100000000>;
-- 
2.30.2



