Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBB93C4F06
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244749AbhGLHWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243475AbhGLHS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:18:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6939A613D2;
        Mon, 12 Jul 2021 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074160;
        bh=A2AcG5QgopCrnCJ5POhV9x2cLeJLvUhxn+VFrTO8cJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZk6wnUDTzFxd1bDX87PeewAf0oxGsfP18avvNCG+aUoau/hxFUHGiSSmt+X9rM0h
         xfm0TlaEj0ePlqL7f7b03tHT4YX/sKLzn/q9GaIZP9ulNB1mQKo1dXwD5vot0uerKY
         JjspJGy+VyHJ9OnB+jpezcIA4DehDK1dcM5rBUOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 483/700] ibmvnic: clean pending indirect buffs during reset
Date:   Mon, 12 Jul 2021 08:09:26 +0200
Message-Id: <20210712061027.975706353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 65d6470d139a6c1655fccb5cbacbeaba8e8ad2f8 ]

We batch subordinate command response queue (scrq) descriptors that we
need to send to the VIOS using an "indirect" buffer. If after we queue
one or more scrqs in the indirect buffer encounter an error (say fail
to allocate an skb), we leave the queued scrq descriptors in the
indirect buffer until the next call to ibmvnic_xmit().

On the next call to ibmvnic_xmit(), it is possible that the adapter is
going through a reset and it is possible that the long term  buffers
have been unmapped on the VIOS side. If we proceed to flush (send) the
packets that are in the indirect buffer, we will end up using the old
map ids and this can cause the VIOS to trigger an unnecessary FATAL
error reset.

Instead of flushing packets remaining on the indirect_buff, discard
(clean) them instead.

Fixes: 0d973388185d4 ("ibmvnic: Introduce xmit_more support using batched subCRQ hcalls")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b2f5250f77a9..e8f4bdb1079c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -106,6 +106,8 @@ static void release_crq_queue(struct ibmvnic_adapter *);
 static int __ibmvnic_set_mac(struct net_device *, u8 *);
 static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
+static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
+					 struct ibmvnic_sub_crq_queue *tx_scrq);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -668,6 +670,7 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 
 	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
+		ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
 			return rc;
@@ -1592,7 +1595,8 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 	ind_bufp->index = 0;
 	if (atomic_sub_return(entries, &tx_scrq->used) <=
 	    (adapter->req_tx_entries_per_subcrq / 2) &&
-	    __netif_subqueue_stopped(adapter->netdev, queue_num)) {
+	    __netif_subqueue_stopped(adapter->netdev, queue_num) &&
+	    !test_bit(0, &adapter->resetting)) {
 		netif_wake_subqueue(adapter->netdev, queue_num);
 		netdev_dbg(adapter->netdev, "Started queue %d\n",
 			   queue_num);
@@ -1685,7 +1689,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -3123,6 +3126,7 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 
 			netdev_dbg(adapter->netdev, "Releasing tx_scrq[%d]\n",
 				   i);
+			ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
 			if (adapter->tx_scrq[i]->irq) {
 				free_irq(adapter->tx_scrq[i]->irq,
 					 adapter->tx_scrq[i]);
-- 
2.30.2



