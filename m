Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF414FD54E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377208AbiDLHs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357665AbiDLHkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8D032989;
        Tue, 12 Apr 2022 00:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007DAB81B4F;
        Tue, 12 Apr 2022 07:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7094EC385A5;
        Tue, 12 Apr 2022 07:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747780;
        bh=3h0XwVx3H6DPKTZTgssESrCaK9Pgn48WCI5SKP+uMZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxAFjuyJBH1s8VpAqtD18MuABo9qHlJ5NPQsgeRvVrQwgKwrd1W9nPcD2vJPTCM5Z
         D/WvJjFBmrMXdlTzLBEQB4MAGvyBnxisVgjdRt6VanBkt2zasS0bEfuUvUTRsBVwt6
         8+jMEh0UP3huvG2PRNa3dgvmqrIyjXivn9EaaqXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 204/343] net: sfc: add missing xdp queue reinitialization
Date:   Tue, 12 Apr 2022 08:30:22 +0200
Message-Id: <20220412062957.240319302@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 059a47f1da93811d37533556d67e72f2261b1127 ]

After rx/tx ring buffer size is changed, kernel panic occurs when
it acts XDP_TX or XDP_REDIRECT.

When tx/rx ring buffer size is changed(ethtool -G), sfc driver
reallocates and reinitializes rx and tx queues and their buffer
(tx_queue->buffer).
But it misses reinitializing xdp queues(efx->xdp_tx_queues).
So, while it is acting XDP_TX or XDP_REDIRECT, it uses the uninitialized
tx_queue->buffer.

A new function efx_set_xdp_channels() is separated from efx_set_channels()
to handle only xdp queues.

Splat looks like:
   BUG: kernel NULL pointer dereference, address: 000000000000002a
   #PF: supervisor write access in kernel mode
   #PF: error_code(0x0002) - not-present page
   PGD 0 P4D 0
   Oops: 0002 [#4] PREEMPT SMP NOPTI
   RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
   CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D           5.17.0+ #55 e8beeee8289528f11357029357cf
   Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
   RSP: 0018:ffff92f121e45c60 EFLAGS: 00010297
   RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
   RAX: 0000000000000040 RBX: ffff92ea506895c0 RCX: ffffffffc0330870
   RDX: 0000000000000001 RSI: 00000001139b10ce RDI: ffff92ea506895c0
   RBP: ffffffffc0358a80 R08: 00000001139b110d R09: 0000000000000000
   R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
   R13: 0000000000000018 R14: 00000001139b10ce R15: ffff92ea506895c0
   FS:  0000000000000000(0000) GS:ffff92f121ec0000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
   CR2: 000000000000002a CR3: 00000003e6810004 CR4: 00000000007706e0
   RSP: 0018:ffff92f121e85c60 EFLAGS: 00010297
   PKRU: 55555554
   RAX: 0000000000000040 RBX: ffff92ea50689700 RCX: ffffffffc0330870
   RDX: 0000000000000001 RSI: 00000001145a90ce RDI: ffff92ea50689700
   RBP: ffffffffc0358a80 R08: 00000001145a910d R09: 0000000000000000
   R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
   R13: 0000000000000018 R14: 00000001145a90ce R15: ffff92ea50689700
   FS:  0000000000000000(0000) GS:ffff92f121e80000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 000000000000002a CR3: 00000003e6810005 CR4: 00000000007706e0
   PKRU: 55555554
   Call Trace:
    <IRQ>
    efx_xdp_tx_buffers+0x12b/0x3d0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    __efx_rx_packet+0x5c3/0x930 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    efx_rx_packet+0x28c/0x2e0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    efx_ef10_ev_process+0x5f8/0xf40 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
    ? enqueue_task_fair+0x95/0x550
    efx_poll+0xc4/0x360 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 146 +++++++++++++-----------
 1 file changed, 81 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index ead550ae2709..5e587cb853b9 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -764,6 +764,85 @@ void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
+static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
+				struct efx_tx_queue *tx_queue)
+{
+	if (xdp_queue_number >= efx->xdp_tx_queue_count)
+		return -EINVAL;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Channel %u TXQ %u is XDP %u, HW %u\n",
+		  tx_queue->channel->channel, tx_queue->label,
+		  xdp_queue_number, tx_queue->queue);
+	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+	return 0;
+}
+
+static void efx_set_xdp_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	unsigned int next_queue = 0;
+	int xdp_queue_number = 0;
+	int rc;
+
+	/* We need to mark which channels really have RX and TX
+	 * queues, and adjust the TX queue numbers if we have separate
+	 * RX-only and TX-only channels.
+	 */
+	efx_for_each_channel(channel, efx) {
+		if (channel->channel < efx->tx_channel_offset)
+			continue;
+
+		if (efx_channel_is_xdp_tx(channel)) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		} else {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				netif_dbg(efx, drv, efx->net_dev,
+					  "Channel %u TXQ %u is HW %u\n",
+					  channel->channel, tx_queue->label,
+					  tx_queue->queue);
+			}
+
+			/* If XDP is borrowing queues from net stack, it must
+			 * use the queue with no csum offload, which is the
+			 * first one of the channel
+			 * (note: tx_queue_by_type is not initialized yet)
+			 */
+			if (efx->xdp_txq_queues_mode ==
+			    EFX_XDP_TX_QUEUES_BORROWED) {
+				tx_queue = &channel->tx_queue[0];
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		}
+	}
+	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number != efx->xdp_tx_queue_count);
+	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number > efx->xdp_tx_queue_count);
+
+	/* If we have more CPUs than assigned XDP TX queues, assign the already
+	 * existing queues to the exceeding CPUs
+	 */
+	next_queue = 0;
+	while (xdp_queue_number < efx->xdp_tx_queue_count) {
+		tx_queue = efx->xdp_tx_queues[next_queue++];
+		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+		if (rc == 0)
+			xdp_queue_number++;
+	}
+}
+
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
 	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
