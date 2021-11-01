Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CEC44186D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhKAJrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhKAJpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD037610E5;
        Mon,  1 Nov 2021 09:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759003;
        bh=16yzyGvnnqZ6gTct0rBZr0kOGbzeZz/KOZr72UBuYeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaMoyEtAZ1PQHzExzg8wX87nnMsj0ma62wA+3W5vpekmrM5Wzii8aK5G6SHtU4Zr4
         ZAm6Y3B6ZEwl0O0D2n12SizQ61xrDfahiqARGeVBVs+6gJ8UkXvGNrDy2SCeqBvUdF
         /qzD4SgHItcaEaR6R66HRSF365pGVmp7s4GPuqlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 041/125] arm64: dts: imx8mm-kontron: Make sure SOC and DRAM supply voltages are correct
Date:   Mon,  1 Nov 2021 10:16:54 +0100
Message-Id: <20211101082540.998172876@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 82a4f329b133ad0de66bee12c0be5c67bb8aa188 upstream.

It looks like the voltages for the SOC and DRAM supply weren't properly
validated before. The datasheet and uboot-imx code tells us that VDD_SOC
should be 800 mV in suspend and 850 mV in run mode. VDD_DRAM should be
950 mV for DDR clock frequencies of up to 1.5 GHz.

Let's fix these values to make sure the voltages are within the required
range.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -91,10 +91,12 @@
 			reg_vdd_soc: BUCK1 {
 				regulator-name = "buck1";
 				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <900000>;
+				regulator-max-microvolt = <850000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <3125>;
+				nxp,dvs-run-voltage = <850000>;
+				nxp,dvs-standby-voltage = <800000>;
 			};
 
 			reg_vdd_arm: BUCK2 {
@@ -111,7 +113,7 @@
 			reg_vdd_dram: BUCK3 {
 				regulator-name = "buck3";
 				regulator-min-microvolt = <850000>;
-				regulator-max-microvolt = <900000>;
+				regulator-max-microvolt = <950000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};


