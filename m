Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA111B47D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732841AbfLKPZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732782AbfLKPZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D26208C3;
        Wed, 11 Dec 2019 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077930;
        bh=8E4J7fMbM6LkudO+9F/RC+PJKcsy8gwUCsIbxesTyQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFb2k0vmyz09vCqUo4gd/tD+9uRb7n5sBuUm66mP6Kdsx/kItO2o41CYMNF/spmln
         UzpE0jk1U654vvXaYMuWyJTcp4kDmOup9n/PN33cM7iZO1yKP9pTjgiJeZLiD0nfwm
         0iZc7xrssxMGGtB2FWvMLSQS7nRdf6/9VU7cOUn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 224/243] arm64: dts: exynos: Revert "Remove unneeded address space mapping for soc node"
Date:   Wed, 11 Dec 2019 16:06:26 +0100
Message-Id: <20191211150354.452202223@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit bed903167ae5b5532eda5d7db26de451bd232da5 upstream.

Commit ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space
mapping for soc node") changed the address and size cells in root node from
2 to 1, but /memory nodes for the affected boards were not updated. This
went unnoticed on Exynos5433-based TM2(e) boards, because they use u-boot,
which updates /memory node to the correct values. On the other hand, the
mentioned commit broke boot on Exynos7-based Espresso board, which
bootloader doesn't touch /memory node at all.

This patch reverts commit ef72171b3621 ("arm64: dts: exynos: Remove
unneeded address space mapping for soc node"), so Exynos5433 and Exynos7
SoCs again matches other ARM64 platforms with 64bit mappings in root
node.

Reported-by: Alim Akhtar <alim.akhtar@samsung.com>
Fixes: ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space mapping for soc node")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org> # 5.3.x: 72ddcf6aa224 arm64: dts: exynos: Move GPU under /soc node for Exynos5433
Cc: <stable@vger.kernel.org> # 5.3.x: ede87c3a2bdb arm64: dts: exynos: Move GPU under /soc node for Exynos7
Cc: <stable@vger.kernel.org> # 4.18.x
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi |    6 +++---
 arch/arm64/boot/dts/exynos/exynos7.dtsi    |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -18,8 +18,8 @@
 
 / {
 	compatible = "samsung,exynos5433";
-	#address-cells = <1>;
-	#size-cells = <1>;
+	#address-cells = <2>;
+	#size-cells = <2>;
 
 	interrupt-parent = <&gic>;
 
@@ -235,7 +235,7 @@
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges;
+		ranges = <0x0 0x0 0x0 0x18000000>;
 
 		arm_a53_pmu {
 			compatible = "arm,cortex-a53-pmu", "arm,armv8-pmuv3";
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -12,8 +12,8 @@
 / {
 	compatible = "samsung,exynos7";
 	interrupt-parent = <&gic>;
-	#address-cells = <1>;
-	#size-cells = <1>;
+	#address-cells = <2>;
+	#size-cells = <2>;
 
 	aliases {
 		pinctrl0 = &pinctrl_alive;
@@ -70,7 +70,7 @@
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges;
+		ranges = <0 0 0 0x18000000>;
 
 		chipid@10000000 {
 			compatible = "samsung,exynos4210-chipid";


