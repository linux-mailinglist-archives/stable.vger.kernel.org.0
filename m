Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3C5313C0F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhBHSAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235113AbhBHR7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:59:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDBC264E87;
        Mon,  8 Feb 2021 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807095;
        bh=iFWC2DtP+Zvyu7SqrESfK1vWP5a8+/pgdlP0zwg4DB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5S+rE337Yd3hiFU81wXbnnu8ZoruYoWy7O2/H77fRNdvGjanZevUg9ra/BuQLozL
         9TceuZe/Zf8L3I7yqCNPi2Y4XzCiZvW1JA16KnmEQOjB+znu9cfKfNLzR2LGxsgo3+
         NK61dz8OeN1Ot6x/6//W/ArOqKfpj1K1noOu846ijLPiu56aLfPTWn+MjLdpaL3I2r
         TNBNdx5ueMYEFX50qL59qQewQvOVgjvXPptVEJaGIerzYkysqdn2hsQ9+dvcQW79RB
         eFf+jqoemH2gvgAb1OFGsZ8jXwljoBZLmROO2DWq58Zk9GVqikkcrAWKBdpGKwOKMO
         27pBALffwPAYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 06/36] arm64: dts: rockchip: remove interrupt-names property from rk3399 vdec node
Date:   Mon,  8 Feb 2021 12:57:36 -0500
Message-Id: <20210208175806.2091668-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 94a5400f8b966c91c49991bae41c2ef911b935ac ]

A test with the command below gives this error:
/arch/arm64/boot/dts/rockchip/rk3399-evb.dt.yaml: video-codec@ff660000:
'interrupt-names' does not match any of the regexes: 'pinctrl-[0-9]+'

The rkvdec driver gets it irq with help of the platform_get_irq()
function, so remove the interrupt-names property from the rk3399
vdec node.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/
media/rockchip,vdec.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210117181653.24886-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 5df535ad4bbc3..7e69603fb41c0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1278,7 +1278,6 @@ vdec: video-codec@ff660000 {
 		compatible = "rockchip,rk3399-vdec";
 		reg = <0x0 0xff660000 0x0 0x400>;
 		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
-		interrupt-names = "vdpu";
 		clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
 			 <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
 		clock-names = "axi", "ahb", "cabac", "core";
-- 
2.27.0

