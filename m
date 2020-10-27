Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C142429B258
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761422AbgJ0Oji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761416AbgJ0Ojf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41441207BB;
        Tue, 27 Oct 2020 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809574;
        bh=emrf5UDSxYyt/+hB/f1698NU9wmvd0jrudNuvQZg7Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gevp7jLRUlE2cCj23mi50rRT0oFIZpnGecJ6TNto0h9mQfWTAR1nx7gfP8QAULnnc
         CONkcEe6DgU1v9qCHp+meIdXnuQB29+Q4VCrE9mNQcZEqG0lfyhU+qQeYqyWEB7A/Q
         Cs2HcbontYb1C61QRtyZXaCW0fKcqvgXpuqKFr90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 243/408] RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces
Date:   Tue, 27 Oct 2020 14:53:01 +0100
Message-Id: <20201027135506.327777437@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 044bcacad6e48..69ecf37053a81 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2463,6 +2463,8 @@ static struct net_device *ipoib_add_port(const char *format,
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
index 8ac8e18fbe0c3..58ca5e9c6079c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -192,6 +192,8 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	}
 	priv = ipoib_priv(ndev);
 
+	ndev->rtnl_link_ops = ipoib_get_link_ops();
+
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);
 
 	if (result && ndev->reg_state == NETREG_UNINITIALIZED)
-- 
2.25.1



