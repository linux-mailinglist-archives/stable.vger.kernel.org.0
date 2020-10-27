Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C429BF64
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789795AbgJ0PIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791042AbgJ0PGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D507821707;
        Tue, 27 Oct 2020 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811163;
        bh=16ANnKc6upKLsT4pgShWC2pCzImtlVwSmtsMVwUTqmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02+R46sqkGghdk6ZuhWj/l50HefJFrqGi2WL/H3fXt1FeMccD4OW73FGf4+stTVL7
         Pl+x5zs9Z58qAI6/mD/an+MhsVlc7MuNxXrPvRm1ZkJDyzg9OvZQx5qTh8c2QvXkYL
         zmd+KAetIKJo+2qkEkLXSEks2eWm5h+1F1gjB8Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 396/633] RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces
Date:   Tue, 27 Oct 2020 14:52:19 +0100
Message-Id: <20201027135541.288070303@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 5ce2dced8e95e76ff7439863a118a053a7fc6f91 ]

Report the "ipoib pkey", "mode" and "umcast" netlink attributes for every
IPoiB interface type, not just children created with 'ip link add'.

After setting the rtnl_link_ops for the parent interface, implement the
dellink() callback to block users from trying to remove it.

Fixes: 862096a8bbf8 ("IB/ipoib: Add more rtnl_link_ops callbacks")
Link: https://lore.kernel.org/r/20201004132948.26669-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |  2 ++
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 11 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index ef60e8e4ae67b..7c0bb2642d232 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2470,6 +2470,8 @@ static struct net_device *ipoib_add_port(const char *format,
 	/* call event handler to ensure pkey in sync */
 	queue_work(ipoib_workqueue, &priv->flush_heavy);
 
+	ndev->rtnl_link_ops = ipoib_get_link_ops();
+
 	result = register_netdev(ndev);
 	if (result) {
 		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 38c984d16996d..d5a90a66b45cf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -144,6 +144,16 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	return 0;
 }
 
+static void ipoib_del_child_link(struct net_device *dev, struct list_head *head)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+
+	if (!priv->parent)
+		return;
+
+	unregister_netdevice_queue(dev, head);
+}
+
 static size_t ipoib_get_size(const struct net_device *dev)
 {
 	return nla_total_size(2) +	/* IFLA_IPOIB_PKEY   */
@@ -158,6 +168,7 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct ipoib_dev_priv),
 	.setup		= ipoib_setup_common,
 	.newlink	= ipoib_new_child_link,
+	.dellink	= ipoib_del_child_link,
 	.changelink	= ipoib_changelink,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 30865605e0980..4c50a87ed7cc2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -195,6 +195,8 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	}
 	priv = ipoib_priv(ndev);
 
+	ndev->rtnl_link_ops = ipoib_get_link_ops();
+
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);
 
 	if (result && ndev->reg_state == NETREG_UNINITIALIZED)
-- 
2.25.1



