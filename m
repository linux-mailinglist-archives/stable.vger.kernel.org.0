Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3C1150D80
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgBCQab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgBCQab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:31 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E98F320838;
        Mon,  3 Feb 2020 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747430;
        bh=z8JvJ+ByIAn+lh5NmKZ61jSBglLW2Qni5MjImejmzhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1YABZPma7mWz6QmbWi93AgZnQEg9yNdUVtwPnBokgiWQ850BMuSOn/eXSJvLLMcm
         NlRSfXfiT4Or86MH2PKnwpllnjpwwuttM+FuiuX45JmSJVGbZbkIahbIJQwfWfxxq4
         7Txow95sSXDh5X2F9tmTYSmgrGWq63y43spKaLzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 81/89] net/fsl: treat fsl,erratum-a011043
Date:   Mon,  3 Feb 2020 16:20:06 +0000
Message-Id: <20200203161926.710795710@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

[ Upstream commit 1d3ca681b9d9575ccf696ebc2840a1ebb1fd4074 ]

When fsl,erratum-a011043 is set, adjust for erratum A011043:
MDIO reads to internal PCS registers may result in having
the MDIO_CFG[MDIO_RD_ER] bit set, even when there is no
error and read data (MDIO_DATA[MDIO_DATA]) is correct.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index e03b30c60dcfd..c82c85ef5fb34 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -49,6 +49,7 @@ struct tgec_mdio_controller {
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
 	bool	is_little_endian;
+	bool	has_a011043;
 };
 
 static u32 xgmac_read32(void __iomem *regs,
@@ -226,7 +227,8 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		return ret;
 
 	/* Return all Fs if nothing was there */
-	if (xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) {
+	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
+	    !priv->has_a011043) {
 		dev_err(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
@@ -274,6 +276,9 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
 						       "little-endian");
 
+	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
+						  "fsl,erratum-a011043");
+
 	ret = of_mdiobus_register(bus, np);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
-- 
2.20.1



