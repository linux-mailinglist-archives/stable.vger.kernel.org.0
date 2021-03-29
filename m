Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA134C8C1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhC2IYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233522AbhC2IXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E3C61481;
        Mon, 29 Mar 2021 08:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006211;
        bh=2n0mZF2elhNL9VE8jrKJ6Bz4F6JknDGtsalWgWtOPSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JziUJdUYLMO4Y9FmUxd+T9mQvsMZPmAOdi0xrzVQyYQGwC9B63I2BIuOhSPwU7Jmw
         tH6b3SdcoCVlbEnNvOW5QxjkznSSdBZGSZviFBLQkwb9T+qEBCIPtZ9g6TdRqtYoJl
         4cL1ZN2mQDCws/dLlRl53lfBm/eyrf81T9uiq48o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/221] igb: check timestamp validity
Date:   Mon, 29 Mar 2021 09:58:09 +0200
Message-Id: <20210329075634.436384852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit f0a03a026857d6c7766eb7d5835edbf5523ca15c ]

Add a couple of checks to make sure timestamping is on and that the
timestamp value from DMA is valid. This avoids any functional issues
that could come from a misinterpreted time stamp.

One of the functions changed doesn't need a return value added because
there was no value in checking from the calling locations.

While here, fix a couple of reverse christmas tree issues next to
the code being changed.

Fixes: f56e7bba22fa ("igb: Pull timestamp from fragment before adding it to skb")
Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb.h      |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c | 11 ++++----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 31 ++++++++++++++++++-----
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index aaa954aae574..7bda8c5edea5 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -748,8 +748,8 @@ void igb_ptp_suspend(struct igb_adapter *adapter);
 void igb_ptp_rx_hang(struct igb_adapter *adapter);
 void igb_ptp_tx_hang(struct igb_adapter *adapter);
 void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb);
-void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			 struct sk_buff *skb);
+int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
+			struct sk_buff *skb);
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 0d343d050973..ebe80ec6e437 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8319,9 +8319,10 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 		return NULL;
 
 	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
-		igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb);
-		xdp->data += IGB_TS_HDR_LEN;
-		size -= IGB_TS_HDR_LEN;
+		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb)) {
+			xdp->data += IGB_TS_HDR_LEN;
+			size -= IGB_TS_HDR_LEN;
+		}
 	}
 
 	/* Determine available headroom for copy */
@@ -8382,8 +8383,8 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 
 	/* pull timestamp out of packet data */
 	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
-		igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb);
-		__skb_pull(skb, IGB_TS_HDR_LEN);
+		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb))
+			__skb_pull(skb, IGB_TS_HDR_LEN);
 	}
 
 	/* update buffer offset */
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 7cc5428c3b3d..86a576201f5f 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -856,6 +856,9 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 	dev_kfree_skb_any(skb);
 }
 
+#define IGB_RET_PTP_DISABLED 1
+#define IGB_RET_PTP_INVALID 2
+
 /**
  * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
  * @q_vector: Pointer to interrupt specific structure
@@ -864,19 +867,29 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
  *
  * This function is meant to retrieve a timestamp from the first buffer of an
  * incoming frame.  The value is stored in little endian format starting on
- * byte 8.
+ * byte 8
+ *
+ * Returns: 0 if success, nonzero if failure
  **/
-void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
-			 struct sk_buff *skb)
+int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
+			struct sk_buff *skb)
 {
-	__le64 *regval = (__le64 *)va;
 	struct igb_adapter *adapter = q_vector->adapter;
+	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
 
+	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
+		return IGB_RET_PTP_DISABLED;
+
 	/* The timestamp is recorded in little endian format.
 	 * DWORD: 0        1        2        3
 	 * Field: Reserved Reserved SYSTIML  SYSTIMH
 	 */
+
+	/* check reserved dwords are zero, be/le doesn't matter for zero */
+	if (regval[0])
+		return IGB_RET_PTP_INVALID;
+
 	igb_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
 				   le64_to_cpu(regval[1]));
 
@@ -896,6 +909,8 @@ void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 	}
 	skb_hwtstamps(skb)->hwtstamp =
 		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
+
+	return 0;
 }
 
 /**
@@ -906,13 +921,15 @@ void igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
  * This function is meant to retrieve a timestamp from the internal registers
  * of the adapter and store it in the skb.
  **/
-void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector,
-			 struct sk_buff *skb)
+void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *skb)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	u64 regval;
 	int adjust = 0;
+	u64 regval;
+
+	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
+		return;
 
 	/* If this bit is set, then the RX registers contain the time stamp. No
 	 * other packet will be time stamped until we read these registers, so
-- 
2.30.1



