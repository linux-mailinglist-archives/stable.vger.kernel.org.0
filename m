Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCA53CDFF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345176AbhGSPMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343990AbhGSPLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62AC460FD7;
        Mon, 19 Jul 2021 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709912;
        bh=+R4RtJdrIx78hn1+MScHKhnw7kRDMo4OH3kSQsH12yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ARwVQVuR5vqUI4gqrMqt5QX+8AzF4cio5728c4BtsJ9pbctlugT9t1Vqk8nlDysq
         9Qk8VimeZwO4JGYZHjUln1jetjfHrHcPUHj6T4lKEaVNyacaTlef81cGvrLg66RlHM
         57jLfL3EWicHIK9foSl8s8oirjrFaapDWK+IMiEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/149] ARM: dts: BCM5301X: Fixup SPI binding
Date:   Mon, 19 Jul 2021 16:53:58 +0200
Message-Id: <20210719144932.133301671@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit d5aede3e6dd1b8ca574600a1ecafe1e580c53f2f ]

1. Reorder interrupts
2. Fix typo: s/spi_lr_overhead/spi_lr_overread/
3. Rename node: s/spi-nor@0/flash@0/

This fixes:
arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dt.yaml: spi@18029200: interrupt-names: 'oneOf' conditional failed, one must be fixed:
        ['spi_lr_fullness_reached', 'spi_lr_session_aborted', 'spi_lr_impatient', 'spi_lr_session_done', 'spi_lr_overhead', 'mspi_done', 'mspi_halted'] is too long
        Additional items are not allowed ('spi_lr_session_aborted', 'spi_lr_impatient', 'spi_lr_session_done', 'spi_lr_overhead', 'mspi_done', 'mspi_halted' were unexpected)
        'mspi_done' was expected
        'spi_l1_intr' was expected
        'mspi_halted' was expected
        'spi_lr_fullness_reached' was expected
        'spi_lr_session_aborted' was expected
        'spi_lr_impatient' was expected
        'spi_lr_session_done' was expected
        'spi_lr_overread' was expected
        From schema: Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml
arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dt.yaml: spi-nor@0: $nodename:0: 'spi-nor@0' does not match '^flash(@.*)?$'
        From schema: Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 0016720ce530..9711170649b6 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -494,27 +494,27 @@
 		      <0x1811b408 0x004>,
 		      <0x180293a0 0x01c>;
 		reg-names = "mspi", "bspi", "intr_regs", "intr_status_reg";
-		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "spi_lr_fullness_reached",
+			     <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "mspi_done",
+				  "mspi_halted",
+				  "spi_lr_fullness_reached",
 				  "spi_lr_session_aborted",
 				  "spi_lr_impatient",
 				  "spi_lr_session_done",
-				  "spi_lr_overhead",
-				  "mspi_done",
-				  "mspi_halted";
+				  "spi_lr_overread";
 		clocks = <&iprocmed>;
 		clock-names = "iprocmed";
 		num-cs = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		spi_nor: spi-nor@0 {
+		spi_nor: flash@0 {
 			compatible = "jedec,spi-nor";
 			reg = <0>;
 			spi-max-frequency = <20000000>;
-- 
2.30.2



