Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F343D29F9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhGVQH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhGVQGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F4D61DBA;
        Thu, 22 Jul 2021 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972431;
        bh=xvudn0hGRP+WmZLEFWuJFAJ+NHZMuz8xxxHGzXolnOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crFReoHLHeNix3ygK5O/9KnwDlY2YFidD4yZxISKKQFpLs1RqYl82qKEjAa1mBMc7
         aQt8pqWX3R2FIjT7tkyDeciUOWYXVqh/3GLPD8uzPy1IVVD65pSBnAG0TtDynVp/ce
         F66URRjEJokmV3REnkOeLXk13fZRj2Y19Hs/hEcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Punit Agrawal <punitagrawal@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/156] arm64: dts: rockchip: Update RK3399 PCI host bridge window to 32-bit address memory
Date:   Thu, 22 Jul 2021 18:30:52 +0200
Message-Id: <20210722155630.886680369@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punitagrawal@gmail.com>

[ Upstream commit 8efe01b4386ab38a36b99cfdc1dc02c38a8898c3 ]

The PCIe host bridge on RK3399 advertises a single 64-bit memory
address range even though it lies entirely below 4GB.

Previously the OF PCI range parser treated 64-bit ranges more
leniently (i.e., as 32-bit), but since commit 9d57e61bf723 ("of/pci:
Add IORESOURCE_MEM_64 to resource flags for 64-bit memory addresses")
the code takes a stricter view and treats the ranges as advertised in
the device tree (i.e, as 64-bit).

The change in behaviour causes failure when allocating bus addresses
to devices connected behind a PCI-to-PCI bridge that require
non-prefetchable memory ranges. The allocation failure was observed
for certain Samsung NVMe drives connected to RockPro64 boards.

Update the host bridge window attributes to treat it as 32-bit address
memory. This fixes the allocation failure observed since commit
9d57e61bf723.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/7a1e2ebc-f7d8-8431-d844-41a9c36a8911@arm.com
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20210607112856.3499682-5-punitagrawal@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 1703817c7354..7f8081f9e30e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -227,7 +227,7 @@
 		       <&pcie_phy 2>, <&pcie_phy 3>;
 		phy-names = "pcie-phy-0", "pcie-phy-1",
 			    "pcie-phy-2", "pcie-phy-3";
-		ranges = <0x83000000 0x0 0xfa000000 0x0 0xfa000000 0x0 0x1e00000>,
+		ranges = <0x82000000 0x0 0xfa000000 0x0 0xfa000000 0x0 0x1e00000>,
 			 <0x81000000 0x0 0xfbe00000 0x0 0xfbe00000 0x0 0x100000>;
 		resets = <&cru SRST_PCIE_CORE>, <&cru SRST_PCIE_MGMT>,
 			 <&cru SRST_PCIE_MGMT_STICKY>, <&cru SRST_PCIE_PIPE>,
-- 
2.30.2



