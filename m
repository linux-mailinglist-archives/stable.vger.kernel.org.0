Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B91670CD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgBUHsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbgBUHsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:48:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 843A020801;
        Fri, 21 Feb 2020 07:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271294;
        bh=j27L0uvNh+GXvHJve/VVwZnTA0Mp4pOfRumbA87sMpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hivSmJTSn3tkZIn+NG38H/ckpTDignhgkMIzaBAa/rzNXhcyHqrhriNphMrJ84ieA
         +PwKhdAvr0DZa3n7hTok4qI8U0vEmE98x4JjWCBwxFdgVPSH0XBE5o1lK3vUtHWDaJ
         p49Ef5aqxhQHyLUr6sKuAJsxMrdnYKfbBtru372I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 110/399] arm64: dts: rockchip: Fix NanoPC-T4 cooling maps
Date:   Fri, 21 Feb 2020 08:37:15 +0100
Message-Id: <20200221072413.128831313@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit a793e19c15f25a126138ac4ae9facf9204754af3 ]

Although it appeared to follow logically from the bindings, apparently
the thermal framework can't properly cope with a single cooling device
being shared between multiple maps. The CPU zone is probably easier to
overheat, so remove the references to the (optional) fan from the GPU
cooling zone to avoid things getting confused. Hopefully GPU-intensive
tasks will leak enough heat across to the CPU zone to still hit the
fan trips before reaching critical GPU temperatures.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/5bb39f3115df1a487d717d3ae87e523b03749379.1573908197.git.robin.murphy@arm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3399-nanopc-t4.dts    | 27 -------------------
 1 file changed, 27 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
index 2a127985ab171..d3ed8e5e770f1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
@@ -94,33 +94,6 @@
 	};
 };
 
-&gpu_thermal {
-	trips {
-		gpu_warm: gpu_warm {
-			temperature = <55000>;
-			hysteresis = <2000>;
-			type = "active";
-		};
-
-		gpu_hot: gpu_hot {
-			temperature = <65000>;
-			hysteresis = <2000>;
-			type = "active";
-		};
-	};
-	cooling-maps {
-		map1 {
-			trip = <&gpu_warm>;
-			cooling-device = <&fan THERMAL_NO_LIMIT 1>;
-		};
-
-		map2 {
-			trip = <&gpu_hot>;
-			cooling-device = <&fan 2 THERMAL_NO_LIMIT>;
-		};
-	};
-};
-
 &pinctrl {
 	ir {
 		ir_rx: ir-rx {
-- 
2.20.1



