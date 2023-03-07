Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71B16AE891
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCGRRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCGRQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD0A97FD8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8081CB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12F8C433D2;
        Tue,  7 Mar 2023 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209151;
        bh=v3PEFF0tjST3jgawp8BYT5n3NeHK+QSKciRdRjAH8xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQDVQl2do0S+GJldX0QDGZbHZJFk6rgSGy8X3ALU6Jky+WM1Gjn0g6vFFJ9WCvk1x
         HZJby3O9So8Ccu8kQtE8/NtQR5VSG/XU3aS+HCsRNJag42YWTUDp3MzKQ+lLRxdWQh
         MzRTqFS4DVAhGlc96yqyVmKPKxtD63Ep9dGOikP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0087/1001] arm64: tegra: Mark host1x as dma-coherent on Tegra194/234
Date:   Tue,  7 Mar 2023 17:47:39 +0100
Message-Id: <20230307170025.924315414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 361238cdc52523fd7b1f3aa447c0579f42448b00 ]

Ensure appropriate configuration is done to make the host1x device
and context devices DMA coherent by adding the dma-coherent flag.

Fixes: b35f5b53a87b ("arm64: tegra: Add context isolation domains on Tegra234")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 1 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 45a204d753b1b..76c672d2196be 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1922,6 +1922,7 @@ host1x@13e00000 {
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu TEGRA194_SID_HOST1X>;
+			dma-coherent;
 
 			/* Context isolation domains */
 			iommu-map = <0 &smmu TEGRA194_SID_HOST1X_CTX0 1>,
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 7a3112c82cdc7..cee86dcb68712 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -1967,6 +1967,7 @@ host1x@13e00000 {
 			interconnects = <&mc TEGRA234_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu_niso1 TEGRA234_SID_HOST1X>;
+			dma-coherent;
 
 			/* Context isolation domains */
 			iommu-map = <0 &smmu_niso0 TEGRA234_SID_HOST1X_CTX0 1>,
-- 
2.39.2



