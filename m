Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D250C2F30F0
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbhALNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404188AbhALM5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1FCF23358;
        Tue, 12 Jan 2021 12:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456201;
        bh=mFrxYh/RcHcUNyoG0AC+OfhmXjHtTiAKE5866xLe/Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDqIKadpbUK0QN2ixHFts1FvbHE0UgsPyEilHlfUP5Oitj0oxDSBH/r5c3RzJ9Hx8
         8E2hR20OT+FGJ6a61Jm1QXDwmgc+Wj9u3dmV6wxHDDn4MD4c2O+92ue0D8zR21H3c5
         WoLJq5k+QXepR3Z/2qOsF21/QhRosEd8gWQnDoZnyU15HmeRXqnF+rTyZ2QOL6bklz
         nJdlHg1y3TQrVqJmdqKkBJ5vrj4BWm2XDcFhM42ziApWm5wdEYZSkbbzTlFbW85Thf
         WngOuTXFW7TywrbSDqeQSPUjG/NkCWH3ZW+fBfkhuUYkwcnGqZajQvVQUoJ9b0ET8Q
         Q/DXircVAo+Bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 50/51] ARM: picoxcell: fix missing interrupt-parent properties
Date:   Tue, 12 Jan 2021 07:55:32 -0500
Message-Id: <20210112125534.70280-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index c4c6c7e9e37b6..5898879a3038e 100644
--- a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
+++ b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
@@ -45,18 +45,21 @@ paxi {
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
 
@@ -233,6 +236,7 @@ ebi@50000000 {
 		axi2pico@c0000000 {
 			compatible = "picochip,axi2pico-pc3x2";
 			reg = <0xc0000000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <13 14 15 16 17 18 19 20 21>;
 		};
 	};
-- 
2.27.0

