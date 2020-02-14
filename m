Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE115EDBE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390155AbgBNQFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390148AbgBNQFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB7824681;
        Fri, 14 Feb 2020 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696319;
        bh=8HUB1l7K/kfrc9BPVRbNuWolaKKk6PF6kPZqwuYtyTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxE/z+Slei+YF8x+h/ggXz1TTZkFpWjzin5tul9TCjmqghJiKfeCfuaOex3eKPC8i
         soBYRGuKLZmKpwcNRuIzYMCOTfTcTo/9yMXXsvPGlKBpMCLQrY+EBd4Uy9t7al3yLO
         rwKjXVR/2JByedbXgCC6YydIO3ISME0FJVC/AThw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 160/459] arm64: dts: allwinner: H5: Add PMU node
Date:   Fri, 14 Feb 2020 10:56:50 -0500
Message-Id: <20200214160149.11681-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit c35a516a46187c8eeb7a56c64505ec6f7e22a0c7 ]

Add the Performance Monitoring Unit (PMU) device tree node to the H5
.dtsi, which tells DT users which interrupts are triggered by PMU
overflow events on each core.
As with the A64, the interrupt numbers from the manual were wrong (off
by 4), the actual SPI IDs have been gathered in U-Boot, and were
verified with perf in Linux.

Tested with perf record and taskset on an OrangePi PC2.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index f002a496d7cbb..1d34e3eefda3f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -54,21 +54,21 @@
 			enable-method = "psci";
 		};
 
-		cpu@1 {
+		cpu1: cpu@1 {
 			compatible = "arm,cortex-a53";
 			device_type = "cpu";
 			reg = <1>;
 			enable-method = "psci";
 		};
 
-		cpu@2 {
+		cpu2: cpu@2 {
 			compatible = "arm,cortex-a53";
 			device_type = "cpu";
 			reg = <2>;
 			enable-method = "psci";
 		};
 
-		cpu@3 {
+		cpu3: cpu@3 {
 			compatible = "arm,cortex-a53";
 			device_type = "cpu";
 			reg = <3>;
@@ -76,6 +76,16 @@
 		};
 	};
 
+	pmu {
+		compatible = "arm,cortex-a53-pmu",
+			     "arm,armv8-pmuv3";
+		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
+	};
+
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
-- 
2.20.1

