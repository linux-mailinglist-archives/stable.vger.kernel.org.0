Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6021FDC8C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgFRBUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgFRBUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A6A21941;
        Thu, 18 Jun 2020 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443212;
        bh=SYjxq2NnQ6NVLLeeOjwRvqZ6WebUD/LLJocRXJ3vrPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUo9LUyxzZNj4TGVpTSBpR7vGMWkVHMS4n3yo8TBNW2cpXvS5nu3f4+ox0oe0DjKD
         A5UoFeCPfBgp21i5utR1TDfMHIxfsapkM4Lg+WI9vfivaXxnRZzzxnVSFRWQQW2OCh
         4x32oGswRexQqlWRbWvn5Cg3rvftx5xel5BkHUKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 169/266] arm64: tegra: Fix ethernet phy-mode for Jetson Xavier
Date:   Wed, 17 Jun 2020 21:14:54 -0400
Message-Id: <20200618011631.604574-169-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit bba25915b172c72f6fa635f091624d799e3c9cae ]

The 'phy-mode' property is currently defined as 'rgmii' for Jetson
Xavier. This indicates that the RGMII RX and TX delays are set by the
MAC and the internal delays set by the PHY are not used.

If the Marvell PHY driver is enabled, such that it is used and not the
generic PHY, ethernet failures are seen (DHCP is failing to obtain an
IP address) and this is caused because the Marvell PHY driver is
disabling the internal RX and TX delays. For Jetson Xavier the internal
PHY RX and TX delay should be used and so fix this by setting the
'phy-mode' to 'rgmii-id' and not 'rgmii'.

Fixes: f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
index 02909a48dfcd..7899759a12f8 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
@@ -32,7 +32,7 @@ ethernet@2490000 {
 
 			phy-reset-gpios = <&gpio TEGRA194_MAIN_GPIO(G, 5) GPIO_ACTIVE_LOW>;
 			phy-handle = <&phy>;
-			phy-mode = "rgmii";
+			phy-mode = "rgmii-id";
 
 			mdio {
 				#address-cells = <1>;
-- 
2.25.1

