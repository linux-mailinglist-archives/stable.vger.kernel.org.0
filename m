Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4BA79801
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbfG2TmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388566AbfG2TmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E08220C01;
        Mon, 29 Jul 2019 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429319;
        bh=O1vQYt8aWgXf55lft2fOPPZ64nQp9DyO7NU2Lkv8ZnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7iB2uHdW6QDgQKk/tLV8jwWHpAh7qSOzzXcoD6kjFaQ+8cXkPJdiAFt9NeHXBm0M
         K+K/V9ZG6k5m1N7wX3Y/tIXbjq/tGspHck4DJ57HXhwp2aQzus82OfUIdevFWtJxde
         LCw5QgT6Pe4jJA83l01TrJP/CnNXhJIuxAz4BXTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentine Fatiev <valentinef@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/113] IB/ipoib: Add child to parent list only if device initialized
Date:   Mon, 29 Jul 2019 21:22:27 +0200
Message-Id: <20190729190709.867511240@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 91b01061fef9c57d2f5b712a6322ef51061f4efd ]

Despite failure in ipoib_dev_init() we continue with initialization flow
and creation of child device. It causes to the situation where this child
device is added too early to parent device list.

Change the logic, so in case of failure we properly return error from
ipoib_dev_init() and add child only in success path.

Fixes: eaeb39842508 ("IB/ipoib: Move init code to ndo_init")
Signed-off-by: Valentine Fatiev <valentinef@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 34 +++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 009615499b37..78dd36daac00 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1892,12 +1892,6 @@ static void ipoib_child_init(struct net_device *ndev)
 	struct ipoib_dev_priv *priv = ipoib_priv(ndev);
 	struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
 
-	dev_hold(priv->parent);
-
-	down_write(&ppriv->vlan_rwsem);
-	list_add_tail(&priv->list, &ppriv->child_intfs);
-	up_write(&ppriv->vlan_rwsem);
-
 	priv->max_ib_mtu = ppriv->max_ib_mtu;
 	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
 	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr, INFINIBAND_ALEN);
@@ -1940,6 +1934,17 @@ static int ipoib_ndo_init(struct net_device *ndev)
 	if (rc) {
 		pr_warn("%s: failed to initialize device: %s port %d (ret = %d)\n",
 			priv->ca->name, priv->dev->name, priv->port, rc);
+		return rc;
+	}
+
+	if (priv->parent) {
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		dev_hold(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_add_tail(&priv->list, &ppriv->child_intfs);
+		up_write(&ppriv->vlan_rwsem);
 	}
 
 	return 0;
@@ -1957,6 +1962,14 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 	 */
 	WARN_ON(!list_empty(&priv->child_intfs));
 
+	if (priv->parent) {
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_del(&priv->list);
+		up_write(&ppriv->vlan_rwsem);
+	}
+
 	ipoib_neigh_hash_uninit(dev);
 
 	ipoib_ib_dev_cleanup(dev);
@@ -1968,15 +1981,8 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 		priv->wq = NULL;
 	}
 
-	if (priv->parent) {
-		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
-
-		down_write(&ppriv->vlan_rwsem);
-		list_del(&priv->list);
-		up_write(&ppriv->vlan_rwsem);
-
+	if (priv->parent)
 		dev_put(priv->parent);
-	}
 }
 
 static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
-- 
2.20.1



