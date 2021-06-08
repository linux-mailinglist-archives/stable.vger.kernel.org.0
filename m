Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8C93A00A7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhFHSqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235195AbhFHSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:43:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91FC36144F;
        Tue,  8 Jun 2021 18:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177383;
        bh=xiJS5thhRmnys9y3vwaDaKeRbmJBDwu85ynvv3WWO5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDBrtzsF3ovxPAC7i8VTwCaLZUTkCHW08gTprv47dvHJN2Vh+M2eSQv/SdmCImel3
         E30ZHToC8viuaSrifTWrYWiKufkWmqURgTVEQW3q5BtPItwcELfb23FKsVwFNTFCz7
         risTtvF+PKTw4Vk7DN5ZraqkbucUnAxrsvOhKBHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/78] arm64: dts: ls1028a: fix memory node
Date:   Tue,  8 Jun 2021 20:26:59 +0200
Message-Id: <20210608175936.283096896@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit dabea675faf16e8682aa478ff3ce65dd775620bc ]

While enabling EDAC support for the LS1028A it was discovered that the
memory node has a wrong endianness setting as well as a wrong interrupt
assignment. Fix both.

This was tested on a sl28 board. To force ECC errors, you can use the
error injection supported by the controller in hardware (with
CONFIG_EDAC_DEBUG enabled):

 # enable error injection
 $ echo 0x100 > /sys/devices/system/edac/mc/mc0/inject_ctrl
 # flip lowest bit of the data
 $ echo 0x1 > /sys/devices/system/edac/mc/mc0/inject_data_lo

Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index bd99fa68b763..5a2a188debd1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -151,8 +151,8 @@
 		ddr: memory-controller@1080000 {
 			compatible = "fsl,qoriq-memory-controller";
 			reg = <0x0 0x1080000 0x0 0x1000>;
-			interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
-			big-endian;
+			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+			little-endian;
 		};
 
 		dcfg: syscon@1e00000 {
-- 
2.30.2



