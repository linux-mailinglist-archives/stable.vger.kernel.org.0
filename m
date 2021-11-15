Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D48C450ACA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhKOROq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236791AbhKORMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65BED61BF9;
        Mon, 15 Nov 2021 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996191;
        bh=TDhxsyRUCBk/oFt2N3KLseCZVZ8NY9ReJr1yWJRh2DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd3acu9EEPXQ/DnTVxv1Tz/18MJebCdaa1H0Eq73qwl+t/wk8sSVimeR+u6bGWzbc
         Zj0ZLyvmhiirDm5mftdCb1+anopDniBV+vl4XY4ANIAaQ4/FgdkMZAJ5raRdM30j8L
         UC8OizjIMdZN8i83sB4xzTv5fze4vB5TlA9T3fJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Jin <joe.jin@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/355] xen/netfront: stop tx queues during live migration
Date:   Mon, 15 Nov 2021 17:59:33 +0100
Message-Id: <20211115165315.135810649@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 042b2046d0f05cf8124c26ff65dbb6148a4404fb ]

The tx queues are not stopped during the live migration. As a result, the
ndo_start_xmit() may access netfront_info->queues which is freed by
talk_to_netback()->xennet_destroy_queues().

This patch is to netif_device_detach() at the beginning of xen-netfront
resuming, and netif_device_attach() at the end of resuming.

     CPU A                                CPU B

 talk_to_netback()
 -> if (info->queues)
        xennet_destroy_queues(info);
    to free netfront_info->queues

                                        xennet_start_xmit()
                                        to access netfront_info->queues

  -> err = xennet_create_queues(info, &num_queues);

The idea is borrowed from virtio-net.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netfront.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 88280057e0321..7d389c2cc9026 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1439,6 +1439,10 @@ static int netfront_resume(struct xenbus_device *dev)
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
+	netif_tx_lock_bh(info->netdev);
+	netif_device_detach(info->netdev);
+	netif_tx_unlock_bh(info->netdev);
+
 	xennet_disconnect_backend(info);
 	return 0;
 }
@@ -1987,6 +1991,10 @@ static int xennet_connect(struct net_device *dev)
 	 * domain a kick because we've probably just requeued some
 	 * packets.
 	 */
+	netif_tx_lock_bh(np->netdev);
+	netif_device_attach(np->netdev);
+	netif_tx_unlock_bh(np->netdev);
+
 	netif_carrier_on(np->netdev);
 	for (j = 0; j < num_queues; ++j) {
 		queue = &np->queues[j];
-- 
2.33.0



