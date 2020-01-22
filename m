Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86B014566F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgAVN0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbgAVN0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:51 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E778F2467F;
        Wed, 22 Jan 2020 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699610;
        bh=wjfFf6SBVt8xyoOx7ZZmse5Y7YB8YDW3SDtkpCvNTZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz/xk4UUFE+YxgP/9PMgoPQ0Ht1sEeas/ePxp+84siOJ/aJzq0Uc1O9j1MqDZRgj7
         0MP75ZdLine6tYk9mZZNuBm/jsnYDGrh1h7n41e5pD19vLfxQCKZe53eqCnB+o27FC
         nN9EcgdFb8WrVD/Awejrgh6DScS7syUrVgXiFxkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.4 188/222] arm64: dts: allwinner: a64: Re-add PMU node
Date:   Wed, 22 Jan 2020 10:29:34 +0100
Message-Id: <20200122092847.146268171@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

commit 6b832a148717f1718f57805a9a4aa7f092582d15 upstream.

As it was found recently, the Performance Monitoring Unit (PMU) on the
Allwinner A64 SoC was not generating (the right) interrupts. With the
SPI numbers from the manual the kernel did not receive any overflow
interrupts, so perf was not happy at all.
It turns out that the numbers were just off by 4, so the PMU interrupts
are from 148 to 151, not from 152 to 155 as the manual describes.

This was found by playing around with U-Boot, which typically does not
use interrupts, so the GIC is fully available for experimentation:
With *every* PPI and SPI enabled, an overflowing PMU cycle counter was
found to set a bit in one of the GICD_ISPENDR registers, with careful
counting this was determined to be number 148.

Tested with perf record and perf top on a Pine64-LTS. Also tested with
tasksetting to every core to confirm the assignment between IRQs and
cores.

This somewhat "revert-fixes" commit ed3e9406bcbc ("arm64: dts: allwinner:
a64: Drop PMU node").

Fixes: 34a97fcc71c2 ("arm64: dts: allwinner: a64: Add PMU node")
Fixes: ed3e9406bcbc ("arm64: dts: allwinner: a64: Drop PMU node")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -142,6 +142,15 @@
 		clock-output-names = "ext-osc32k";
 	};
 
+	pmu {
+		compatible = "arm,cortex-a53-pmu";
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


