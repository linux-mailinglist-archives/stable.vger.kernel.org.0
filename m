Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D75F46271A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhK2XBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbhK2XAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B98C043CD0;
        Mon, 29 Nov 2021 10:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A01C4CE1626;
        Mon, 29 Nov 2021 18:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B4AC53FC7;
        Mon, 29 Nov 2021 18:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211010;
        bh=xsc1aAWlMbS7mY+1QE2TqEgslezv64uAQqQSKohAjw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlgVnaiECLSsfuYXK4ORM6v/XDMMEuKXaaKC6eRkrL7qcpvY+lj3WwgLHgv6GKMz8
         kCnQufGGUb2nJviO4upLSRM4r4yVtHwCCehzdUwFkK51b8hbiJ+iqGumvevu8qeff7
         KezjqGZbEQCouEBmII9ms/VVTZYTFBBDezqR8Aj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/179] ARM: dts: bcm2711: Fix PCIe interrupts
Date:   Mon, 29 Nov 2021 19:17:47 +0100
Message-Id: <20211129181721.356541681@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 3b60297af7f60..9e01dbca4a011 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -506,11 +506,17 @@ pcie0: pcie@7d500000 {
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



