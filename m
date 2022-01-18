Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E327491ACE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352959AbiARDAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350745AbiARCwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595E4C08C5C3;
        Mon, 17 Jan 2022 18:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20190B81132;
        Tue, 18 Jan 2022 02:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFB7C36AE3;
        Tue, 18 Jan 2022 02:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473790;
        bh=/74ibrcK+ISIoJTWLGejVQLxnzs2mu57MYjpIyvlIbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmKSGDA0OBpPAY6Zy1qUR/gcMc14NjPSVkitWVQ6lwFwbjtwQKfSiOQydnXCgtR4w
         U9BldKPGiVZu4QeVF29NI+tDutTp+TEhmovjYzFQ+XlMKYUlQjB6m5UTDvlKStF+ww
         8yH94JLHIJgp4Nd0Mor7ZJ7jW0bPMhqH9AbkF40ovxb389+bvYNEvFUUyEZK7DDyoK
         iMtxvqezfQr85ZEHyQPduWeWdKLC70/m1TXMq0EUmBAZ+vhC6+EJFr5yHCu5310wcV
         tCFdAqZi0a3a5szsM9LRFbUPpKwNP+1TY66q9J2wKwgmeeIlIIFtqXwPd9wxzm367x
         NoX1rtdGWPwgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, spujar@nvidia.com,
        mperttunen@nvidia.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 073/116] arm64: tegra: Adjust length of CCPLEX cluster MMIO region
Date:   Mon, 17 Jan 2022 21:39:24 -0500
Message-Id: <20220118024007.1950576-73-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 0c46ab7bbbf37..eec6418ecdb1a 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -985,7 +985,7 @@ sdmmc3_1v8: sdmmc3-1v8 {
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
-- 
2.34.1

