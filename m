Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B889B8411
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393276AbfISWHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393269AbfISWHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688AB218AF;
        Thu, 19 Sep 2019 22:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930859;
        bh=Uuj6fa+HvSLw5t6MTO2P08i/ljV4VbXYamOjuOMQEKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7H05iGwXNmbvMunC+v0rHXuujuH3BHukx7lp/bqFNDyKweOhTeNsqvYjD5LNsXXF
         q6tA+ZUI1equuPmAXbc/WncG9fN9L5OIuqjuuirGVb8MaYeYH38PbA/wstltl1NHUb
         WSdGXSEz9WhF1jvzOmEVSSgLkbMeODUMeXlRQkvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        linyunsheng <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 013/124] net: hns: fix LED configuration for marvell phy
Date:   Fri, 20 Sep 2019 00:01:41 +0200
Message-Id: <20190919214819.627489279@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

commit f4e5f775db5a4631300dccd0de5eafb50a77c131 upstream.

Since commit(net: phy: marvell: change default m88e1510 LED configuration),
the active LED of Hip07 devices is always off, because Hip07 just
use 2 LEDs.
This patch adds a phy_register_fixup_for_uid() for m88e1510 to
correct the LED configuration.

Fixes: 077772468ec1 ("net: phy: marvell: change default m88e1510 LED configuration")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: linyunsheng <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/marvell_phy.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
@@ -1149,6 +1150,13 @@ static void hns_nic_adjust_link(struct n
 	}
 }
 
+static int hns_phy_marvell_fixup(struct phy_device *phydev)
+{
+	phydev->dev_flags |= MARVELL_PHY_LED0_LINK_LED1_ACTIVE;
+
+	return 0;
+}
+
 /**
  *hns_nic_init_phy - init phy
  *@ndev: net device
@@ -1174,6 +1182,16 @@ int hns_nic_init_phy(struct net_device *
 	if (h->phy_if != PHY_INTERFACE_MODE_XGMII) {
 		phy_dev->dev_flags = 0;
 
+		/* register the PHY fixup (for Marvell 88E1510) */
+		ret = phy_register_fixup_for_uid(MARVELL_PHY_ID_88E1510,
+						 MARVELL_PHY_ID_MASK,
+						 hns_phy_marvell_fixup);
+		/* we can live without it, so just issue a warning */
+		if (ret)
+			netdev_warn(ndev,
+				    "Cannot register PHY fixup, ret=%d\n",
+				    ret);
+
 		ret = phy_connect_direct(ndev, phy_dev, hns_nic_adjust_link,
 					 h->phy_if);
 	} else {
@@ -2429,8 +2447,11 @@ static int hns_nic_dev_remove(struct pla
 		hns_nic_uninit_ring_data(priv);
 	priv->ring_data = NULL;
 
-	if (ndev->phydev)
+	if (ndev->phydev) {
+		phy_unregister_fixup_for_uid(MARVELL_PHY_ID_88E1510,
+					     MARVELL_PHY_ID_MASK);
 		phy_disconnect(ndev->phydev);
+	}
 
 	if (!IS_ERR_OR_NULL(priv->ae_handle))
 		hnae_put_handle(priv->ae_handle);


