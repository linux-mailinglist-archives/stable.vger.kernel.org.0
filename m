Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7858300B82
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbhAVSjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbhAVORx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:17:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C41A239EF;
        Fri, 22 Jan 2021 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324820;
        bh=i4Nmwe5miPe3Gw6FrnUEcFoxmdlKxZr3pmtpSqvRZP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCIzP7kMqIX53YQ7nTyIUnB52mnTpTuD7MhwxtKoeJSTiikenb+RnxO8LWcsxOqee
         StWnp9PMEKM5ON4Wfi/qyUo8IhxF0LbVg0d8DXPw7ryFAl7SETYXcOdqNrIur+7j9c
         QCSf3PivAXWbOG+/4ZLbjZbN162RqrFCLOEZiKTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/50] ARM: picoxcell: fix missing interrupt-parent properties
Date:   Fri, 22 Jan 2021 15:12:00 +0100
Message-Id: <20210122135735.968241940@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
index 533919e96eaee..f22a6b4363177 100644
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



