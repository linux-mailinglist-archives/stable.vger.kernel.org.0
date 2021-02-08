Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68849313C65
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhBHSGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235148AbhBHSCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:02:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1F864EC2;
        Mon,  8 Feb 2021 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807141;
        bh=3m9DxGXNsBBhzo/s+0wFSYIudIWh4M8a/6fbq7tYbsw=;
        h=From:To:Cc:Subject:Date:From;
        b=qyYGwH82DRlTihlEq6OMlAC0e9Um7gaPTawpCjf8I49WVlJi4fBcihyQWd3HHRROz
         dxHlkgP5iWDr+5i51hcBtl1G/Vbzx/PT4tNVFVTL6bAXjpUZvxXsrQSgs6BdpbD6Fk
         xghR+d4Zt7t+/xAxHh3JwBIpnI7+HR7ezJohcsJ4LjjLf6IZLINn2wbTE0/49b2TKi
         IQVJd05RTwxe/RcfxYGCZxqHaamaETLk3eD9KXUl7jfGAJ5jiyu3frIokrNpHISD+/
         F8yhgnnRYfboZWbPd4rMWHGkopbzHEFU1fR1cxRdHKxhO41Pm5w8BKJAeQjdUdtnCH
         vZwkVHK+KSZ2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 01/19] arm64: dts: rockchip: Fix PCIe DT properties on rk3399
Date:   Mon,  8 Feb 2021 12:58:40 -0500
Message-Id: <20210208175858.2092008-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 43f20b1c6140896916f4e91aacc166830a7ba849 ]

It recently became apparent that the lack of a 'device_type = "pci"'
in the PCIe root complex node for rk3399 is a violation of the PCI
binding, as documented in IEEE Std 1275-1994. Changes to the kernel's
parsing of the DT made such violation fatal, as drivers cannot
probe the controller anymore.

Add the missing property makes the PCIe node compliant. While we
are at it, drop the pointless linux,pci-domain property, which only
makes sense when there are multiple host bridges.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200815125112.462652-3-maz@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index bb7d0aac6b9db..9d6ed8cda2c86 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -232,6 +232,7 @@ pcie0: pcie@f8000000 {
 		reg = <0x0 0xf8000000 0x0 0x2000000>,
 		      <0x0 0xfd000000 0x0 0x1000000>;
 		reg-names = "axi-base", "apb-base";
+		device_type = "pci";
 		#address-cells = <3>;
 		#size-cells = <2>;
 		#interrupt-cells = <1>;
@@ -250,7 +251,6 @@ pcie0: pcie@f8000000 {
 				<0 0 0 2 &pcie0_intc 1>,
 				<0 0 0 3 &pcie0_intc 2>,
 				<0 0 0 4 &pcie0_intc 3>;
-		linux,pci-domain = <0>;
 		max-link-speed = <1>;
 		msi-map = <0x0 &its 0x0 0x1000>;
 		phys = <&pcie_phy 0>, <&pcie_phy 1>,
-- 
2.27.0

