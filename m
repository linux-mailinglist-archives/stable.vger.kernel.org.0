Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D785D33B6A0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhCON6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhCON5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD6564F0C;
        Mon, 15 Mar 2021 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816658;
        bh=e3Odf/ujlT97myjnj7nsl7R2E4xSRtkYGhk0QOaYz2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmBRUO637q2nqTKAXZx9suBvHXYbWlMZfIIIEizzkyqwWnqBy2mSndn3BkpmgqXC/
         LpjszdULHA1srBwerePVgIFv31Zljch5u96EAgkiaaJNTZi/fAuwpHvbZ5Xk65AVkJ
         yx9REUJInzz3TVVlsKz/g+goMDeuvGe1d6ZPGT14=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 038/290] net: enetc: take the MDIO lock only once per NAPI poll cycle
Date:   Mon, 15 Mar 2021 14:52:11 +0100
Message-Id: <20210315135543.210083230@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 6d36ecdbc4410e61a0e02adc5d3abeee22a8ffd3 upstream.

The workaround for the ENETC MDIO erratum caused a performance
degradation of 82 Kpps (seen with IP forwarding of two 1Gbps streams of
64B packets). This is due to excessive locking and unlocking in the fast
path, which can be avoided.

By taking the MDIO read-side lock only once per NAPI poll cycle, we are
able to regain 54 Kpps (65%) of the performance hit. The rest of the
performance degradation comes from the TX data path, but unfortunately
it doesn't look like we can optimize that away easily, even with
netdev_xmit_more(), there just isn't any skb batching done, to help with
taking the MDIO lock less often than once per packet.

We need to change the register accessor type for enetc_get_tx_tstamp,
because it now runs under the enetc_lock_mdio as per the new call path
detailed below:

enetc_msix
-> napi_schedule
   -> enetc_poll
      -> enetc_lock_mdio
      -> enetc_clean_tx_ring
         -> enetc_get_tx_tstamp
      -> enetc_clean_rx_ring
      -> enetc_unlock_mdio

Fixes: fd5736bf9f23 ("enetc: Workaround for MDIO register access issue")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    |   31 ++++++------------------
 drivers/net/ethernet/freescale/enetc/enetc_hw.h |    2 +
 2 files changed, 11 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -321,6 +321,8 @@ static int enetc_poll(struct napi_struct
 	int work_done;
 	int i;
 
+	enetc_lock_mdio();
+
 	for (i = 0; i < v->count_tx_rings; i++)
 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
 			complete = false;
@@ -331,8 +333,10 @@ static int enetc_poll(struct napi_struct
 	if (work_done)
 		v->rx_napi_work = true;
 
-	if (!complete)
+	if (!complete) {
+		enetc_unlock_mdio();
 		return budget;
+	}
 
 	napi_complete_done(napi, work_done);
 
@@ -341,8 +345,6 @@ static int enetc_poll(struct napi_struct
 
 	v->rx_napi_work = false;
 
-	enetc_lock_mdio();
-
 	/* enable interrupts */
 	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
@@ -367,8 +369,8 @@ static void enetc_get_tx_tstamp(struct e
 {
 	u32 lo, hi, tstamp_lo;
 
-	lo = enetc_rd(hw, ENETC_SICTR0);
-	hi = enetc_rd(hw, ENETC_SICTR1);
+	lo = enetc_rd_hot(hw, ENETC_SICTR0);
+	hi = enetc_rd_hot(hw, ENETC_SICTR1);
 	tstamp_lo = le32_to_cpu(txbd->wb.tstamp);
 	if (lo <= tstamp_lo)
 		hi -= 1;
@@ -398,9 +400,7 @@ static bool enetc_clean_tx_ring(struct e
 	i = tx_ring->next_to_clean;
 	tx_swbd = &tx_ring->tx_swbd[i];
 
-	enetc_lock_mdio();
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
-	enetc_unlock_mdio();
 
 	do_tstamp = false;
 
@@ -443,8 +443,6 @@ static bool enetc_clean_tx_ring(struct e
 			tx_swbd = tx_ring->tx_swbd;
 		}
 
-		enetc_lock_mdio();
-
 		/* BD iteration loop end */
 		if (is_eof) {
 			tx_frm_cnt++;
@@ -455,8 +453,6 @@ static bool enetc_clean_tx_ring(struct e
 
 		if (unlikely(!bds_to_clean))
 			bds_to_clean = enetc_bd_ready_count(tx_ring, i);
-
-		enetc_unlock_mdio();
 	}
 
 	tx_ring->next_to_clean = i;
@@ -700,8 +696,6 @@ static int enetc_clean_rx_ring(struct en
 		u32 bd_status;
 		u16 size;
 
-		enetc_lock_mdio();
-
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
 			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
 
@@ -712,19 +706,15 @@ static int enetc_clean_rx_ring(struct en
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
-		if (!bd_status) {
-			enetc_unlock_mdio();
+		if (!bd_status)
 			break;
-		}
 
 		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
-		if (!skb) {
-			enetc_unlock_mdio();
+		if (!skb)
 			break;
-		}
 
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
@@ -736,7 +726,6 @@ static int enetc_clean_rx_ring(struct en
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
-			enetc_unlock_mdio();
 			dev_kfree_skb(skb);
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
@@ -776,8 +765,6 @@ static int enetc_clean_rx_ring(struct en
 
 		enetc_process_skb(rx_ring, skb);
 
-		enetc_unlock_mdio();
-
 		napi_gro_receive(napi, skb);
 
 		rx_frm_cnt++;
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -453,6 +453,8 @@ static inline u64 _enetc_rd_reg64_wa(voi
 #define enetc_wr_reg(reg, val)		_enetc_wr_reg_wa((reg), (val))
 #define enetc_rd(hw, off)		enetc_rd_reg((hw)->reg + (off))
 #define enetc_wr(hw, off, val)		enetc_wr_reg((hw)->reg + (off), val)
+#define enetc_rd_hot(hw, off)		enetc_rd_reg_hot((hw)->reg + (off))
+#define enetc_wr_hot(hw, off, val)	enetc_wr_reg_hot((hw)->reg + (off), val)
 #define enetc_rd64(hw, off)		_enetc_rd_reg64_wa((hw)->reg + (off))
 /* port register accessors - PF only */
 #define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))


