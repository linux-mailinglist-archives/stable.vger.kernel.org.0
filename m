Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C5C1EAE8B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgFASBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgFASBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673C3207DF;
        Mon,  1 Jun 2020 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034498;
        bh=aVWBkr/MbZ67KkqkDZdoxyT8qvaVzqO3nHWvC9kgK+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3wK4xJGUXRFTP+sxdgb49iPn1NAxql8pjKghMz4CShd0aliB4LUcC6RvUOy1MzDl
         0yrNw7jWevjpUtMZD61UtxuXy5dvvDI6pTD/XFh1J4q9XV7tFE+XTe1JmRDkg5GrMp
         JZ9lHbCx1Gic4rcKYg86ozkK9+Y9SMkaZHZm5jpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/77] net: freescale: select CONFIG_FIXED_PHY where needed
Date:   Mon,  1 Jun 2020 19:53:26 +0200
Message-Id: <20200601174020.202776499@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 99352c79af3e5f2e4724abf37fa5a2a3299b1c81 ]

I ran into a randconfig build failure with CONFIG_FIXED_PHY=m
and CONFIG_GIANFAR=y:

x86_64-linux-ld: drivers/net/ethernet/freescale/gianfar.o:(.rodata+0x418): undefined reference to `fixed_phy_change_carrier'

It seems the same thing can happen with dpaa and ucc_geth, so change
all three to do an explicit 'select FIXED_PHY'.

The fixed-phy driver actually has an alternative stub function that
theoretically allows building network drivers when fixed-phy is
disabled, but I don't see how that would help here, as the drivers
presumably would not work then.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/Kconfig      | 2 ++
 drivers/net/ethernet/freescale/dpaa/Kconfig | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6e490fd2345d..71f0640200bc 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -76,6 +76,7 @@ config UCC_GETH
 	depends on QUICC_ENGINE
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	---help---
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
@@ -89,6 +90,7 @@ config GIANFAR
 	depends on HAS_DMA
 	select FSL_PQ_MDIO
 	select PHYLIB
+	select FIXED_PHY
 	select CRC32
 	---help---
 	  This driver supports the Gigabit TSEC on the MPC83xx, MPC85xx,
diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index a654736237a9..8fec41e57178 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -2,6 +2,7 @@ menuconfig FSL_DPAA_ETH
 	tristate "DPAA Ethernet"
 	depends on FSL_DPAA && FSL_FMAN
 	select PHYLIB
+	select FIXED_PHY
 	select FSL_FMAN_MAC
 	---help---
 	  Data Path Acceleration Architecture Ethernet driver,
-- 
2.25.1



