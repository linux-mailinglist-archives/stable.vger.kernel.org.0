Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B02F15C7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbhAKNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbhAKNLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458B321973;
        Mon, 11 Jan 2021 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370692;
        bh=D5joDTXCEwsc1YcQpwst7EBaHD/zetgkUZdTBzGhZd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbaoD0Myib9xtcF3I/Fqelr7Hhu3LC0w/7WNySru4cVsZdGQU09gwlA7VJSMUTGZ4
         KM6I/3O7NBghZ/QOWHRbdmxt5sRQVLt5F01N/yogciHTXHJ0D+WHhq/Byb9+F86yP3
         lQ3KYmwGjF46b6V77aTbI2l6kyiZA00bgus0mEks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 29/92] net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc
Date:   Mon, 11 Jan 2021 14:01:33 +0100
Message-Id: <20210111130040.549493795@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 4ae2bb81649dc03dfc95875f02126b14b773f7ab ]

Accesses to dev->xps_rxqs_map (when using dev->num_tc) should be
protected by the rtnl lock, like we do for netif_set_xps_queue. I didn't
see an actual bug being triggered, but let's be safe here and take the
rtnl lock while accessing the map in sysfs.

Fixes: 8af2c06ff4b1 ("net-sysfs: Add interface for Rx queue(s) map per Tx queue")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1347,22 +1347,29 @@ static struct netdev_queue_attribute xps
 
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
+	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
 	unsigned long *mask, index;
-	int j, len, num_tc = 1, tc = 0;
 
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
 	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
-	if (!mask)
-		return -ENOMEM;
+	if (!mask) {
+		ret = -ENOMEM;
+		goto err_rtnl_unlock;
+	}
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_rxqs_map);
@@ -1388,10 +1395,16 @@ static ssize_t xps_rxqs_show(struct netd
 out_no_maps:
 	rcu_read_unlock();
 
+	rtnl_unlock();
+
 	len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
 	bitmap_free(mask);
 
 	return len < PAGE_SIZE ? len : -EINVAL;
+
+err_rtnl_unlock:
+	rtnl_unlock();
+	return ret;
 }
 
 static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,


