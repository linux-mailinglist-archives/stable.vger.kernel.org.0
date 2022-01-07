Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5886748789A
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiAGN4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbiAGN4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:56:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAEDC061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F36E861CE6
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3AAC36AE0;
        Fri,  7 Jan 2022 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563759;
        bh=PnwcmO9uh87BiQP8mbLoPEO12GtMepKISQ6TVbNCzhw=;
        h=Subject:To:Cc:From:Date:From;
        b=bQhw8V6a4s0b0Agjlkyr/geWfA5Ek0MwMvdvFqsHE1SFdzaxR0zSRtVi25FEvYPOF
         oKOGKYHvwLlFq/lUEJ6B6ctgC1M99SO1tKu7HpXOxdm2ql9dnIyZ4YnkUOnLcnJKes
         OBcpG7XzI1XM+Iunai6SZ2T3TC9IR5CB0677oVjE=
Subject: FAILED: patch "[PATCH] net: ena: Fix wrong rx request id by resetting device" failed to apply to 4.14-stable tree
To:     akiyano@amazon.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:55:56 +0100
Message-ID: <1641563756150164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb3d4f98f0b26eafa0b913ac3716e4714254a747 Mon Sep 17 00:00:00 2001
From: Arthur Kiyanovski <akiyano@amazon.com>
Date: Sun, 2 Jan 2022 07:37:27 +0000
Subject: [PATCH] net: ena: Fix wrong rx request id by resetting device

A wrong request id received from the device is a sign that
something is wrong with it, therefore trigger a device reset.

Also add some debug info to the "Page is NULL" print to make
it easier to debug.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2274063e34cc..52a8c60b7e29 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1428,6 +1428,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 				  u16 *next_to_clean)
 {
 	struct ena_rx_buffer *rx_info;
+	struct ena_adapter *adapter;
 	u16 len, req_id, buf = 0;
 	struct sk_buff *skb;
 	void *page_addr;
@@ -1440,8 +1441,14 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	rx_info = &rx_ring->rx_buffer_info[req_id];
 
 	if (unlikely(!rx_info->page)) {
-		netif_err(rx_ring->adapter, rx_err, rx_ring->netdev,
-			  "Page is NULL\n");
+		adapter = rx_ring->adapter;
+		netif_err(adapter, rx_err, rx_ring->netdev,
+			  "Page is NULL. qid %u req_id %u\n", rx_ring->qid, req_id);
+		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1, &rx_ring->syncp);
+		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+		/* Make sure reset reason is set before triggering the reset */
+		smp_mb__before_atomic();
+		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 		return NULL;
 	}
 

