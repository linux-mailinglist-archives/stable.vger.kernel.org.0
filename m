Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016B9491C55
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355877AbiARDOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352904AbiARDIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:08:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E81C06161C;
        Mon, 17 Jan 2022 18:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EECFEB811CF;
        Tue, 18 Jan 2022 02:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C023AC36AE3;
        Tue, 18 Jan 2022 02:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474237;
        bh=bm+Rd7qexeD5Drlqz+BMs3kGsfMPTU5l5sG13qlHO/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZ9cwAf/uLVw3I7EPnU3DqYyuK/mzSFSriP+IQ5NWIuexGZfwjUFykTqV/Q+lwy4q
         Fh7dibqRDjEZ3uE5/DZ6LA+KkIuRSiZvk85bgSOa09DyoenqSNXxMiOIu7TNQC7ok0
         mVXQ/4gdkN8YIqNebE9m1zd34KVNxFd2FUx2iJPGduDVu7zBhJ6/kH6u2c8gRdJ234
         /NXyFtSBb4+wGprRic1ig5DUa6s1142EjB8L6/JIh5V0ahzGISa9V29STITBrC1eqs
         4866L+/Ax4IPLO6wWMaGidlDY/GNcKTZhGJj8i3SABtVV/tcnL2ApxTVq2todUhyvo
         BfLpU2p8jDfxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, spujar@nvidia.com,
        mperttunen@nvidia.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/56] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 17 Jan 2022 21:48:48 -0500
Message-Id: <20220118024908.1953673-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index a9c3eef6c4e09..3307d816050fe 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -351,7 +351,7 @@ pmc@c360000 {
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1

