Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6D017213A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgB0Nmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgB0Nma (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:42:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D5F720726;
        Thu, 27 Feb 2020 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810950;
        bh=ceEKIn991IqRty82jZ7YFd0bpyp4Qtq2iCa6roB5hYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBUGHRd6vlp8whaKyaWpjAlKCSfGaiAY2oH+l6WsdxDaG+pdHY8IuFJIwYxvKnR95
         Gkfwswu872wdDj2uEP71kEuc4XzQybUcHS/OIFlQo3bOnBYGNJRRRONlDO4BYeiz1N
         lVUQ+WUX+3EnHPDTtCAFNokSNgv3eBtNeaCl0lkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 021/113] gianfar: Fix TX timestamping with a stacked DSA driver
Date:   Thu, 27 Feb 2020 14:35:37 +0100
Message-Id: <20200227132215.055211164@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit c26a2c2ddc0115eb088873f5c309cf46b982f522 ]

The driver wrongly assumes that it is the only entity that can set the
SKBTX_IN_PROGRESS bit of the current skb. Therefore, in the
gfar_clean_tx_ring function, where the TX timestamp is collected if
necessary, the aforementioned bit is used to discriminate whether or not
the TX timestamp should be delivered to the socket's error queue.

But a stacked driver such as a DSA switch can also set the
SKBTX_IN_PROGRESS bit, which is actually exactly what it should do in
order to denote that the hardware timestamping process is undergoing.

Therefore, gianfar would misinterpret the "in progress" bit as being its
own, and deliver a second skb clone in the socket's error queue,
completely throwing off a PTP process which is not expecting to receive
it, _even though_ TX timestamping is not enabled for gianfar.

There have been discussions [0] as to whether non-MAC drivers need or
not to set SKBTX_IN_PROGRESS at all (whose purpose is to avoid sending 2
timestamps, a sw and a hw one, to applications which only expect one).
But as of this patch, there are at least 2 PTP drivers that would break
in conjunction with gianfar: the sja1105 DSA switch and the felix
switch, by way of its ocelot core driver.

So regardless of that conclusion, fix the gianfar driver to not do stuff
based on flags set by others and not intended for it.

[0]: https://www.spinics.net/lists/netdev/msg619699.html

Fixes: f0ee7acfcdd4 ("gianfar: Add hardware TX timestamping support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 2d61369f586f7..37cc1f838dd8b 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2679,13 +2679,17 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	skb_dirtytx = tx_queue->skb_dirtytx;
 
 	while ((skb = tx_queue->tx_skbuff[skb_dirtytx])) {
+		bool do_tstamp;
+
+		do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+			    priv->hwts_tx_en;
 
 		frags = skb_shinfo(skb)->nr_frags;
 
 		/* When time stamping, one additional TxBD must be freed.
 		 * Also, we need to dma_unmap_single() the TxPAL.
 		 */
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
+		if (unlikely(do_tstamp))
 			nr_txbds = frags + 2;
 		else
 			nr_txbds = frags + 1;
@@ -2699,7 +2703,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		    (lstatus & BD_LENGTH_MASK))
 			break;
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			next = next_txbd(bdp, base, tx_ring_size);
 			buflen = be16_to_cpu(next->length) +
 				 GMAC_FCB_LEN + GMAC_TXPAL_LEN;
@@ -2709,7 +2713,7 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 		dma_unmap_single(priv->dev, be32_to_cpu(bdp->bufPtr),
 				 buflen, DMA_TO_DEVICE);
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			u64 *ns = (u64 *)(((uintptr_t)skb->data + 0x10) &
 					  ~0x7UL);
-- 
2.20.1



