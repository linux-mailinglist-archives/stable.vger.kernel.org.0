Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE75773F19
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbfGXTcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388637AbfGXTcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:32:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D872D229FA;
        Wed, 24 Jul 2019 19:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996743;
        bh=yw1shNQx4IyfNev6H9OHA1gaGsr0P+ZipoPSW+nTp34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJodHHb1JDE7ettzjQHu/AjIJqXsWz3ExRJ/nSvaVvCM3qEvOkrtGFj2DWpLajn3U
         F+YTlx0muk8QovMmiWlfeeswoobu8UtJ4bQCsUN6pLOX0JTgSbz4R9K81Yf6UWNM3t
         jG3rkCP+gPcui5vvhw5YHh5SQPP+sTJ4/8Qkb78M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 200/413] net: ethernet: ti: cpsw: Assign OF node to slave devices
Date:   Wed, 24 Jul 2019 21:18:11 +0200
Message-Id: <20190724191748.874935721@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 337d1727a3895775b5e5ef67d3ca0fea2e2ae768 ]

Assign OF node to CPSW slave devices, otherwise it is not possible to
bind e.g. DSA switch to them. Without this patch, the DSA code tries
to find the ethernet device by OF match, but fails to do so because
the slave device has NULL OF node.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c      | 3 +++
 drivers/net/ethernet/ti/cpsw_priv.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 634fc484a0b3..4e3026f9abed 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2179,6 +2179,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			return ret;
 		}
 
+		slave_data->slave_node = slave_node;
 		slave_data->phy_node = of_parse_phandle(slave_node,
 							"phy-handle", 0);
 		parp = of_get_property(slave_node, "phy_id", &lenp);
@@ -2330,6 +2331,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, cpsw->dev);
+	ndev->dev.of_node = cpsw->slaves[1].data->slave_node;
 	ret = register_netdev(ndev);
 	if (ret)
 		dev_err(cpsw->dev, "cpsw: error registering net device\n");
@@ -2507,6 +2509,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, dev);
+	ndev->dev.of_node = cpsw->slaves[0].data->slave_node;
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(dev, "error registering net device\n");
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 04795b97ee71..e32f11da2dce 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -272,6 +272,7 @@ struct cpsw_host_regs {
 };
 
 struct cpsw_slave_data {
+	struct device_node *slave_node;
 	struct device_node *phy_node;
 	char		phy_id[MII_BUS_ID_SIZE];
 	int		phy_if;
-- 
2.20.1



