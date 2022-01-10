Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D79489191
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbiAJHdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38784 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiAJHbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D423C60B03;
        Mon, 10 Jan 2022 07:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC33C36AED;
        Mon, 10 Jan 2022 07:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799891;
        bh=PICXan5aO9ZTZWSwAepK2dzuaViXH9cshhkWx5vPSQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lERKGCgv33AcerL3to3Wb9ubvpDjPdh2vrQhnnxnUWuEyXuB0UMmTxaNjRAF0/3td
         SpQChz2FbdDDMmvRqifsu5F6bmmzAEtLYMNawG1Zlo8GLoX/m5IpSKgPnnBDgw7NvV
         d9etUXWW9+AplJvyWVjoL+9irkflPF0wFhSt+Lfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 24/43] net: ena: Fix undefined state when tx request id is out of bounds
Date:   Mon, 10 Jan 2022 08:23:21 +0100
Message-Id: <20220110071818.164367439@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

commit c255a34e02efb1393d23ffb205ba1a11320aeffb upstream.

ena_com_tx_comp_req_id_get() checks the req_id of a received completion,
and if it is out of bounds returns -EINVAL. This is a sign that
something is wrong with the device and it needs to be reset.

The current code does not reset the device in this case, which leaves
the driver in an undefined state, where this completion is not properly
handled.

This commit adds a call to handle_invalid_req_id() in ena_clean_tx_irq()
and ena_clean_xdp_irq() which resets the device to fix the issue.

This commit also removes unnecessary request id checks from
validate_tx_req_id() and validate_xdp_req_id(). This check is unneeded
because it was already performed in ena_com_tx_comp_req_id_get(), which
is called right before these functions.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   34 +++++++++++++++------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1199,26 +1199,22 @@ static int handle_invalid_req_id(struct
 
 static int validate_tx_req_id(struct ena_ring *tx_ring, u16 req_id)
 {
-	struct ena_tx_buffer *tx_info = NULL;
+	struct ena_tx_buffer *tx_info;
 
-	if (likely(req_id < tx_ring->ring_size)) {
-		tx_info = &tx_ring->tx_buffer_info[req_id];
-		if (likely(tx_info->skb))
-			return 0;
-	}
+	tx_info = &tx_ring->tx_buffer_info[req_id];
+	if (likely(tx_info->skb))
+		return 0;
 
 	return handle_invalid_req_id(tx_ring, req_id, tx_info, false);
 }
 
 static int validate_xdp_req_id(struct ena_ring *xdp_ring, u16 req_id)
 {
-	struct ena_tx_buffer *tx_info = NULL;
+	struct ena_tx_buffer *tx_info;
 
-	if (likely(req_id < xdp_ring->ring_size)) {
-		tx_info = &xdp_ring->tx_buffer_info[req_id];
-		if (likely(tx_info->xdpf))
-			return 0;
-	}
+	tx_info = &xdp_ring->tx_buffer_info[req_id];
+	if (likely(tx_info->xdpf))
+		return 0;
 
 	return handle_invalid_req_id(xdp_ring, req_id, tx_info, true);
 }
@@ -1243,9 +1239,14 @@ static int ena_clean_tx_irq(struct ena_r
 
 		rc = ena_com_tx_comp_req_id_get(tx_ring->ena_com_io_cq,
 						&req_id);
-		if (rc)
+		if (rc) {
+			if (unlikely(rc == -EINVAL))
+				handle_invalid_req_id(tx_ring, req_id, NULL,
+						      false);
 			break;
+		}
 
+		/* validate that the request id points to a valid skb */
 		rc = validate_tx_req_id(tx_ring, req_id);
 		if (rc)
 			break;
@@ -1801,9 +1802,14 @@ static int ena_clean_xdp_irq(struct ena_
 
 		rc = ena_com_tx_comp_req_id_get(xdp_ring->ena_com_io_cq,
 						&req_id);
-		if (rc)
+		if (rc) {
+			if (unlikely(rc == -EINVAL))
+				handle_invalid_req_id(xdp_ring, req_id, NULL,
+						      true);
 			break;
+		}
 
+		/* validate that the request id points to a valid xdp_frame */
 		rc = validate_xdp_req_id(xdp_ring, req_id);
 		if (rc)
 			break;


