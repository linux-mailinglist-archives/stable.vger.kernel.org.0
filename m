Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5E30054F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbhAVOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbhAVOYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D2323BA8;
        Fri, 22 Jan 2021 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325134;
        bh=IKMRG7/mnXalg85RYxLEEzOfYB4/yIUz4Qr8Gl2XKBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQZE+m0izJbjAvPTYcsZPfY4/V13ZuSCxq6mGojxSt0Yg8XcLblEPUmVugA16+jJl
         ppWnB9TExj/mcf+cZiF9YiVrBtcJKnmA7MmP1QtHblMlzbty1JUp/nKPRrGgEjVziB
         l9kNKK1Eyr83MXLRW8xkwMJSJJvFWgZfYDD1ytcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yannick Vignon <yannick.vignon@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 28/43] net: stmmac: fix taprio schedule configuration
Date:   Fri, 22 Jan 2021 15:12:44 +0100
Message-Id: <20210122135736.786713261@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit b76889ff51bfee318bea15891420e5aefd2833a0 ]

When configuring a 802.1Qbv schedule through the tc taprio qdisc on an NXP
i.MX8MPlus device, the effective cycle time differed from the requested one
by N*96ns, with N number of entries in the Qbv Gate Control List. This is
because the driver was adding a 96ns margin to each interval of the GCL,
apparently to account for the IPG. The problem was observed on NXP
i.MX8MPlus devices but likely affected all devices relying on the same
configuration callback (dwmac 4.00, 4.10, 5.10 variants).

Fix the issue by removing the margins, and simply setup the MAC with the
provided cycle time value. This is the behavior expected by the user-space
API, as altering the Qbv schedule timings would break standards conformance.
This is also the behavior of several other Ethernet MAC implementations
supporting taprio, including the dwxgmac variant of stmmac.

Fixes: 504723af0d85 ("net: stmmac: Add basic EST support for GMAC5+")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Link: https://lore.kernel.org/r/20210113131557.24651-1-yannick.vignon@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c |   52 ++-------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -572,68 +572,24 @@ static int dwmac5_est_write(void __iomem
 int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate)
 {
-	u32 speed, total_offset, offset, ctrl, ctr_low;
-	u32 extcfg = readl(ioaddr + GMAC_EXT_CONFIG);
-	u32 mac_cfg = readl(ioaddr + GMAC_CONFIG);
 	int i, ret = 0x0;
-	u64 total_ctr;
-
-	if (extcfg & GMAC_CONFIG_EIPG_EN) {
-		offset = (extcfg & GMAC_CONFIG_EIPG) >> GMAC_CONFIG_EIPG_SHIFT;
-		offset = 104 + (offset * 8);
-	} else {
-		offset = (mac_cfg & GMAC_CONFIG_IPG) >> GMAC_CONFIG_IPG_SHIFT;
-		offset = 96 - (offset * 8);
-	}
-
-	speed = mac_cfg & (GMAC_CONFIG_PS | GMAC_CONFIG_FES);
-	speed = speed >> GMAC_CONFIG_FES_SHIFT;
-
-	switch (speed) {
-	case 0x0:
-		offset = offset * 1000; /* 1G */
-		break;
-	case 0x1:
-		offset = offset * 400; /* 2.5G */
-		break;
-	case 0x2:
-		offset = offset * 100000; /* 10M */
-		break;
-	case 0x3:
-		offset = offset * 10000; /* 100M */
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	offset = offset / 1000;
+	u32 ctrl;
 
 	ret |= dwmac5_est_write(ioaddr, BTR_LOW, cfg->btr[0], false);
 	ret |= dwmac5_est_write(ioaddr, BTR_HIGH, cfg->btr[1], false);
 	ret |= dwmac5_est_write(ioaddr, TER, cfg->ter, false);
 	ret |= dwmac5_est_write(ioaddr, LLR, cfg->gcl_size, false);
+	ret |= dwmac5_est_write(ioaddr, CTR_LOW, cfg->ctr[0], false);
+	ret |= dwmac5_est_write(ioaddr, CTR_HIGH, cfg->ctr[1], false);
 	if (ret)
 		return ret;
 
-	total_offset = 0;
 	for (i = 0; i < cfg->gcl_size; i++) {
-		ret = dwmac5_est_write(ioaddr, i, cfg->gcl[i] + offset, true);
+		ret = dwmac5_est_write(ioaddr, i, cfg->gcl[i], true);
 		if (ret)
 			return ret;
-
-		total_offset += offset;
 	}
 
-	total_ctr = cfg->ctr[0] + cfg->ctr[1] * 1000000000ULL;
-	total_ctr += total_offset;
-
-	ctr_low = do_div(total_ctr, 1000000000);
-
-	ret |= dwmac5_est_write(ioaddr, CTR_LOW, ctr_low, false);
-	ret |= dwmac5_est_write(ioaddr, CTR_HIGH, total_ctr, false);
-	if (ret)
-		return ret;
-
 	ctrl = readl(ioaddr + MTL_EST_CONTROL);
 	ctrl &= ~PTOV;
 	ctrl |= ((1000000000 / ptp_rate) * 6) << PTOV_SHIFT;


