Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5C2F1706
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbhAKOA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbhAKNGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80BC4227C3;
        Mon, 11 Jan 2021 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370352;
        bh=S/nDyzRhMHuWyhGGiyXlfjp3FiYLZw8KCdRMN3DqajU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=busVpSuP4PuEIsuM0zF5pC8n2edmbjE+KjgptgbIq0DJRP6x+IEUM6GeuVSwy3eI9
         ymcVyLFLZ2x87S/HNUWv09R/e5I4UVVGW4PcY9q4sflnvQZPP8W1ykYXRhejx9wY66
         VLPecWtw5N8j9W6y3TryRw8EgCWmem/89Y4SS0cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 24/57] net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
Date:   Mon, 11 Jan 2021 14:01:43 +0100
Message-Id: <20210111130034.893522704@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
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
 net/core/net-sysfs.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1207,23 +1207,30 @@ static const struct attribute_group dql_
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
+	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
-	int cpu, len, num_tc = 1, tc = 0;
 	struct xps_dev_maps *dev_maps;
 	cpumask_var_t mask;
 	unsigned long index;
 
 	index = get_netdev_queue_index(queue);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	if (dev->num_tc) {
 		num_tc = dev->num_tc;
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
 	dev_maps = rcu_dereference(dev->xps_maps);
@@ -1246,9 +1253,15 @@ static ssize_t xps_cpus_show(struct netd
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


