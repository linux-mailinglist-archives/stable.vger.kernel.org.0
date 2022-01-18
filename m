Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B162449159E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244865AbiARC3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:29:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbiARC1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:27:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF421B8123A;
        Tue, 18 Jan 2022 02:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CEBC36AEF;
        Tue, 18 Jan 2022 02:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472827;
        bh=+dn8wtJNEQoB72InxSwBZwllrkEyFCn9xheRZrAo3Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+ZtpD5wXFItCFXU5AzWfPiXWrDvpI2Ht7QqSG34+Juv46/t13NcJaCaCVtJjyjMG
         bff9C8cb96KLJ150XX0BHvpjzDxjDcn7uc0svW97gQc18OvYXAT1cSkJcEnsDUWtr6
         sBQXOk0KT+HWHdo1cx2KGCUy8EL8CG0HV8/PjbbXxwUJK5kkaCfwEzByT+V/S0SdWv
         vbw+ADxaLFjyP66l2a0RzMXAj3b6eHQb9psSoNqwu46ANboh3EMssT4shBKkrGKPw8
         zwz+3cHM/BhtvXEkHVA0Vqr7ySYl8Vre1/KMffMaUcbjSu0hmhewQDgXC4Aij7H0l1
         vmkOFpEcD6mwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, spujar@nvidia.com,
        mperttunen@nvidia.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 145/217] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 17 Jan 2022 21:18:28 -0500
Message-Id: <20220118021940.1942199-145-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2b14cbd643feea5fc17c6e8bead4e71088c69acd ]

The Tegra186 CCPLEX cluster register region is 4 MiB is length, not 4
MiB - 1. This was likely presumed to be the "limit" rather than length.
Fix it up.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 9ac4f0140700f..8ab83b4ac0373 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -1199,7 +1199,7 @@ sdmmc3_1v8: sdmmc3-1v8 {
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1

