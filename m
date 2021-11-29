Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A55461E57
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379007AbhK2Sf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37792 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379535AbhK2Sd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:33:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB24B815CE;
        Mon, 29 Nov 2021 18:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28069C53FAD;
        Mon, 29 Nov 2021 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210608;
        bh=5XxzqIbmaTosNEAtYD2VdF4vcJ5rQNvDoFyob4e30hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/dYlCL/1Tmk81u5w1N7SRKmTFlETVzIaJas1Y0H6UM442YuON7HuucZqDbmaTuR8
         Ic2Gchmte6rzOdP9NLeL+yGTY/Qsg7YJBc+P4/Een5695JR9SITMPsQZgpK32Y2pCU
         AdlUZtYmmQjhnXZtFaoF3mdbcdMkQwscol44J6S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/121] ARM: dts: bcm2711: Fix PCIe interrupts
Date:   Mon, 29 Nov 2021 19:17:58 +0100
Message-Id: <20211129181713.240825179@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 98481f3d72fb88cb5b973153434061015f094925 ]

The PCIe host bridge has two interrupt lines, one that goes towards it
PCIE_INTR2 second level interrupt controller and one for its MSI second
level interrupt controller. The first interrupt line is not currently
managed by the driver, which is why it was not a functional problem.

The interrupt-map property was also only listing the PCI_INTA interrupts
when there are also the INTB, C and D.

Reported-by: Jim Quinlan <jim2101024@gmail.com>
Fixes: d5c8dc0d4c88 ("ARM: dts: bcm2711: Enable PCIe controller")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index 398ecd7b9b68b..4ade854bdcdaf 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -480,11 +480,17 @@ pcie0: pcie@7d500000 {
 			#address-cells = <3>;
 			#interrupt-cells = <1>;
 			#size-cells = <2>;
-			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pcie", "msi";
 			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
 			interrupt-map = <0 0 0 1 &gicv2 GIC_SPI 143
+							IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 2 &gicv2 GIC_SPI 144
+							IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 3 &gicv2 GIC_SPI 145
+							IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 4 &gicv2 GIC_SPI 146
 							IRQ_TYPE_LEVEL_HIGH>;
 			msi-controller;
 			msi-parent = <&pcie0>;
-- 
2.33.0



