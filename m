Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9581F5F290D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJCHMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJCHMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAE23ECFC;
        Mon,  3 Oct 2022 00:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CF3960F9B;
        Mon,  3 Oct 2022 07:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50E8C433C1;
        Mon,  3 Oct 2022 07:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781145;
        bh=Q9tUnQkxGVZdqQdRAIeF9tYNgjJi/waFbFNnzAxQM14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BpIEcgFVCadC9p1JaaBwkY0LDc7cqN1vNcRUYr+s7+NJSokN9zXAqdruLV23GyKN
         xK1HJdizT4jpwhyG5FxAdaEbmr1VTKgkIsWhPgI90mHm5QQWPgMI+NO0pObPtJvCul
         o8YD8qR3HEDIKWdeC0xKXiLwbPJ8ESrBACArV+KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Kroon <jacob.kroon@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.19 014/101] can: c_can: dont cache TX messages for C_CAN cores
Date:   Mon,  3 Oct 2022 09:10:10 +0200
Message-Id: <20221003070724.856221977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 81d192c2ce74157e717e1fc4b68791f82f7499d4 upstream.

As Jacob noticed, the optimization introduced in 387da6bc7a82 ("can:
c_can: cache frames to operate as a true FIFO") doesn't properly work
on C_CAN, but on D_CAN IP cores. The exact reasons are still unknown.

For now disable caching if CAN frames in the TX path for C_CAN cores.

Fixes: 387da6bc7a82 ("can: c_can: cache frames to operate as a true FIFO")
Link: https://lore.kernel.org/all/20220928083354.1062321-1-mkl@pengutronix.de
Link: https://lore.kernel.org/all/15a8084b-9617-2da1-6704-d7e39d60643b@gmail.com
Reported-by: Jacob Kroon <jacob.kroon@gmail.com>
Tested-by: Jacob Kroon <jacob.kroon@gmail.com>
Cc: stable@vger.kernel.org # v5.15
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can.h      |   17 +++++++++++++++--
 drivers/net/can/c_can/c_can_main.c |   11 +++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -235,9 +235,22 @@ static inline u8 c_can_get_tx_tail(const
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
+static inline u8 c_can_get_tx_free(const struct c_can_priv *priv,
+				   const struct c_can_tx_ring *ring)
 {
-	return ring->obj_num - (ring->head - ring->tail);
+	u8 head = c_can_get_tx_head(ring);
+	u8 tail = c_can_get_tx_tail(ring);
+
+	if (priv->type == BOSCH_D_CAN)
+		return ring->obj_num - (ring->head - ring->tail);
+
+	/* This is not a FIFO. C/D_CAN sends out the buffers
+	 * prioritized. The lowest buffer number wins.
+	 */
+	if (head < tail)
+		return 0;
+
+	return ring->obj_num - head;
 }
 
 #endif /* C_CAN_H */
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -429,7 +429,7 @@ static void c_can_setup_receive_object(s
 static bool c_can_tx_busy(const struct c_can_priv *priv,
 			  const struct c_can_tx_ring *tx_ring)
 {
-	if (c_can_get_tx_free(tx_ring) > 0)
+	if (c_can_get_tx_free(priv, tx_ring) > 0)
 		return false;
 
 	netif_stop_queue(priv->dev);
@@ -437,7 +437,7 @@ static bool c_can_tx_busy(const struct c
 	/* Memory barrier before checking tx_free (head and tail) */
 	smp_mb();
 
-	if (c_can_get_tx_free(tx_ring) == 0) {
+	if (c_can_get_tx_free(priv, tx_ring) == 0) {
 		netdev_dbg(priv->dev,
 			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
 			   tx_ring->head, tx_ring->tail,
@@ -465,7 +465,7 @@ static netdev_tx_t c_can_start_xmit(stru
 
 	idx = c_can_get_tx_head(tx_ring);
 	tx_ring->head++;
-	if (c_can_get_tx_free(tx_ring) == 0)
+	if (c_can_get_tx_free(priv, tx_ring) == 0)
 		netif_stop_queue(dev);
 
 	if (idx < c_can_get_tx_tail(tx_ring))
@@ -748,7 +748,7 @@ static void c_can_do_tx(struct net_devic
 		return;
 
 	tx_ring->tail += pkts;
-	if (c_can_get_tx_free(tx_ring)) {
+	if (c_can_get_tx_free(priv, tx_ring)) {
 		/* Make sure that anybody stopping the queue after
 		 * this sees the new tx_ring->tail.
 		 */
@@ -760,8 +760,7 @@ static void c_can_do_tx(struct net_devic
 	stats->tx_packets += pkts;
 
 	tail = c_can_get_tx_tail(tx_ring);
-
-	if (tail == 0) {
+	if (priv->type == BOSCH_D_CAN && tail == 0) {
 		u8 head = c_can_get_tx_head(tx_ring);
 
 		/* Start transmission for all cached messages */


