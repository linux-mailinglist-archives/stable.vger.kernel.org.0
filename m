Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D51E2F3012
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbhALNCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405510AbhALM6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70E72312E;
        Tue, 12 Jan 2021 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456302;
        bh=wBuEtDlE34cZvhKg94tf1u3hkx6HmvCvGAV4hgroIIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejxUsZ35SZwLH0gM/0aJxWH13nksZ8nLskziN8jkoYivijwCwofS4bDlnvPqXPclF
         tj8djOfTbc+WbloVB08qtXzC2DDg1/3ooKBym1qvgDaQywoTQaVQU4Pl1/lIlBPLVs
         iFdDJzHJkUe5NlKnoBsEX68QOHVTEpKr36ZNSYtyBL7RAE/TNqB5R4rqRwN7BmpziV
         yfnO2BGlelMfnbJelDo/rxcvMFQGrELIU3/Y7wB1FmuakHKUTBI4YhUwWiFMAEhT+z
         O3l0SD4pn+gfNE+zqLDZ0KlkK7ZKIQZzmzLkKHoy1VbeNdpR2CQBBt9ogdplbd13Cs
         mczJZzsXzwhGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/8] ARM: picoxcell: fix missing interrupt-parent properties
Date:   Tue, 12 Jan 2021 07:58:09 -0500
Message-Id: <20210112125810.71348-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125810.71348-1-sashal@kernel.org>
References: <20210112125810.71348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bac717171971176b78c72d15a8b6961764ab197f ]

dtc points out that the interrupts for some devices are not parsable:

picoxcell-pc3x2.dtsi:45.19-49.5: Warning (interrupts_property): /paxi/gem@30000: Missing interrupt-parent
picoxcell-pc3x2.dtsi:51.21-55.5: Warning (interrupts_property): /paxi/dmac@40000: Missing interrupt-parent
picoxcell-pc3x2.dtsi:57.21-61.5: Warning (interrupts_property): /paxi/dmac@50000: Missing interrupt-parent
picoxcell-pc3x2.dtsi:233.21-237.5: Warning (interrupts_property): /rwid-axi/axi2pico@c0000000: Missing interrupt-parent

There are two VIC instances, so it's not clear which one needs to be
used. I found the BSP sources that reference VIC0, so use that:

https://github.com/r1mikey/meta-picoxcell/blob/master/recipes-kernel/linux/linux-picochip-3.0/0001-picoxcell-support-for-Picochip-picoXcell-SoC.patch

Acked-by: Jamie Iles <jamie@jamieiles.com>
Link: https://lore.kernel.org/r/20201230152010.3914962-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
index 533919e96eaee..f22a6b4363177 100644
--- a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
+++ b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
@@ -54,18 +54,21 @@ paxi {
 		emac: gem@30000 {
 			compatible = "cadence,gem";
 			reg = <0x30000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <31>;
 		};
 
 		dmac1: dmac@40000 {
 			compatible = "snps,dw-dmac";
 			reg = <0x40000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <25>;
 		};
 
 		dmac2: dmac@50000 {
 			compatible = "snps,dw-dmac";
 			reg = <0x50000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <26>;
 		};
 
@@ -243,6 +246,7 @@ ebi@50000000 {
 		axi2pico@c0000000 {
 			compatible = "picochip,axi2pico-pc3x2";
 			reg = <0xc0000000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <13 14 15 16 17 18 19 20 21>;
 		};
 	};
-- 
2.27.0

