Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB6224B2F5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgHTJjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgHTJjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B782173E;
        Thu, 20 Aug 2020 09:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916372;
        bh=ffdK+kkecl1OQb9W/5JFKuO9NO+PSRETHtdMz7xayp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olxiDgys1+lYxkUFvsGrIgb2VNVgotYBIxWd2OlbPEruSvFZ1AyOAvw7L/LYsSqXP
         8czy4um4/KijJH6h95GMah8M+SYuvUXA3fdupaBNW0HwcZl1KAyvoYvRA8+IvtfA/C
         aF7P0+lJFJpcDuJyGyZPT99XDZgGAsSvplX4ziAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kheib@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/204] RDMA/ipoib: Fix ABBA deadlock with ipoib_reap_ah()
Date:   Thu, 20 Aug 2020 11:20:03 +0200
Message-Id: <20200820091611.619507476@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 65936bf25f90fe440bb2d11624c7d10fab266639 ]

ipoib_mcast_carrier_on_task() insanely open codes a rtnl_lock() such that
the only time flush_workqueue() can be called is if it also clears
IPOIB_FLAG_OPER_UP.

Thus the flush inside ipoib_flush_ah() will deadlock if it gets unlucky
enough, and lockdep doesn't help us to find it early:

          CPU0               CPU1          CPU2
   __ipoib_ib_dev_flush()
      down_read(vlan_rwsem)

                         ipoib_vlan_add()
                           rtnl_trylock()
                           down_write(vlan_rwsem)

				      ipoib_mcast_carrier_on_task()
					 while (!rtnl_trylock())
					      msleep(20);

      ipoib_flush_ah()
	flush_workqueue(priv->wq)

Clean up the ah_reaper related functions and lifecycle to make sense:

 - Start/Stop of the reaper should only be done in open/stop NDOs, not in
   any other places

 - cancel and flush of the reaper should only happen in the stop NDO.
   cancel is only functional when combined with IPOIB_STOP_REAPER.

 - Non-stop places were flushing the AH's just need to flush out dead AH's
   synchronously and ignore the background task completely. It is fully
   locked and harmless to leave running.

Which ultimately fixes the ABBA deadlock by removing the unnecessary
flush_workqueue() from the problematic place under the vlan_rwsem.

Fixes: efc82eeeae4e ("IB/ipoib: No longer use flush as a parameter")
Link: https://lore.kernel.org/r/20200625174219.290842-1-kamalheib1@gmail.com
Reported-by: Kamal Heib <kheib@redhat.com>
Tested-by: Kamal Heib <kheib@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   | 65 ++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +
 2 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 6ee64c25aaff4..494f413dc3c6c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -670,13 +670,12 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	return rc;
 }
 
-static void __ipoib_reap_ah(struct net_device *dev)
+static void ipoib_reap_dead_ahs(struct ipoib_dev_priv *priv)
 {
-	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_ah *ah, *tah;
 	unsigned long flags;
 
-	netif_tx_lock_bh(dev);
+	netif_tx_lock_bh(priv->dev);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	list_for_each_entry_safe(ah, tah, &priv->dead_ahs, list)
@@ -687,37 +686,37 @@ static void __ipoib_reap_ah(struct net_device *dev)
 		}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-	netif_tx_unlock_bh(dev);
+	netif_tx_unlock_bh(priv->dev);
 }
 
 void ipoib_reap_ah(struct work_struct *work)
 {
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, ah_reap_task.work);
-	struct net_device *dev = priv->dev;
 
-	__ipoib_reap_ah(dev);
+	ipoib_reap_dead_ahs(priv);
 
 	if (!test_bit(IPOIB_STOP_REAPER, &priv->flags))
 		queue_delayed_work(priv->wq, &priv->ah_reap_task,
 				   round_jiffies_relative(HZ));
 }
 
-static void ipoib_flush_ah(struct net_device *dev)
+static void ipoib_start_ah_reaper(struct ipoib_dev_priv *priv)
 {
-	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-
-	cancel_delayed_work(&priv->ah_reap_task);
-	flush_workqueue(priv->wq);
-	ipoib_reap_ah(&priv->ah_reap_task.work);
+	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
+	queue_delayed_work(priv->wq, &priv->ah_reap_task,
+			   round_jiffies_relative(HZ));
 }
 
-static void ipoib_stop_ah(struct net_device *dev)
+static void ipoib_stop_ah_reaper(struct ipoib_dev_priv *priv)
 {
-	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	ipoib_flush_ah(dev);
+	cancel_delayed_work(&priv->ah_reap_task);
+	/*
+	 * After ipoib_stop_ah_reaper() we always go through
+	 * ipoib_reap_dead_ahs() which ensures the work is really stopped and
+	 * does a final flush out of the dead_ah's list
+	 */
 }
 
 static int recvs_pending(struct net_device *dev)
@@ -846,16 +845,6 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 	return 0;
 }
 
-void ipoib_ib_dev_stop(struct net_device *dev)
-{
-	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-
-	priv->rn_ops->ndo_stop(dev);
-
-	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
-	ipoib_flush_ah(dev);
-}
-
 int ipoib_ib_dev_open_default(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -899,10 +888,7 @@ int ipoib_ib_dev_open(struct net_device *dev)
 		return -1;
 	}
 
-	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
-	queue_delayed_work(priv->wq, &priv->ah_reap_task,
-			   round_jiffies_relative(HZ));
-
+	ipoib_start_ah_reaper(priv);
 	if (priv->rn_ops->ndo_open(dev)) {
 		pr_warn("%s: Failed to open dev\n", dev->name);
 		goto dev_stop;
@@ -913,13 +899,20 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	return 0;
 
 dev_stop:
-	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	cancel_delayed_work(&priv->ah_reap_task);
-	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
-	ipoib_ib_dev_stop(dev);
+	ipoib_stop_ah_reaper(priv);
 	return -1;
 }
 
+void ipoib_ib_dev_stop(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+
+	priv->rn_ops->ndo_stop(dev);
+
+	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
+	ipoib_stop_ah_reaper(priv);
+}
+
 void ipoib_pkey_dev_check_presence(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -1230,7 +1223,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 		ipoib_mcast_dev_flush(dev);
 		if (oper_up)
 			set_bit(IPOIB_FLAG_OPER_UP, &priv->flags);
-		ipoib_flush_ah(dev);
+		ipoib_reap_dead_ahs(priv);
 	}
 
 	if (level >= IPOIB_FLUSH_NORMAL)
@@ -1305,7 +1298,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	 * the neighbor garbage collection is stopped and reaped.
 	 * That should all be done now, so make a final ah flush.
 	 */
-	ipoib_stop_ah(dev);
+	ipoib_reap_dead_ahs(priv);
 
 	clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index ceec24d451858..29ad4129d2f48 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1975,6 +1975,8 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 
 	/* no more works over the priv->wq */
 	if (priv->wq) {
+		/* See ipoib_mcast_carrier_on_task() */
+		WARN_ON(test_bit(IPOIB_FLAG_OPER_UP, &priv->flags));
 		flush_workqueue(priv->wq);
 		destroy_workqueue(priv->wq);
 		priv->wq = NULL;
-- 
2.25.1



