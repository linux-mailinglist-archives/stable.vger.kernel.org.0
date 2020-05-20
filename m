Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E321DB6C0
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgETO1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:27:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32998 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-000362-SL; Wed, 20 May 2020 15:22:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DQa-Vm; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "Richard Cochran" <richardcochran@gmail.com>
Date:   Wed, 20 May 2020 15:14:02 +0100
Message-ID: <lsq.1589984008.281174821@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 34/99] gianfar: Fix TX timestamping with a stacked
 DSA driver
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <olteanv@gmail.com>

commit c26a2c2ddc0115eb088873f5c309cf46b982f522 upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/freescale/gianfar.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2524,13 +2524,17 @@ static void gfar_clean_tx_ring(struct gf
 
 	while ((skb = tx_queue->tx_skbuff[skb_dirtytx])) {
 		unsigned long flags;
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
@@ -2544,7 +2548,7 @@ static void gfar_clean_tx_ring(struct gf
 		    (lstatus & BD_LENGTH_MASK))
 			break;
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			next = next_txbd(bdp, base, tx_ring_size);
 			buflen = next->length + GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 		} else
@@ -2553,7 +2557,7 @@ static void gfar_clean_tx_ring(struct gf
 		dma_unmap_single(priv->dev, bdp->bufPtr,
 				 buflen, DMA_TO_DEVICE);
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
+		if (unlikely(do_tstamp)) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			u64 *ns = (u64*) (((u32)skb->data + 0x10) & ~0x7);
 

