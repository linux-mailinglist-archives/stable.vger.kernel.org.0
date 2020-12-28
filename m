Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DC72E3D71
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440707AbgL1OPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440703AbgL1OPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0591020731;
        Mon, 28 Dec 2020 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164921;
        bh=inzX3+yGq7gB0NTrlg1g4Jpx2uLTd6KpM1Rworkbq6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhoaZiPuNAl/IIUBcj0Ihh52rnI3243KHz8sooj3eDgisUSnEr3uKJsesvkS6xrYE
         D4dOJHkKD6m9U5yaqUByEuzJd4IhBmQWgBerrtNOilDdiTNrJzEOX/twQkAhJIYfpO
         HDu5oe4YUWdnZWAmRdxd5s+bOgC+wv+nN2rCL5SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/717] phy: mediatek: allow compile-testing the hdmi phy
Date:   Mon, 28 Dec 2020 13:45:13 +0100
Message-Id: <20201228125036.123443909@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f5f6e01f9164040ba120f30522efdb4deceb529a ]

Compile-testing the DRM_MEDIATEK_HDMI driver shows two missing
dependencies, one results in a link failure:

arm-linux-gnueabi-ld: drivers/phy/mediatek/phy-mtk-hdmi.o: in function `mtk_hdmi_phy_probe':
phy-mtk-hdmi.c:(.text+0xd8): undefined reference to `__clk_get_name'
arm-linux-gnueabi-ld: phy-mtk-hdmi.c:(.text+0x12c): undefined reference to `devm_clk_register'
arm-linux-gnueabi-ld: phy-mtk-hdmi.c:(.text+0x250): undefined reference to `of_clk_add_provider'
arm-linux-gnueabi-ld: phy-mtk-hdmi.c:(.text+0x298): undefined reference to `of_clk_src_simple_get'

The other one is a harmless warning:

WARNING: unmet direct dependencies detected for PHY_MTK_HDMI
  Depends on [n]: ARCH_MEDIATEK [=n] && OF [=y]
  Selected by [y]:
  - DRM_MEDIATEK_HDMI [=y] && HAS_IOMEM [=y] && DRM_MEDIATEK [=y]

Fix these by adding dependencies on CONFIG_OF and CONFIG_COMMON_CLK.
With that done, there is also no reason against adding
CONFIG_COMPILE_TEST.

Fixes: b28be59a2e26 ("phy: mediatek: Move mtk_hdmi_phy driver into drivers/phy/mediatek folder")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201204135650.2744481-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/Kconfig b/drivers/phy/mediatek/Kconfig
index c8126bde9d7cc..43150608d8b62 100644
--- a/drivers/phy/mediatek/Kconfig
+++ b/drivers/phy/mediatek/Kconfig
@@ -38,7 +38,9 @@ config PHY_MTK_XSPHY
 
 config PHY_MTK_HDMI
 	tristate "MediaTek HDMI-PHY Driver"
-	depends on ARCH_MEDIATEK && OF
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on COMMON_CLK
+	depends on OF
 	select GENERIC_PHY
 	help
 	  Support HDMI PHY for Mediatek SoCs.
-- 
2.27.0



