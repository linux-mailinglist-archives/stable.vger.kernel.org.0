Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6DF45BC98
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhKXMbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343642AbhKXM30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72BDA60551;
        Wed, 24 Nov 2021 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756270;
        bh=qd3AaXFFmuIehD7f2iErR14d7hKFPgRGTOUtdBN11Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVr0ndRlaoeVtu9oxmsXKFgH005fcJD+1s6K5is86itbtYX754Ec827UminuLWgA2
         n6jc4aEvvj+Tsnc2kclbv5LCdZ/nCQzV+U5wE9MHQEXmV7xyGsfsc8UA4aqKqlN5sg
         llWWSsZqwqCMgE80f6uvkgbXAHCm+Cl5KjrGhYiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Jin <joe.jin@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 027/251] xen/netfront: stop tx queues during live migration
Date:   Wed, 24 Nov 2021 12:54:29 +0100
Message-Id: <20211124115711.187798869@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 1131397454bd4..89e6a50b53da5 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1441,6 +1441,10 @@ static int netfront_resume(struct xenbus_device *dev)
 
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



