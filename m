Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F072B206582
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388215AbgFWUEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388212AbgFWUE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1062100A;
        Tue, 23 Jun 2020 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942668;
        bh=77Tl72WMtI3IpF05TktpihT66X2/HwQy1kbxN2Bfq/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPS/pUn12t6nMT1x0/MS1pbZaPK8UPIqmTG2BlZLsBSVekfRXr+qczR4zkNnHz5Em
         QpdTKPJFCI135GHP293iaCQ+lxboxDhxhw5x24zKA7yrhO/MfO60FoIlvLxgrWxc2g
         ybhC0XcHa3fTNoYD3B6MIMqR6fwgClOlV1ZCcxWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 088/477] clk: sprd: fix compile-testing
Date:   Tue, 23 Jun 2020 21:51:25 +0200
Message-Id: <20200623195411.771820647@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b5f73d47f34b238221ac771b5fe4907df621d7cb ]

I got a build failure with CONFIG_ARCH_SPRD=m when the
main portion of the clock driver failed to get linked into
the kernel:

ERROR: modpost: "sprd_pll_sc_gate_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_pll_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_div_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_comp_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_mux_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_gate_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_sc_gate_ops" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_clk_probe" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_clk_regmap_init" [drivers/clk/sprd/sc9863a-clk.ko] undefined!
ERROR: modpost: "sprd_pll_ops" [drivers/clk/sprd/sc9860-clk.ko] undefined!
ERROR: modpost: "sprd_div_ops" [drivers/clk/sprd/sc9860-clk.ko] undefined!
ERROR: modpost: "sprd_mux_ops" [drivers/clk/sprd/sc9860-clk.ko] undefined!

This is a combination of two trivial bugs:

- A platform should not be 'tristate', it should be a 'bool' symbol
  like the other platforms, if only for consistency, and to avoid
  surprises like this one.

- The clk Makefile does not traverse into the sprd subdirectory
  if the platform is disabled but the drivers are enabled for
  compile-testing.

Fixing either of the two would be sufficient to address the link failure,
but for correctness, both need to be changed.

Fixes: 2b1b799d7630 ("arm64: change ARCH_SPRD Kconfig to tristate")
Fixes: d41f59fd92f2 ("clk: sprd: Add common infrastructure")
Acked-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig.platforms | 2 +-
 drivers/clk/Makefile         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 55d70cfe0f9e1..3c7e310fd8bfa 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -248,7 +248,7 @@ config ARCH_TEGRA
 	  This enables support for the NVIDIA Tegra SoC family.
 
 config ARCH_SPRD
-	tristate "Spreadtrum SoC platform"
+	bool "Spreadtrum SoC platform"
 	help
 	  Support for Spreadtrum ARM based SoCs
 
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f4169cc2fd318..60e811d3f226d 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -105,7 +105,7 @@ obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
 obj-$(CONFIG_ARCH_SIRF)			+= sirf/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)		+= spear/
-obj-$(CONFIG_ARCH_SPRD)			+= sprd/
+obj-y					+= sprd/
 obj-$(CONFIG_ARCH_STI)			+= st/
 obj-$(CONFIG_ARCH_STRATIX10)		+= socfpga/
 obj-$(CONFIG_ARCH_SUNXI)		+= sunxi/
-- 
2.25.1



