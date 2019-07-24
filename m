Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A76B7391D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbfGXThC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389377AbfGXThB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D2620665;
        Wed, 24 Jul 2019 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997020;
        bh=wLenPchzmHu2bxlRqWuzksxeHYWnPHMNI1svPZQDuIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0rJPAae0UwSXEL86pS80KUwcjaOCSiyv/zG8Deq+yAt7fzK7f74c/BWWKhO1w6lZ
         oLZJnX+pz/iZilqRjUZ5zqc3mw5BTyuW5RluGZEU5issbc+4HSJlrUx7DBDR/kyDwD
         GI4AIiuQ5cEg2LlohrCfBkQRiq33VII6Ej3clJr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.2 293/413] arm64: tegra: Fix Jetson Nano GPU regulator
Date:   Wed, 24 Jul 2019 21:19:44 +0200
Message-Id: <20190724191757.121960621@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 434e8aedeaec595933811c2af191db9f11d3ce3b upstream.

There are a few issues with the GPU regulator defined for Jetson Nano
which are:

1. The GPU regulator is a PWM based regulator and not a fixed voltage
   regulator.
2. The output voltages for the GPU regulator are not correct.
3. The regulator enable ramp delay is too short for the regulator and
   needs to be increased. 2ms should be sufficient.
4. This is the same regulator used on Jetson TX1 and so make the ramp
   delay and settling time the same as Jetson TX1.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 6772cd0eacc8 ("arm64: tegra: Add NVIDIA Jetson Nano Developer Kit support")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts
@@ -633,17 +633,16 @@
 		};
 
 		vdd_gpu: regulator@6 {
-			compatible = "regulator-fixed";
+			compatible = "pwm-regulator";
 			reg = <6>;
-
+			pwms = <&pwm 1 4880>;
 			regulator-name = "VDD_GPU";
-			regulator-min-microvolt = <5000000>;
-			regulator-max-microvolt = <5000000>;
-			regulator-enable-ramp-delay = <250>;
-
-			gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
-			enable-active-high;
-
+			regulator-min-microvolt = <710000>;
+			regulator-max-microvolt = <1320000>;
+			regulator-ramp-delay = <80>;
+			regulator-enable-ramp-delay = <2000>;
+			regulator-settling-time-us = <160>;
+			enable-gpios = <&pmic 6 GPIO_ACTIVE_HIGH>;
 			vin-supply = <&vdd_5v0_sys>;
 		};
 	};


