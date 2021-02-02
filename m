Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E4530CC7A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbhBBT5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232938AbhBBNt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8123B64FAE;
        Tue,  2 Feb 2021 13:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273373;
        bh=zlcr/KSy+1al9MB1VIe/9p3BiW9UrbvHby/w4JyAbdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBIHgFibEjepyYk4p9nrO5wjERIh81xd9thXKcWQR/JwgLwFmwE9x8Caj1Vl3FVtM
         c3S/H3a7Wu0HBgJKphPW0AHg8lqt9hbR2ndmBCJ2bdML3vnJgqXy+Q3u4P5JN7jm6K
         DdxbQ1RdneGRckGk9aZqeaAWzWcBdte6SuahCtGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/142] ARM: imx: fix imx8m dependencies
Date:   Tue,  2 Feb 2021 14:37:26 +0100
Message-Id: <20210202133001.134109569@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 097530bf8cd469ef7b3d52ef00cafb64b33bacb1 ]

Selecting ARM_GIC_V3 on non-CP15 processors leads to build failures
like

arch/arm/include/asm/arch_gicv3.h: In function 'write_ICC_AP1R3_EL1':
arch/arm/include/asm/arch_gicv3.h:36:40: error: 'c12' undeclared (first use in this function)
   36 | #define __ICC_AP1Rx(x)   __ACCESS_CP15(c12, 0, c9, x)
      |                                        ^~~

Add a dependency to only enable the gic driver when building for
at an ARMv7 target, which is the closes approximation to the ARMv8
processor that is actually in this chip.

Fixes: fc40200ebf82 ("soc: imx: increase build coverage for imx8m soc driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/Kconfig b/drivers/soc/imx/Kconfig
index a9370f4aacca9..05812f8ae7340 100644
--- a/drivers/soc/imx/Kconfig
+++ b/drivers/soc/imx/Kconfig
@@ -13,7 +13,7 @@ config SOC_IMX8M
 	depends on ARCH_MXC || COMPILE_TEST
 	default ARCH_MXC && ARM64
 	select SOC_BUS
-	select ARM_GIC_V3 if ARCH_MXC
+	select ARM_GIC_V3 if ARCH_MXC && ARCH_MULTI_V7
 	help
 	  If you say yes here you get support for the NXP i.MX8M family
 	  support, it will provide the SoC info like SoC family,
-- 
2.27.0



