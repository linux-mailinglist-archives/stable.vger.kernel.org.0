Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE9167422
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbgBUISs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387897AbgBUISs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A5624695;
        Fri, 21 Feb 2020 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273126;
        bh=TDkoGS8EQGsitpefjpC12149CPkH0ZYIZn/+H5Y4nlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yg8wnBekknHU8sgdDAeAAdjUeAGhCiT6dGwo022Jwit6fFUaTwOKvLCtUh5fSSWom
         cnEe9ry5gvbuBEtuCBVIyVeswmVQjrw/L42vdKl+avt+irZXRBgDlmpAarsorA8wRs
         5CEHdEZdxS+/UvOOMlvEJM+AKLYjXo27jDc0kxcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/191] arm64: dts: allwinner: H6: Add PMU mode
Date:   Fri, 21 Feb 2020 08:40:30 +0100
Message-Id: <20200221072258.346904899@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 7aa9b9eb7d6a8fde7acbe0446444f7e3fae1fe3b ]

Add the Performance Monitoring Unit (PMU) device tree node to the H6
.dtsi, which tells DT users which interrupts are triggered by PMU
overflow events on each core. The numbers come from the manual and have
been checked in U-Boot and with perf in Linux.

Tested with perf record and taskset on a Pine H64.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 72813e7aefb8a..bd43912696111 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -69,6 +69,16 @@
 		clock-output-names = "osc32k";
 	};
 
+	pmu {
+		compatible = "arm,cortex-a53-pmu",
+			     "arm,armv8-pmuv3";
+		interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
+	};
+
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
-- 
2.20.1



