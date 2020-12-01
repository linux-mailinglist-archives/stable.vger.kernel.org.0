Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CD2C9B3D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbgLAJGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbgLAJGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1812067D;
        Tue,  1 Dec 2020 09:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813520;
        bh=fj+TkTfbLpdv8C3gl+cAfNala2UOLeYn1BhGf+5rD+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEwFkUHDUsvoUaaiGL33CvPQye+flhfZjfJRf0niqrLysU6jABqf2iRNScr0GCUQj
         m73J8fM01mcuXQj/bgJ5fIevk5GT1UkIDVdHG+i2lgRp+CtXWUNj84y/XnQLLh6X8n
         meHD4qsAbrrx77cBsIOcpI0knitiB/4A6c2RjhaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 68/98] arm64: tegra: Wrong AON HSP reg property size
Date:   Tue,  1 Dec 2020 09:53:45 +0100
Message-Id: <20201201084658.412492057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index 5728255bd0c1a..78f7e6e50beb0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -692,7 +692,7 @@
 
 		hsp_aon: hsp@c150000 {
 			compatible = "nvidia,tegra194-hsp", "nvidia,tegra186-hsp";
-			reg = <0x0c150000 0xa0000>;
+			reg = <0x0c150000 0x90000>;
 			interrupts = <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
 			             <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.27.0



