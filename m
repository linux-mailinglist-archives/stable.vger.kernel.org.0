Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841DA383004
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbhEQOXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239173AbhEQOVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EDB601FC;
        Mon, 17 May 2021 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260693;
        bh=N+K6TTedcgDguB5TVUshG9q0umiFW1TPlM1eEe/yEA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfLJ8oQ/SCJQKZmg0m8t+43/Ipt18dU2ClRa+cLIXQRpxAYjY4tlX7pylv05vFUkP
         amtVDlTeNli/m+BAz1VuXD8mhOyyFJ/Vw+STMvhAg086209vy4Wllj0bPa/hnf0Om9
         GMzCSKoDylXh1iEuA1h8eoEpQWuHdUenWd3WpKkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 197/363] net: hns3: use netif_tx_disable to stop the transmit queue
Date:   Mon, 17 May 2021 16:01:03 +0200
Message-Id: <20210517140309.251160673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit b416e872be06fdace3c36cf5210130509d0f0e72 ]

Currently, netif_tx_stop_all_queues() is used to ensure that
the xmit is not running, but for the concurrent case it will
not take effect, since netif_tx_stop_all_queues() just sets
a flag without locking to indicate that the xmit queue(s)
should not be run.

So use netif_tx_disable() to replace netif_tx_stop_all_queues(),
it takes the xmit queue lock while marking the queue stopped.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d24bafb7ce46..0f70158c2551 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -576,8 +576,8 @@ static int hns3_nic_net_stop(struct net_device *netdev)
 	if (h->ae_algo->ops->set_timer_task)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, false);
 
-	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 
 	hns3_nic_net_down(netdev);
 
-- 
2.30.2



