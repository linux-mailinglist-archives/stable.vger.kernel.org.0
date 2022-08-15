Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49559371D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiHOSiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243263AbiHOSiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:38:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F52DABE;
        Mon, 15 Aug 2022 11:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3385EB81082;
        Mon, 15 Aug 2022 18:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A639C433D7;
        Mon, 15 Aug 2022 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587814;
        bh=SxZDZwIpgLGEujOcYVEoKFphC/vj+7vaHu72hXjkwFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucAIf/SKr14xjHW+Nw2D/GN7r4Bay8Bcj4J7l7N76W1DcTZDJqfy93jNaWkExoQQc
         fOPj40H1B52LMDU0gsDgJOspnO9EK/ZKKIZgfTz6k3YosFqDK363S4EsOW/htRnub9
         pasrGzqsPMThgmlelnbT6NwSwrP9HDKBr6GqwUrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/779] arm64: tegra: Update Tegra234 BPMP channel addresses
Date:   Mon, 15 Aug 2022 19:57:28 +0200
Message-Id: <20220815180346.000100318@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 98094be152d34f8014ca67fbdc210e5261c4b09d ]

On final Tegra234 systems, shared memory for communication with BPMP is
located at offset 0x70000 in SYSRAM.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 28961ed31d87..144a7eb699a7 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -124,19 +124,19 @@ gic: interrupt-controller@f400000 {
 
 	sram@40000000 {
 		compatible = "nvidia,tegra234-sysram", "mmio-sram";
-		reg = <0x0 0x40000000 0x0 0x50000>;
+		reg = <0x0 0x40000000 0x0 0x80000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges = <0x0 0x0 0x40000000 0x50000>;
+		ranges = <0x0 0x0 0x40000000 0x80000>;
 
-		cpu_bpmp_tx: sram@4e000 {
-			reg = <0x4e000 0x1000>;
+		cpu_bpmp_tx: sram@70000 {
+			reg = <0x70000 0x1000>;
 			label = "cpu-bpmp-tx";
 			pool;
 		};
 
-		cpu_bpmp_rx: sram@4f000 {
-			reg = <0x4f000 0x1000>;
+		cpu_bpmp_rx: sram@71000 {
+			reg = <0x71000 0x1000>;
 			label = "cpu-bpmp-rx";
 			pool;
 		};
-- 
2.35.1



