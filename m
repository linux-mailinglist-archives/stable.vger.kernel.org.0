Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8156745CB
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfGYFqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405330AbfGYFqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C32B22BF3;
        Thu, 25 Jul 2019 05:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033575;
        bh=E+rUHlkwrso1dctrlHlKyLdeHeo3hWS1aixkH7dO0/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXsQlYLciY7bSiVz95Hr+QwjPadcfdjQCCaec4ZT6h+FHgQP1knWSR7IwS90jy7C3
         Vlgre1GcRvQGZdRZlyDHH4Jj4kz5S3255frV1D+f9pGkpDZzAnOmts6RhPdXnAL+cG
         1OvJdbMp2nTZN2+JCbLMuIDkjbkpKiT1HZWk/n+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.19 214/271] arm64: tegra: Fix AGIC register range
Date:   Wed, 24 Jul 2019 21:21:23 +0200
Message-Id: <20190724191713.426369729@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit ba24eee6686f6ed3738602b54d959253316a9541 upstream.

The Tegra AGIC interrupt controller is an ARM GIC400 interrupt
controller. Per the ARM GIC device-tree binding, the first address
region is for the GIC distributor registers and the second address
region is for the GIC CPU interface registers. The address space for
the distributor registers is 4kB, but currently this is incorrectly
defined as 8kB for the Tegra AGIC and overlaps with the CPU interface
registers. Correct the address space for the distributor to be 4kB.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: bcdbde433542 ("arm64: tegra: Add AGIC node for Tegra210")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1119,7 +1119,7 @@
 			compatible = "nvidia,tegra210-agic";
 			#interrupt-cells = <3>;
 			interrupt-controller;
-			reg = <0x702f9000 0x2000>,
+			reg = <0x702f9000 0x1000>,
 			      <0x702fa000 0x2000>;
 			interrupts = <GIC_SPI 102 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 			clocks = <&tegra_car TEGRA210_CLK_APE>;


