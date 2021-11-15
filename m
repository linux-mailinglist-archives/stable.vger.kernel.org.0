Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18D8452651
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349472AbhKPCEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240017AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6BCA63374;
        Mon, 15 Nov 2021 17:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998080;
        bh=cDy9XcvhmkO3ObD+rOmUBqLmsKvh3pd0US/7GIZve9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aiyxm8L/hzT1MM7PyWDPte4nJSKshresguwlnEpRY4zrf7xkEVyi+OcVCuZ+HWJlo
         1qkWnigaK3P5P6pWWnE8LNeAoizDPDcdu0I/AtoiyLO8dfuUKlhurAS7xN42/WSno+
         vBM2RC7GvSPI8Xta6JjnJT8lnDZyryvPMi7UiDRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@in.ibm.com>,
        Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/575] ibmvnic: dont stop queue in xmit
Date:   Mon, 15 Nov 2021 18:01:45 +0100
Message-Id: <20211115165356.920829056@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index bb8d0a0f48ee0..c470dbc03a23e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1548,8 +1548,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	netdev_tx_t ret = NETDEV_TX_OK;
 
 	if (test_bit(0, &adapter->resetting)) {
-		if (!netif_subqueue_stopped(netdev, skb))
-			netif_stop_subqueue(netdev, queue_num);
 		dev_kfree_skb_any(skb);
 
 		tx_send_failed++;
-- 
2.33.0



