Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A063A6146
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhFNKpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233838AbhFNKly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE55661428;
        Mon, 14 Jun 2021 10:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666916;
        bh=RxRzjs37Z16O8QQuSrx+MFkFoVjRhSb6rul8hbNnyUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmc1VJBUAU8iOq7K85o6ayFZ865dsaRIEVEMmuF77j7XpP2deHhC7P6NuN/Ns0Eq6
         /kTvwCz/yTZcyoxhGbRJnYz4t6CC7lfY7TR4uzZB2+pCTRteD24/igkNQa0vMrwtq2
         /KTvCzZi7QBtYZkJpcitK5x1BDlzBDchHLECrud0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.19 27/67] ARM: dts: imx6qdl-sabresd: Assign corresponding power supply for LDOs
Date:   Mon, 14 Jun 2021 12:27:10 +0200
Message-Id: <20210614102644.679892714@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <anson.huang@nxp.com>

commit 93385546ba369182220436f60ceb3beabe4b7de1 upstream.

On i.MX6Q/DL SabreSD board, vgen5 supplies vdd1p1/vdd2p5 LDO and
sw2 supplies vdd3p0 LDO, this patch assigns corresponding power
supply for vdd1p1/vdd2p5/vdd3p0 to avoid confusion by below log:

vdd1p1: supplied by regulator-dummy
vdd3p0: supplied by regulator-dummy
vdd2p5: supplied by regulator-dummy

With this patch, the power supply is more accurate:

vdd1p1: supplied by VGEN5
vdd3p0: supplied by SW2
vdd2p5: supplied by VGEN5

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |   12 ++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi         |    6 +++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -671,6 +671,18 @@
        vin-supply = <&sw1c_reg>;
 };
 
+&reg_vdd1p1 {
+	vin-supply = <&vgen5_reg>;
+};
+
+&reg_vdd3p0 {
+	vin-supply = <&sw2_reg>;
+};
+
+&reg_vdd2p5 {
+	vin-supply = <&vgen5_reg>;
+};
+
 &snvs_poweroff {
 	status = "okay";
 };
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -686,7 +686,7 @@
 					     <0 54 IRQ_TYPE_LEVEL_HIGH>,
 					     <0 127 IRQ_TYPE_LEVEL_HIGH>;
 
-				regulator-1p1 {
+				reg_vdd1p1: regulator-1p1 {
 					compatible = "fsl,anatop-regulator";
 					regulator-name = "vdd1p1";
 					regulator-min-microvolt = <1000000>;
@@ -701,7 +701,7 @@
 					anatop-enable-bit = <0>;
 				};
 
-				regulator-3p0 {
+				reg_vdd3p0: regulator-3p0 {
 					compatible = "fsl,anatop-regulator";
 					regulator-name = "vdd3p0";
 					regulator-min-microvolt = <2800000>;
@@ -716,7 +716,7 @@
 					anatop-enable-bit = <0>;
 				};
 
-				regulator-2p5 {
+				reg_vdd2p5: regulator-2p5 {
 					compatible = "fsl,anatop-regulator";
 					regulator-name = "vdd2p5";
 					regulator-min-microvolt = <2250000>;