@@ -835,6 +914,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		efx_init_napi_channel(efx->channel[i]);
 	}
 
+	efx_set_xdp_channels(efx);
 out:
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
@@ -867,26 +947,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	goto out;
 }
 
-static inline int
-efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
-		     struct efx_tx_queue *tx_queue)
-{
-	if (xdp_queue_number >= efx->xdp_tx_queue_count)
-		return -EINVAL;
-
-	netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-		  tx_queue->channel->channel, tx_queue->label,
-		  xdp_queue_number, tx_queue->queue);
-	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-	return 0;
-}
-
 int efx_set_channels(struct efx_nic *efx)
 {
-	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
-	unsigned int next_queue = 0;
-	int xdp_queue_number;
 	int rc;
 
 	efx->tx_channel_offset =
@@ -904,61 +967,14 @@ int efx_set_channels(struct efx_nic *efx)
 			return -ENOMEM;
 	}
 
-	/* We need to mark which channels really have RX and TX
-	 * queues, and adjust the TX queue numbers if we have separate
-	 * RX-only and TX-only channels.
-	 */
-	xdp_queue_number = 0;
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->n_rx_channels)
 			channel->rx_queue.core_index = channel->channel;
 		else
 			channel->rx_queue.core_index = -1;
-
-		if (channel->channel >= efx->tx_channel_offset) {
-			if (efx_channel_is_xdp_tx(channel)) {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			} else {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is HW %u\n",
-						  channel->channel, tx_queue->label,
-						  tx_queue->queue);
-				}
-
-				/* If XDP is borrowing queues from net stack, it must use the queue
-				 * with no csum offload, which is the first one of the channel
-				 * (note: channel->tx_queue_by_type is not initialized yet)
-				 */
-				if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
-					tx_queue = &channel->tx_queue[0];
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			}
-		}
 	}
-	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number != efx->xdp_tx_queue_count);
-	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number > efx->xdp_tx_queue_count);
 
-	/* If we have more CPUs than assigned XDP TX queues, assign the already
-	 * existing queues to the exceeding CPUs
-	 */
-	next_queue = 0;
-	while (xdp_queue_number < efx->xdp_tx_queue_count) {
-		tx_queue = efx->xdp_tx_queues[next_queue++];
-		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-		if (rc == 0)
-			xdp_queue_number++;
-	}
+	efx_set_xdp_channels(efx);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.35.1



