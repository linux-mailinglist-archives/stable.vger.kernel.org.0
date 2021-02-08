Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344FE313BF2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhBHR7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235019AbhBHR6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:58:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7739864E84;
        Mon,  8 Feb 2021 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807090;
        bh=XNLkFAXZajpl1pvSlYYyiojg6Cj6P5AJkvwdFzbavls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUQyfz36Emg/KIlt81Y9MZ0KLlQRsZgRitaB8klq7n3RoaZLwz9k941fyzXyoCUxq
         RnGdOiaCdcNPjkqXCrxf80HYkyZBrkvAhgRePGHKn4bijhohL5wUFVLri8bVeZU2N4
         Oz5NCZYSuB/OmnbFP+xnH5kv/4yVlpVGNf605Y/lHbBMD5UpECcck7lTkNEJiNzkFF
         WMrX2CfppuLG2bhIs40tkoF+L+vnX6HljD0272bPUe5ZE0IXnYE+m9dI8oi8NWIAQq
         bKdrgvImG1UGzqI4PNX7H2CHVgTkOLJ8laFRyLc89l5vfU/vAl+Lzxn8gLoCrt5P8f
         8k3Vrltt5CwEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/36] arm64: dts: rockchip: Fix PCIe DT properties on rk3399
Date:   Mon,  8 Feb 2021 12:57:32 -0500
Message-Id: <20210208175806.2091668-2-sashal@kernel.org>
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
index 7a9a7aca86c6a..5df535ad4bbc3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -234,6 +234,7 @@ pcie0: pcie@f8000000 {
 		reg = <0x0 0xf8000000 0x0 0x2000000>,
 		      <0x0 0xfd000000 0x0 0x1000000>;
 		reg-names = "axi-base", "apb-base";
+		device_type = "pci";
 		#address-cells = <3>;
 		#size-cells = <2>;
 		#interrupt-cells = <1>;
@@ -252,7 +253,6 @@ pcie0: pcie@f8000000 {
 				<0 0 0 2 &pcie0_intc 1>,
 				<0 0 0 3 &pcie0_intc 2>,
 				<0 0 0 4 &pcie0_intc 3>;
-		linux,pci-domain = <0>;
 		max-link-speed = <1>;
 		msi-map = <0x0 &its 0x0 0x1000>;
 		phys = <&pcie_phy 0>, <&pcie_phy 1>,
-- 
2.27.0

