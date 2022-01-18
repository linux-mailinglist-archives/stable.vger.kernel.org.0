Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB5491C24
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347322AbiARDNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354127AbiARDFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:05:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B83DC021992;
        Mon, 17 Jan 2022 18:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBBE6130A;
        Tue, 18 Jan 2022 02:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C915C36AE3;
        Tue, 18 Jan 2022 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474096;
        bh=x+VaJ/8Bhk9YBGBufy5sI3aIsySA7PsMp6c05L2SEDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFmf+a9Ea8WYVliExPjUOi1sjJMDwbdVOkd7Cj/XkP3bGxAPjGkK4YAvHD7JVHY1G
         FUDO+tZwEQDDng8Y4J7TtX/nrKhXFLWjarnkrUBQOHwdofhVUe4ZrqOUmRzP5jDv2p
         ACj3MIJM7sxcWLHSQCKPvxIh0kINIl4X2ADy+XkiD5zJVF9q9P53Z88BUpR5EI/nNh
         ycUULpSKC/HIxFZnciwKq1VhKMlsqItIzYLT//ydl8W0GDs8QwZe21CMxS+JPakyQD
         3HFSk65YZPff3IgNDMGHZlfCQQR9So24SoqVrB6B7EB6tka70uqWkAtHZVRxtyssLh
         gDujp1HWs1T2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, spujar@nvidia.com,
        mperttunen@nvidia.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 34/59] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 17 Jan 2022 21:46:35 -0500
Message-Id: <20220118024701.1952911-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index b762227f6aa18..fc5d047ca50bc 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -372,7 +372,7 @@ pmc@c360000 {
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1

