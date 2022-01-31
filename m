Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954CE4A40FE
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358807AbiAaLBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358371AbiAaLAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB713B82A5C;
        Mon, 31 Jan 2022 11:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05055C340E8;
        Mon, 31 Jan 2022 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626830;
        bh=ref6tF7RBZ3165LTzpOwRWi0L1OuFqLlajqoFTwRDB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh58O+4b6EncISYcu7+Ttj6YA5Qbcg+dDUZehYISPiLZ2567FI9EvHut06CQTQLmh
         yD59Gf/0L72E3M4oC/Hy1w89ixsa+Pd6uLvHLtLBAYkSrBe7VTtK+/wZE/7M1pqXAW
         UT3AwXQqqxG25nnZLgTMFxsId+XnSp04+wSHfTKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/64] ibmvnic: init ->running_cap_crqs early
Date:   Mon, 31 Jan 2022 11:56:39 +0100
Message-Id: <20220131105217.501005104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 151b6a5c06b678687f64f2d9a99fd04d5cd32b72 ]

We use ->running_cap_crqs to determine when the ibmvnic_tasklet() should
send out the next protocol message type. i.e when we get back responses
to all our QUERY_CAPABILITY CRQs we send out REQUEST_CAPABILITY crqs.
Similiary, when we get responses to all the REQUEST_CAPABILITY crqs, we
send out the QUERY_IP_OFFLOAD CRQ.

We currently increment ->running_cap_crqs as we send out each CRQ and
have the ibmvnic_tasklet() send out the next message type, when this
running_cap_crqs count drops to 0.

This assumes that all the CRQs of the current type were sent out before
the count drops to 0. However it is possible that we send out say 6 CRQs,
get preempted and receive all the 6 responses before we send out the
remaining CRQs. This can result in ->running_cap_crqs count dropping to
zero before all messages of the current type were sent and we end up
sending the next protocol message too early.

Instead initialize the ->running_cap_crqs upfront so the tasklet will
only send the next protocol message after all responses are received.

Use the cap_reqs local variable to also detect any discrepancy (either
now or in future) in the number of capability requests we actually send.

Currently only send_query_cap() is affected by this behavior (of sending
next message early) since it is called from the worker thread (during
reset) and from application thread (during ->ndo_open()) and they can be
preempted. send_request_cap() is only called from the tasklet  which
processes CRQ responses sequentially, is not be affected.  But to
maintain the existing symmtery with send_query_capability() we update
send_request_capability() also.

Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all capabilities crqs")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 106 +++++++++++++++++++----------
 1 file changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9adfc0a7ab823..6ecbe70614378 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3258,11 +3258,25 @@ static void ibmvnic_send_req_caps(struct ibmvnic_adapter *adapter, int retry)
 	struct device *dev = &adapter->vdev->dev;
 	union ibmvnic_crq crq;
 	int max_entries;
+	int cap_reqs;
+
+	/* We send out 6 or 7 REQUEST_CAPABILITY CRQs below (depending on
+	 * the PROMISC flag). Initialize this count upfront. When the tasklet
+	 * receives a response to all of these, it will send the next protocol
+	 * message (QUERY_IP_OFFLOAD).
+	 */
+	if (!(adapter->netdev->flags & IFF_PROMISC) ||
+	    adapter->promisc_supported)
+		cap_reqs = 7;
+	else
+		cap_reqs = 6;
 
 	if (!retry) {
 		/* Sub-CRQ entries are 32 byte long */
 		int entries_page = 4 * PAGE_SIZE / (sizeof(u64) * 4);
 
+		atomic_set(&adapter->running_cap_crqs, cap_reqs);
+
 		if (adapter->min_tx_entries_per_subcrq > entries_page ||
 		    adapter->min_rx_add_entries_per_subcrq > entries_page) {
 			dev_err(dev, "Fatal, invalid entries per sub-crq\n");
@@ -3323,44 +3337,45 @@ static void ibmvnic_send_req_caps(struct ibmvnic_adapter *adapter, int retry)
 					adapter->opt_rx_comp_queues;
 
 		adapter->req_rx_add_queues = adapter->max_rx_add_queues;
+	} else {
+		atomic_add(cap_reqs, &adapter->running_cap_crqs);
 	}
-
 	memset(&crq, 0, sizeof(crq));
 	crq.request_capability.first = IBMVNIC_CRQ_CMD;
 	crq.request_capability.cmd = REQUEST_CAPABILITY;
 
 	crq.request_capability.capability = cpu_to_be16(REQ_TX_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_tx_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_RX_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_rx_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_RX_ADD_QUEUES);
 	crq.request_capability.number = cpu_to_be64(adapter->req_rx_add_queues);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability =
 	    cpu_to_be16(REQ_TX_ENTRIES_PER_SUBCRQ);
 	crq.request_capability.number =
 	    cpu_to_be64(adapter->req_tx_entries_per_subcrq);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability =
 	    cpu_to_be16(REQ_RX_ADD_ENTRIES_PER_SUBCRQ);
 	crq.request_capability.number =
 	    cpu_to_be64(adapter->req_rx_add_entries_per_subcrq);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	crq.request_capability.capability = cpu_to_be16(REQ_MTU);
 	crq.request_capability.number = cpu_to_be64(adapter->req_mtu);
-	atomic_inc(&adapter->running_cap_crqs);
+	cap_reqs--;
 	ibmvnic_send_crq(adapter, &crq);
 
 	if (adapter->netdev->flags & IFF_PROMISC) {
@@ -3368,16 +3383,21 @@ static void ibmvnic_send_req_caps(struct ibmvnic_adapter *adapter, int retry)
 			crq.request_capability.capability =
 			    cpu_to_be16(PROMISC_REQUESTED);
 			crq.request_capability.number = cpu_to_be64(1);
-			atomic_inc(&adapter->running_cap_crqs);
+			cap_reqs--;
 			ibmvnic_send_crq(adapter, &crq);
 		}
 	} else {
 		crq.request_capability.capability =
 		    cpu_to_be16(PROMISC_REQUESTED);
 		crq.request_capability.number = cpu_to_be64(0);
-		atomic_inc(&adapter->running_cap_crqs);
+		cap_reqs--;
 		ibmvnic_send_crq(adapter, &crq);
 	}
