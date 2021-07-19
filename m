Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823513CE5E0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350145AbhGSPyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350559AbhGSPvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01CD160FE9;
        Mon, 19 Jul 2021 16:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712232;
        bh=8esiyCORwngJstJX5kQgFXJPjEzeG3YogBs07zqqSsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9H7U1jK+Zr11qYC9WfzWkPvLoLR07jx+BX5SLJDCikrgZHEKubDfjJ6WtgKNHYKc
         Y89lqBIXVu7p+lL4qkuvun56tIUjxWNDidhHeOgJrJnYYYbs7URSI3YzVvvOoQvsTE
         XvqWgQ/H9iA/ZGkmvBqU2yTZvrm4FgAqIPXDWwOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 259/292] arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES
Date:   Mon, 19 Jul 2021 16:55:21 +0200
Message-Id: <20210719144951.447949086@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit f2a7657ad7a821de9cc77d071a5587b243144cd5 ]

Use external clock for all the SERDES used by PCIe controller. This will
make the same clock used by the local SERDES as well as the clock
provided to the PCIe connector.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210603143427.28735-4-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j721e-common-proc-board.dts     | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 86f7ab511ee8..1b25a5ae9635 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -9,6 +9,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/net/ti-dp83867.h>
+#include <dt-bindings/phy/phy-cadence.h>
 
 / {
 	chosen {
@@ -639,7 +640,40 @@
 	clock-frequency = <100000000>;
 };
 
+&wiz0_pll1_refclk {
+	assigned-clocks = <&wiz0_pll1_refclk>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
+&wiz0_refclk_dig {
+	assigned-clocks = <&wiz0_refclk_dig>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
+&wiz1_pll1_refclk {
+	assigned-clocks = <&wiz1_pll1_refclk>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
+&wiz1_refclk_dig {
+	assigned-clocks = <&wiz1_refclk_dig>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
+&wiz2_pll1_refclk {
+	assigned-clocks = <&wiz2_pll1_refclk>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
+&wiz2_refclk_dig {
+	assigned-clocks = <&wiz2_refclk_dig>;
+	assigned-clock-parents = <&cmn_refclk1>;
+};
+
 &serdes0 {
+	assigned-clocks = <&serdes0 CDNS_SIERRA_PLL_CMNLC>;
+	assigned-clock-parents = <&wiz0_pll1_refclk>;
+
 	serdes0_pcie_link: link@0 {
 		reg = <0>;
 		cdns,num-lanes = <1>;
@@ -650,6 +684,9 @@
 };
 
 &serdes1 {
+	assigned-clocks = <&serdes1 CDNS_SIERRA_PLL_CMNLC>;
+	assigned-clock-parents = <&wiz1_pll1_refclk>;
+
 	serdes1_pcie_link: link@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
@@ -660,6 +697,9 @@
 };
 
 &serdes2 {
+	assigned-clocks = <&serdes2 CDNS_SIERRA_PLL_CMNLC>;
+	assigned-clock-parents = <&wiz2_pll1_refclk>;
+
 	serdes2_pcie_link: link@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
-- 
2.30.2



