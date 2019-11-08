Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC21AF55E2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbfKHTF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbfKHTFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C57F620650;
        Fri,  8 Nov 2019 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239924;
        bh=SnSrBVejywLMeyE9C0F/6AVkXlcUCkdN+mdYWqUZVu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5JyML/dwbG4UOZLhHNM5oFZ3aDNWguArjCZHrTQ4Zp7fjzQiKlFuKEiSKcHfkVXi
         I+Ng5YL6R1xTqmkE8BlYweMwpVZosU3s4anadyI8Ucao9ur778okwO0x8a4PvR1j3K
         h+OsQZKADgKsCz+6SzLl3KmO5BOexocv8Hnqzku0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harald Geyer <harald@ccbib.org>,
        "Jared D. McNeill" <jmcneill@NetBSD.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Emmanuel Vadot <manu@FreeBSD.org>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 007/140] arm64: dts: allwinner: a64: Drop PMU node
Date:   Fri,  8 Nov 2019 19:48:55 +0100
Message-Id: <20191108174901.368958757@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit ed3e9406bcbc32f84dc4aa4cb4767852e5ab086c ]

Looks like PMU in A64 is broken, it generates no interrupts at all and
as result 'perf top' shows no events.

Tested on Pine64-LTS.

Fixes: 34a97fcc71c2 ("arm64: dts: allwinner: a64: Add PMU node")
Cc: Harald Geyer <harald@ccbib.org>
Cc: Jared D. McNeill <jmcneill@NetBSD.org>
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Emmanuel Vadot <manu@FreeBSD.org>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 9cc9bdde81ac2..cd92f546c4838 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -142,15 +142,6 @@
 		clock-output-names = "ext-osc32k";
 	};
 
-	pmu {
-		compatible = "arm,cortex-a53-pmu";
-		interrupts = <GIC_SPI 152 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 153 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
-	};
-
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
-- 
2.20.1



