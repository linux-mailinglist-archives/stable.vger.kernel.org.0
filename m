Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0569A2F3071
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404990AbhALM6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404803AbhALM6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDC323135;
        Tue, 12 Jan 2021 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456244;
        bh=OKHKLW+H7BzHM5Duu10K/E0yrBIzpBum/JLmYHirgLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyE3vBuzdmM7KSSHwiGVsWY5BNTK680AJWm+RIdISt/a40u99KQLfhC+uPP9RVV66
         ySOpVOn94xNroEv4bTNZLp3C92/4ntQ5UiQR5GOHj8yQoIj74UZw/Jy7oclkGdqlpm
         p5w0/kLbPdW02r6haaCgd8ZWDSODTFI5jlUFPZda72wAf57zknNkbclB4w1yZdDC2e
         mQojepcvPPAP2Cl0nzvEzZObpAY6kf+hlJKkFW0/0Z2LnsCvTD6HcP2gonKHxBWwBd
         WCXEX/SFaUgM49ahDjyvLkGjN6eLTjCBfG2IkAds90jw0MidT8yvlgG65Us3jinyl5
         25kTMpmwVVMhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/28] ARM: picoxcell: fix missing interrupt-parent properties
Date:   Tue, 12 Jan 2021 07:56:44 -0500
Message-Id: <20210112125645.70739-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index 5ae8607883395..3fcc86d7b735f 100644
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
 
@@ -234,6 +237,7 @@ ebi@50000000 {
 		axi2pico@c0000000 {
 			compatible = "picochip,axi2pico-pc3x2";
 			reg = <0xc0000000 0x10000>;
+			interrupt-parent = <&vic0>;
 			interrupts = <13 14 15 16 17 18 19 20 21>;
 		};
 	};
-- 
2.27.0

