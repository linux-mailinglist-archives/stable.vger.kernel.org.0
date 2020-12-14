Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407652D9F6F
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439866AbgLNSo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502284AbgLNRh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:57 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 064/105] arm64: tegra: Disable the ACONNECT for Jetson TX2
Date:   Mon, 14 Dec 2020 18:28:38 +0100
Message-Id: <20201214172558.351090136@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit fb319496935b7475a863a00c76895e8bb3216704 ]

Commit ff4c371d2bc0 ("arm64: defconfig: Build ADMA and ACONNECT driver")
enable the Tegra ADMA and ACONNECT drivers and this is causing resume
from system suspend to fail on Jetson TX2. Resume is failing because the
ACONNECT driver is being resumed before the BPMP driver, and the ACONNECT
driver is attempting to power on a power-domain that is provided by the
BPMP. While a proper fix for the resume sequencing problem is identified,
disable the ACONNECT for Jetson TX2 temporarily to avoid breaking system
suspend.

Please note that ACONNECT driver is used by the Audio Processing Engine
(APE) on Tegra, but because there is no mainline support for APE on
Jetson TX2 currently, disabling the ACONNECT does not disable any useful
feature at the moment.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
index 802b8c52489ac..b5a23643db978 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts
@@ -10,18 +10,6 @@
 	model = "NVIDIA Jetson TX2 Developer Kit";
 	compatible = "nvidia,p2771-0000", "nvidia,tegra186";
 
-	aconnect {
-		status = "okay";
-
-		dma-controller@2930000 {
-			status = "okay";
-		};
-
-		interrupt-controller@2a40000 {
-			status = "okay";
-		};
-	};
-
 	i2c@3160000 {
 		power-monitor@42 {
 			compatible = "ti,ina3221";
-- 
2.27.0



