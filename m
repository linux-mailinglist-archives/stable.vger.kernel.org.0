Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C553CE24D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348053AbhGSP36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348120AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 146FF61448;
        Mon, 19 Jul 2021 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710521;
        bh=ZiHeNXEw0+M1lKHuz3XUPD3ArO1nyNsZflgnMZb2AZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTRVYBlq1CrvxwRYXGVnmbzIq+bWUi/1inmFhk8yDDOT30fpqspMBlaQ5t3iPZuYE
         VOxfl64yvVyApKqSMxAh8Q2xgj+G/zrlyUdHnVU6HXGM4LZg/Q/wsTDY3rJ3gKl3Y3
         WYSK4NsFoTBDhpoPeBapGsHwTfGNo8AyQ6PTOUbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/243] arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES
Date:   Mon, 19 Jul 2021 16:54:05 +0200
Message-Id: <20210719144947.891096868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 7cd31ac67f88..56a92f59c3a1 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -9,6 +9,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/net/ti-dp83867.h>
+#include <dt-bindings/phy/phy-cadence.h>
 
 / {
 	chosen {
@@ -564,7 +565,40 @@
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
@@ -575,6 +609,9 @@
 };
 
 &serdes1 {
+	assigned-clocks = <&serdes1 CDNS_SIERRA_PLL_CMNLC>;
+	assigned-clock-parents = <&wiz1_pll1_refclk>;
+
 	serdes1_pcie_link: link@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
@@ -585,6 +622,9 @@
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



