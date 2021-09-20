Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3AE412567
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbhITSpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382341AbhITSmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A42606A5;
        Mon, 20 Sep 2021 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159094;
        bh=KWobmcZSd6RR3vyoGzkU3FQ8g5SyZFJgL0SLDDI7sHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRrI/lrNeqMAqnMb7Rd7zBNayOrLqmNLYyn8xN5NjSIkOOu3s++dvTWEFLAYYqeiR
         1kOH2SDEG4ZXmeoaBl1h/kyuScgp6RuhSlsUn5DuSLCuxDtpLyEBmDfgHKz1npwjdP
         3b2FhvagGUTeC64dhvyKhRpgdldz5tn1dZfwLT60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 074/168] bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
Date:   Mon, 20 Sep 2021 18:43:32 +0200
Message-Id: <20210920163924.076495809@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

commit 1affc01fdc6035189a5ab2a24948c9419ee0ecf2 upstream.

The call to bnxt_free_mem(..., false) in the bnxt_half_open_nic() error
path will deallocate ring descriptor memory via bnxt_free_?x_rings(),
but because irq_re_init is false, the ring info itself is not freed.

To simplify error paths, deallocation functions have generally been
written to be safe when called on unallocated memory. It should always
be safe to call dev_close(), which calls bnxt_free_skbs() a second time,
even in this semi- allocated ring state.

Calling bnxt_free_skbs() a second time with the rings already freed will
cause NULL pointer dereference.  Fix it by checking the rings are valid
before proceeding in bnxt_free_tx_skbs() and
bnxt_free_one_rx_ring_skbs().

Fixes: 975bc99a4a39 ("bnxt_en: Refactor bnxt_free_rx_skbs().")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2680,6 +2680,9 @@ static void bnxt_free_tx_skbs(struct bnx
 		struct bnxt_tx_ring_info *txr = &bp->tx_ring[i];
 		int j;
 
+		if (!txr->tx_buf_ring)
+			continue;
+
 		for (j = 0; j < max_idx;) {
 			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
 			struct sk_buff *skb;
@@ -2764,6 +2767,9 @@ static void bnxt_free_one_rx_ring_skbs(s
 	}
 
 skip_rx_tpa_free:
+	if (!rxr->rx_buf_ring)
+		goto skip_rx_buf_free;
+
 	for (i = 0; i < max_idx; i++) {
 		struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[i];
 		dma_addr_t mapping = rx_buf->mapping;
@@ -2786,6 +2792,11 @@ skip_rx_tpa_free:
 			kfree(data);
 		}
 	}
+
+skip_rx_buf_free:
+	if (!rxr->rx_agg_ring)
+		goto skip_rx_agg_free;
+
 	for (i = 0; i < max_agg_idx; i++) {
 		struct bnxt_sw_rx_agg_bd *rx_agg_buf = &rxr->rx_agg_ring[i];
 		struct page *page = rx_agg_buf->page;
@@ -2802,6 +2813,8 @@ skip_rx_tpa_free:
 
 		__free_page(page);
 	}
+
+skip_rx_agg_free:
 	if (rxr->rx_page) {
 		__free_page(rxr->rx_page);
 		rxr->rx_page = NULL;


