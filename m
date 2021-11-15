Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8474450BE9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhKORbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237992AbhKOR2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:28:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A05786326A;
        Mon, 15 Nov 2021 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996748;
        bh=LbtfJxVw5J2ou5RSUK4eQ9EBcue+ThouKW02Wug48dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN8WSXn3g8IPKkymo+jyk0IoFLORIJ1usz/VdDQTj2Uu0dKrhYkjJV6PTAzVDKGbw
         C2Meuf07DGhxyvU53yf9NMSBNq9CxEJTP27Jdn22IbCU3hRyEwGbyBTVP9EmH0y+e5
         8l/AJcI3KC1KHTV3T2Mo7tmLYTTODWGG5i47DqBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@in.ibm.com>,
        Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 254/355] ibmvnic: dont stop queue in xmit
Date:   Mon, 15 Nov 2021 18:02:58 +0100
Message-Id: <20211115165321.960800692@linuxfoundation.org>
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

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 8878e46fcfd46b19964bd90e13b25dd94cbfc9be ]

If adapter's resetting bit is on, discard the packet but don't stop the
transmit queue - instead leave that to the reset code. With this change,
it is possible that we may get several calls to ibmvnic_xmit() that simply
discard packets and return.

But if we stop the queue here, we might end up doing so just after
__ibmvnic_open() started the queues (during a hard/soft reset) and before
the ->resetting bit was cleared. If that happens, there will be no one to
restart queue and transmissions will be blocked indefinitely.

This can cause a TIMEOUT reset and with auto priority failover enabled,
an unnecessary FAILOVER reset to less favored backing device and then a
FAILOVER back to the most favored backing device. If we hit the window
repeatedly, we can get stuck in a loop of TIMEOUT, FAILOVER, FAILOVER
resets leaving the adapter unusable for extended periods of time.

Fixes: 7f5b030830fe ("ibmvnic: Free skb's in cases of failure in transmit")
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cfe7229593ead..059eaa13e2c6d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1462,8 +1462,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	netdev_tx_t ret = NETDEV_TX_OK;
 
 	if (test_bit(0, &adapter->resetting)) {
-		if (!netif_subqueue_stopped(netdev, skb))
-			netif_stop_subqueue(netdev, queue_num);
 		dev_kfree_skb_any(skb);
 
 		tx_send_failed++;
-- 
2.33.0



