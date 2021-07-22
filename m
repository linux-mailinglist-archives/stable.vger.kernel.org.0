Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045CA3D29A0
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhGVQFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234865AbhGVQFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CCD7613D2;
        Thu, 22 Jul 2021 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972345;
        bh=KNd4tw7QPhG653qvxc4a5L9+qxVTHp/FjuujZFmrzF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzUvAkOvI9LNFLDCmOF3MFTccEf0azPgqoCsDHOcVinGn4lZiUgjIRK5Krz3R/sfR
         ztwGy3LRq6migkzdeaxV1SkjBAfHPBIdM5F6z+72/khWrEDSnuu3szKsvu0Lhtqr7U
         uyaxdW9V2+fKNvRZe8SKo9GpXAE+D4KvGh7ZaZec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 042/156] arm64: tegra: Add PMU node for Tegra194
Date:   Thu, 22 Jul 2021 18:30:17 +0200
Message-Id: <20210722155629.776170831@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 9e79e58f330ea4860f2ced65a8a35dfb05fc03c1 ]

Populate the device-tree node for the PMU device on Tegra194. This also
fixes the following warning that is observed on booting Tegra194.

 ERR KERN kvm: pmu event creation failed -2

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 9449156fae39..2e40b6047283 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2345,6 +2345,20 @@
 		};
 	};
 
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 385 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 386 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 387 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 388 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 389 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 390 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 391 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0_0 &cpu0_1 &cpu1_0 &cpu1_1
+				      &cpu2_0 &cpu2_1 &cpu3_0 &cpu3_1>;
+	};
+
 	psci {
 		compatible = "arm,psci-1.0";
 		status = "okay";
-- 
2.30.2



