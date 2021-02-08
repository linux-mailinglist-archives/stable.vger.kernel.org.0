Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BA8313C97
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhBHSIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhBHSDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2637D64EEB;
        Mon,  8 Feb 2021 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807189;
        bh=wPmpKzaMmcqvacjEw2wc2+06+yB2WqJNho5sWTARSE8=;
        h=From:To:Cc:Subject:Date:From;
        b=coRd55kkCrOFgS3hb/uGVEjui4VJV5j/2HCt5QY3u4ptbMk0lQYZB7u2bB3m6VYDL
         yGHaeDpVZV1t5MX0Av3ORBNzwCm/nrsH1n1HUBbi2ACqe4TfBBCksqxJwWnC+vMhI9
         CXvmR1/3KtOIqDP4bbLVmgFhqa2OH1IlIAkUzXDoblYb1XxV4LnGebWAOvTV4un5fp
         NXZJZ1oxtpC20htI6KljWhjTV4+aLAQlJPSaE7kUJYDc3j/CBGPmtgJBIzJzrmUZs2
         p8+A9VDZFRI+Jddvyg/wK7KuNoFM/AL0/r0S/1Md5JFns6skP7Yjm8BVaeagraGwl2
         KHojPxtshZ5Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/9] arm64: dts: rockchip: Fix PCIe DT properties on rk3399
Date:   Mon,  8 Feb 2021 12:59:38 -0500
Message-Id: <20210208175946.2092374-1-sashal@kernel.org>
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
index 82747048381fa..721f4b6b262f1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -231,6 +231,7 @@ pcie0: pcie@f8000000 {
 		reg = <0x0 0xf8000000 0x0 0x2000000>,
 		      <0x0 0xfd000000 0x0 0x1000000>;
 		reg-names = "axi-base", "apb-base";
+		device_type = "pci";
 		#address-cells = <3>;
 		#size-cells = <2>;
 		#interrupt-cells = <1>;
@@ -249,7 +250,6 @@ pcie0: pcie@f8000000 {
 				<0 0 0 2 &pcie0_intc 1>,
 				<0 0 0 3 &pcie0_intc 2>,
 				<0 0 0 4 &pcie0_intc 3>;
-		linux,pci-domain = <0>;
 		max-link-speed = <1>;
 		msi-map = <0x0 &its 0x0 0x1000>;
 		phys = <&pcie_phy 0>, <&pcie_phy 1>,
-- 
2.27.0

