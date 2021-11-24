Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635A545BF24
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbhKXMz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345062AbhKXMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F352E611B0;
        Wed, 24 Nov 2021 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757033;
        bh=zEvF8YQJ9Ef75YlmViWwfvqjI04B5i7vYVM0EXYhjX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN5GtBy1Vqj94sI2WpYApRXjAnbwGmiC9LHAr7fX/yTokCGaCCSONQ4V1fHlAeJ7p
         0qxUnutM1fhh6iXvQkvGYocpQabphVpL+3xBVqumi+XHJlzJ38aryodLfzn3q2318O
         ALNLUjyrGxrUWl4bFpzIhfoqDwY+WFx6PqVtUh6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Jin <joe.jin@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/323] xen/netfront: stop tx queues during live migration
Date:   Wed, 24 Nov 2021 12:53:44 +0100
Message-Id: <20211124115720.017513576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index c8e84276e6397..a1c828ffac8b7 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1442,6 +1442,10 @@ static int netfront_resume(struct xenbus_device *dev)
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
+	netif_tx_lock_bh(info->netdev);
+	netif_device_detach(info->netdev);
+	netif_tx_unlock_bh(info->netdev);
+
 	xennet_disconnect_backend(info);
 	return 0;
 }
@@ -1990,6 +1994,10 @@ static int xennet_connect(struct net_device *dev)
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



