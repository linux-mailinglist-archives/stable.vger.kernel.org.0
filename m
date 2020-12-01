Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE4E2C9BED
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390085AbgLAJN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390078AbgLAJNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC780221FF;
        Tue,  1 Dec 2020 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813960;
        bh=ZxjqU0FXy4FKh54cZvBJctwkOv95Rk3lxCbbJAkHPBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6+NVVP4j9EPPGeMDTOQtpnYkCznmXCMFyOFNY5IylB94GmdV447nzS+OLblXK0Ry
         2Ms1dEv0t5M0vh8pe4rPk4Kk31cREkl4PMqyvWDHgOw8w0lRfo384Nd9y5A3LuKhPk
         Sum7O7HEH+LJsU7QqX03ZS447a276K6cCHWyRjP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 119/152] arm64: tegra: Wrong AON HSP reg property size
Date:   Tue,  1 Dec 2020 09:53:54 +0100
Message-Id: <20201201084727.380521089@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dipen Patel <dipenp@nvidia.com>

[ Upstream commit 1741e18737948c140ccc4cc643e8126d95ee6e79 ]

The AON HSP node's "reg" property size 0xa0000 will overlap with other
resources. This patch fixes that wrong value with correct size 0x90000.

Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Fixes: a38570c22e9d ("arm64: tegra: Add nodes for TCU on Tegra194")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index ca5cb6aef5ee4..6f6d460c931aa 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -924,7 +924,7 @@
 
 		hsp_aon: hsp@c150000 {
 			compatible = "nvidia,tegra194-hsp", "nvidia,tegra186-hsp";
-			reg = <0x0c150000 0xa0000>;
+			reg = <0x0c150000 0x90000>;
 			interrupts = <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.27.0



