Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7410593771
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiHOSiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241862AbiHOSiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128933CBCA;
        Mon, 15 Aug 2022 11:23:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D52B81077;
        Mon, 15 Aug 2022 18:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8666CC433C1;
        Mon, 15 Aug 2022 18:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587810;
        bh=RxOBuLdbcvJUhR8pRPb57+gIPLNBhGcRnrqEWp92T+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfRsiCuieif9ZxvVnUKKkJyQPctyPTO8RVYgWg5Bx4qzbL1L2HOleKLjG6tnqVoUk
         AbKnPw2bZBEC97JSY8hR9tffHOmL7yS9EjFRQuNqmPcpMJdooHLLGGyW2hkcuIN5jT
         GX/qaFPZJhMG94tn1HnC7FZma7nVns9n5LqXRwPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/779] arm64: tegra: Fixup SYSRAM references
Date:   Mon, 15 Aug 2022 19:57:27 +0200
Message-Id: <20220815180345.957114549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 7fa307524a4d721d4a04523018509882c5414e72 ]

The json-schema bindings for SRAM expect the nodes to be called "sram"
rather than "sysram" or "shmem". Furthermore, place the brackets around
the SYSRAM references such that a two-element array is created rather
than a two-element array nested in a single-element array. This is not
relevant for device tree itself, but allows the nodes to be properly
validated against json-schema bindings.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 2 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 062e87e89331..8354512d7b1c 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -1635,7 +1635,7 @@ bpmp: bpmp {
 		iommus = <&smmu TEGRA186_SID_BPMP>;
 		mboxes = <&hsp_top0 TEGRA_HSP_MBOX_TYPE_DB
 				    TEGRA_HSP_DB_MASTER_BPMP>;
-		shmem = <&cpu_bpmp_tx &cpu_bpmp_rx>;
+		shmem = <&cpu_bpmp_tx>, <&cpu_bpmp_rx>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
 		#power-domain-cells = <1>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 510d2974470c..a56fb83839a4 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2267,7 +2267,7 @@ bpmp: bpmp {
 		compatible = "nvidia,tegra186-bpmp";
 		mboxes = <&hsp_top0 TEGRA_HSP_MBOX_TYPE_DB
 				    TEGRA_HSP_DB_MASTER_BPMP>;
-		shmem = <&cpu_bpmp_tx &cpu_bpmp_rx>;
+		shmem = <&cpu_bpmp_tx>, <&cpu_bpmp_rx>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
 		#power-domain-cells = <1>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index f0efb3a62804..28961ed31d87 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -122,20 +122,20 @@ gic: interrupt-controller@f400000 {
 		};
 	};
 
-	sysram@40000000 {
+	sram@40000000 {
 		compatible = "nvidia,tegra234-sysram", "mmio-sram";
 		reg = <0x0 0x40000000 0x0 0x50000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x40000000 0x50000>;
 
-		cpu_bpmp_tx: shmem@4e000 {
+		cpu_bpmp_tx: sram@4e000 {
 			reg = <0x4e000 0x1000>;
 			label = "cpu-bpmp-tx";
 			pool;
 		};
 
-		cpu_bpmp_rx: shmem@4f000 {
+		cpu_bpmp_rx: sram@4f000 {
 			reg = <0x4f000 0x1000>;
 			label = "cpu-bpmp-rx";
 			pool;
@@ -146,7 +146,7 @@ bpmp: bpmp {
 		compatible = "nvidia,tegra234-bpmp", "nvidia,tegra186-bpmp";
 		mboxes = <&hsp_top0 TEGRA_HSP_MBOX_TYPE_DB
 				    TEGRA_HSP_DB_MASTER_BPMP>;
-		shmem = <&cpu_bpmp_tx &cpu_bpmp_rx>;
+		shmem = <&cpu_bpmp_tx>, <&cpu_bpmp_rx>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
 		#power-domain-cells = <1>;
-- 
2.35.1



