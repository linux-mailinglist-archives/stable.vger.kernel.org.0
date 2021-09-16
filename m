Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B933040E745
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbhIPRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352339AbhIPR14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:27:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039526103B;
        Thu, 16 Sep 2021 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810738;
        bh=vpGN6M9N/+VFlJTwRXh9c32T/+9r1GIZGJlU8Oq/aBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7xh/6djtAeFGOLvLxEXFJ8Zewh+AdxVtnyMh9HjP1ycylutpb9nyrsxyZayo8TvC
         HdLmNJqiSLbZVC4+5ltGkqTTA8Vw6t1h+WEG+iTwGDWHmpVcWajtysyRr5hoDYL6HG
         7M61zUWQX3ULAGTup2MTtLunRFf9pxoQEMObPcq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 250/432] arm64: tegra: Fix Tegra194 PCIe EP compatible string
Date:   Thu, 16 Sep 2021 17:59:59 +0200
Message-Id: <20210916155819.303235002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit bf2942a8b7c38e8cc2d5157b4f0323d7f4e5ec71 ]

The initialization sequence performed by the generic platform driver
pcie-designware-plat.c for a DWC based implementation doesn't work for
Tegra194. Tegra194 has a different initialization sequence requirement
which can only be satisfied by the Tegra194 specific platform driver
pcie-tegra194.c. So, remove the generic compatible string "snps,dw-pcie-ep"
from Tegra194's endpoint controller nodes.

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 5ba7a4519b95..c8250a3f7891 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2122,7 +2122,7 @@ pcie@141a0000 {
 	};
 
 	pcie_ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2162,7 +2162,7 @@ pcie_ep@14160000 {
 	};
 
 	pcie_ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2202,7 +2202,7 @@ pcie_ep@14180000 {
 	};
 
 	pcie_ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-- 
2.30.2



