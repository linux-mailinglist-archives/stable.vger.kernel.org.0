Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E31491A34
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347714AbiARC6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348803AbiARCqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49B4CB81249;
        Tue, 18 Jan 2022 02:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1936AC36AEB;
        Tue, 18 Jan 2022 02:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473966;
        bh=UeVBnUr7/IQip7NGL8zGJ5/cfjw3NXf5R8G/3PpdhgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQN26/N7Hie04uzIE8UWu/nOgsVAVIGJIHjrCUZDv+6S8oIm7BSoQ+fY7vOTti7ov
         +5pvCKno2CdRPuv5+Xgq94QKw0FG79LoCvHNyUnttNnViV+mltKnVynaaR5HYV9XFf
         XcqwSQwt/+yeof9G4EZGcCligl5M70X5shbcyibuBmAs/gMPoUwHOA/SwrWnAtT095
         sgPqmmAxYGhV3bGJKk2RhUbnp3iuBuaG6W5cw8MS5t2fK20s2m6qLMmmACun8pSNB/
         RTWqzYe6sR0j3LjW5p70kOkmKGggQgE7k1pr/ZcgnLrI7C5+Pttjl/G96qabU43I8o
         CAsXVtGANO5ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, spujar@nvidia.com,
        mperttunen@nvidia.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 45/73] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 17 Jan 2022 21:44:04 -0500
Message-Id: <20220118024432.1952028-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 9abf0cb1dd67f..4457262750734 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -709,7 +709,7 @@ sdmmc3_1v8: sdmmc3-1v8 {
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1

