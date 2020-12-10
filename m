Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F872D6681
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbgLJOaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390235AbgLJO34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:29:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 06/45] ibmvnic: Ensure that SCRQ entry reads are correctly ordered
Date:   Thu, 10 Dec 2020 15:26:20 +0100
Message-Id: <20201210142602.677822885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit b71ec952234610b4f90ef17a2fdcb124d5320070 ]

Ensure that received Subordinate Command-Response Queue (SCRQ)
entries are properly read in order by the driver. These queues
are used in the ibmvnic device to process RX buffer and TX completion
descriptors. dma_rmb barriers have been added after checking for a
pending descriptor to ensure the correct descriptor entry is checked
and after reading the SCRQ descriptor to ensure the entire
descriptor is read before processing.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -985,6 +985,12 @@ restart_poll:
 
 		if (!pending_scrq(adapter, adapter->rx_scrq[scrq_num]))
 			break;
+		/* The queue entry at the current index is peeked at above
+		 * to determine that there is a valid descriptor awaiting
+		 * processing. We want to be sure that the current slot
+		 * holds a valid descriptor before reading its contents.
+		 */
+		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
@@ -1373,6 +1379,13 @@ restart_loop:
 	while (pending_scrq(adapter, scrq)) {
 		unsigned int pool = scrq->pool_index;
 
+		/* The queue entry at the current index is peeked at above
+		 * to determine that there is a valid descriptor awaiting
+		 * processing. We want to be sure that the current slot
+		 * holds a valid descriptor before reading its contents.
+		 */
+		dma_rmb();
+
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
 			if (next->tx_comp.rcs[i]) {
@@ -1707,6 +1720,11 @@ static union sub_crq *ibmvnic_next_scrq(
 	}
 	spin_unlock_irqrestore(&scrq->lock, flags);
 
+	/* Ensure that the entire buffer descriptor has been
+	 * loaded before reading its contents
+	 */
+	dma_rmb();
+
 	return entry;
 }
 


