Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472A931BCDA
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhBOPgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhBOPeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CFD64ECC;
        Mon, 15 Feb 2021 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403074;
        bh=2e99QUB4Tkv1LThWpAS43IFLnF2v8YDKpk1OdgW0sqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVwLeBXl4/pRdWc1bgPTJVlKyeUOGonq2w97sSfEWJaLL4dxq/vDz3vjm7Qmau3QO
         p0bnnF7GXrByf49O2y6kUry7OVnxS1gW33q9TRD7Ttyl767e1l5ZoPqkMTVmBkXcSn
         H28HBHQzVUMUnXEU4xOjDyIpZh3PPYx7qQbsrtyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/104] arm64: dts: rockchip: Fix PCIe DT properties on rk3399
Date:   Mon, 15 Feb 2021 16:26:31 +0100
Message-Id: <20210215152720.071790760@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -234,6 +234,7 @@
 		reg = <0x0 0xf8000000 0x0 0x2000000>,
 		      <0x0 0xfd000000 0x0 0x1000000>;
 		reg-names = "axi-base", "apb-base";
+		device_type = "pci";
 		#address-cells = <3>;
 		#size-cells = <2>;
 		#interrupt-cells = <1>;
@@ -252,7 +253,6 @@
 				<0 0 0 2 &pcie0_intc 1>,
 				<0 0 0 3 &pcie0_intc 2>,
 				<0 0 0 4 &pcie0_intc 3>;
-		linux,pci-domain = <0>;
 		max-link-speed = <1>;
 		msi-map = <0x0 &its 0x0 0x1000>;
 		phys = <&pcie_phy 0>, <&pcie_phy 1>,
-- 
2.27.0



