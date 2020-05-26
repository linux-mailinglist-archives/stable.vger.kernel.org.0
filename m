Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388501E2B86
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403784AbgEZTGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391639AbgEZTGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C587C20776;
        Tue, 26 May 2020 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519961;
        bh=1LLrEfPfAV+cGfCNECNu52XXltkAInRVKK30NZ1an0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugslCmFevgxOCDsWJq7V5LY1cw3QQS2ZfqZtkMXkHr1O2WpA1e5eVZuqvaG69gzl0
         1Q2smdXGMJB70NBx5GjR56kHzXirGjHVYDMvM5d2lHdLl524nhJZjtuGVsJY7e5kOv
         938IZ/lt/SGGp30mR8FoioBmBYEVaCck62TZn+m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/81] net: bcmgenet: abort suspend on error
Date:   Tue, 26 May 2020 20:53:34 +0200
Message-Id: <20200526183933.620315588@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit c5a54bbcececa36852807c36157a86d808b62310 ]

If an error occurs during suspension of the driver the driver should
restore the hardware configuration and return an error to force the
system to resume.

Fixes: 0db55093b566 ("net: bcmgenet: return correct value 'ret' from bcmgenet_power_down")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 3 +++
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 60abf9fab810..047fc0cf0263 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3722,6 +3722,9 @@ static int bcmgenet_suspend(struct device *d)
 	/* Turn off the clocks */
 	clk_disable_unprepare(priv->clk);
 
+	if (ret)
+		bcmgenet_resume(d);
+
 	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 2fbd027f0148..b3596e0ee47b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -186,9 +186,15 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	}
 
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
+	if (!(reg & MPD_EN))
+		return;	/* already powered up so skip the rest */
 	reg &= ~MPD_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
+	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
+	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+
 	/* Disable CRC Forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
-- 
2.25.1



