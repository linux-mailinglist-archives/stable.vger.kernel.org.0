Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ECE2F151C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbhAKNf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbhAKNOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C7521534;
        Mon, 11 Jan 2021 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370830;
        bh=FSH7ezgkI3YsdGZ+zrPBeSKdAYOaKR4cvBAqoWoH4vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jE7k1nlzqn4OJ0/FggXKbBH/78vchwdDNHVnEaXzSDshpFBF/Lm+Pjf21NSOJh3B7
         frpJ+TLoQ/nu8TlVs7sUeRBIE2YYkosw5pHdw5uyJ+ekaSE4Pr8Oj6/v9NuD5eO6VU
         6uFeJFY63fpEYApBtoH5VcR0t2MZqcdeR0HjHuWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 022/145] net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
Date:   Mon, 11 Jan 2021 14:00:46 +0100
Message-Id: <20210111130049.575162179@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit fb25038586d0064123e393cadf1fadd70a9df97a ]

Accesses to dev->xps_cpus_map (when using dev->num_tc) should be
protected by the rtnl lock, like we do for netif_set_xps_queue. I didn't
see an actual bug being triggered, but let's be safe here and take the
rtnl lock while accessing the map in sysfs.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1317,8 +1317,8 @@ static const struct attribute_group dql_
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
+	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
-	int cpu, len, num_tc = 1, tc = 0;
 	struct xps_dev_maps *dev_maps;
 	cpumask_var_t mask;
 	unsigned long index;
@@ -1328,22 +1328,31 @@ static ssize_t xps_cpus_show(struct netd
 
 	index = get_netdev_queue_index(queue);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-		if (num_tc < 0)
-			return -EINVAL;
+		if (num_tc < 0) {
+			ret = -EINVAL;
+			goto err_rtnl_unlock;
+		}
 
 		/* If queue belongs to subordinate dev use its map */
 		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
+		if (tc < 0) {
+			ret = -EINVAL;
+			goto err_rtnl_unlock;
+		}
 	}
 
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
-		return -ENOMEM;
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto err_rtnl_unlock;
+	}
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_cpus_map);
@@ -1366,9 +1375,15 @@ static ssize_t xps_cpus_show(struct netd
 	}
 	rcu_read_unlock();
 
+	rtnl_unlock();
+
 	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
+
+err_rtnl_unlock:
+	rtnl_unlock();
+	return ret;
 }
 
 static ssize_t xps_cpus_store(struct netdev_queue *queue,


