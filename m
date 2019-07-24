Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F67391C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbfGXTg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389365AbfGXTg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:36:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3465720665;
        Wed, 24 Jul 2019 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997017;
        bh=7Y9poKPEgUGuoZRHPAlC4esT87CFOv4Dtq1zAnbwfYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFcMLwJDl4IMjXxG8NwzIIxuf8KniAoHK7guU7duwfXkZvEv4PCdH/ImmYtJeJ8Gs
         K954RKz08WTkZjy8l7EDiCEdvPB0z3jagmAAXl8O25Ul3Jc6HaU0k0apYB/MvnA3jV
         AMV75UyRtQVJquGdjXoz8nGIDlvBMXNJsha27bZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.2 292/413] arm64: tegra: Update Jetson TX1 GPU regulator timings
Date:   Wed, 24 Jul 2019 21:19:43 +0200
Message-Id: <20190724191757.075181627@linuxfoundation.org>
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

commit ece6031ece2dd64d63708cfe1088016cee5b10c0 upstream.

The GPU regulator enable ramp delay for Jetson TX1 is set to 1ms which
not sufficient because the enable ramp delay has been measured to be
greater than 1ms. Furthermore, the downstream kernels released by NVIDIA
for Jetson TX1 are using a enable ramp delay 2ms and a settling delay of
160us. Update the GPU regulator enable ramp delay for Jetson TX1 to be
2ms and add a settling delay of 160us.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 5e6b9a89afce ("arm64: tegra: Add VDD_GPU regulator to Jetson TX1")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -328,7 +328,8 @@
 			regulator-max-microvolt = <1320000>;
 			enable-gpios = <&pmic 6 GPIO_ACTIVE_HIGH>;
 			regulator-ramp-delay = <80>;
-			regulator-enable-ramp-delay = <1000>;
+			regulator-enable-ramp-delay = <2000>;
+			regulator-settling-time-us = <160>;
 		};
 	};
 };


