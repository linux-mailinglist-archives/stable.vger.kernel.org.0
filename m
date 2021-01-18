Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253B72FAA9E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437044AbhART0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390393AbhARLhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C040A229C6;
        Mon, 18 Jan 2021 11:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969784;
        bh=NYavTJCf3mSOA+70l+TusabymJ0buWA/rdHDdRRk9Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x65232TxkuyOa/jP4DBV94jTlzCTa9YzmK4MvycaH8bsH6ZeIvIUv3XCjcwojJAgy
         s+hggDiEF9Gl0VgOePZ+UW0KYKUcIiwZmxxpPkDggO1pCFp+vG1d39wZ828QZwnLl7
         CCDR0g+s3XUcYZEdXBPuVyPm31Be+vGIKH32B/DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/43] ARM: picoxcell: fix missing interrupt-parent properties
Date:   Mon, 18 Jan 2021 12:34:47 +0100
Message-Id: <20210118113336.109849698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a1266cf8776ce..8362c6a3bcd30 100644
--- a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
+++ b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
@@ -54,18 +54,21 @@
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
 
@@ -243,6 +246,7 @@
 		axi2pico@c0000000 {
 			compatible = "picochip,axi2pico-pc3x2";
 			reg = <0xc0000000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <13 14 15 16 17 18 19 20 21>;
 		};
 	};
-- 
2.27.0