+
+	/* Keep at end to catch any discrepancy between expected and actual
+	 * CRQs sent.
+	 */
+	WARN_ON(cap_reqs != 0);
 }
 
 static int pending_scrq(struct ibmvnic_adapter *adapter,
@@ -3782,118 +3802,132 @@ static void send_map_query(struct ibmvnic_adapter *adapter)
 static void send_cap_queries(struct ibmvnic_adapter *adapter)
 {
 	union ibmvnic_crq crq;
+	int cap_reqs;
+
+	/* We send out 25 QUERY_CAPABILITY CRQs below.  Initialize this count
+	 * upfront. When the tasklet receives a response to all of these, it
+	 * can send out the next protocol messaage (REQUEST_CAPABILITY).
+	 */
+	cap_reqs = 25;
+
+	atomic_set(&adapter->running_cap_crqs, cap_reqs);
 
-	atomic_set(&adapter->running_cap_crqs, 0);
 	memset(&crq, 0, sizeof(crq));
 	crq.query_capability.first = IBMVNIC_CRQ_CMD;
 	crq.query_capability.cmd = QUERY_CAPABILITY;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_TX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_RX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_RX_ADD_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_TX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_RX_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_RX_ADD_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MIN_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MIN_RX_ADD_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MAX_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 	    cpu_to_be16(MAX_RX_ADD_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(TCP_IP_OFFLOAD);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(PROMISC_SUPPORTED);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MIN_MTU);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_MTU);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_MULTICAST_FILTERS);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(VLAN_HEADER_INSERTION);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(RX_VLAN_HEADER_INSERTION);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(MAX_TX_SG_ENTRIES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(RX_SG_SUPPORTED);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(OPT_TX_COMP_SUB_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(OPT_RX_COMP_QUEUES);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_RX_BUFADD_Q_PER_RX_COMP_Q);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_TX_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability =
 			cpu_to_be16(OPT_RXBA_ENTRIES_PER_SUBCRQ);
-	atomic_inc(&adapter->running_cap_crqs);
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
 
 	crq.query_capability.capability = cpu_to_be16(TX_RX_DESC_REQ);
-	atomic_inc(&adapter->running_cap_crqs);
+
 	ibmvnic_send_crq(adapter, &crq);
+	cap_reqs--;
+
+	/* Keep at end to catch any discrepancy between expected and actual
+	 * CRQs sent.
+	 */
+	WARN_ON(cap_reqs != 0);
 }
 
 static void handle_vpd_size_rsp(union ibmvnic_crq *crq,
@@ -4160,6 +4194,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	char *name;
 
 	atomic_dec(&adapter->running_cap_crqs);
+	netdev_dbg(adapter->netdev, "Outstanding request-caps: %d\n",
+		   atomic_read(&adapter->running_cap_crqs));
 	switch (be16_to_cpu(crq->request_capability_rsp.capability)) {
 	case REQ_TX_QUEUES:
 		req_value = &adapter->req_tx_queues;
-- 
2.34.1



