Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA016676B1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbjALOev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbjALOds (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9355F92F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:25:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A16B862031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920EDC433F0;
        Thu, 12 Jan 2023 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533529;
        bh=jdTnyOAe2rSjoF5u7f5LB7smfzp3TCs2Vx7z4q0pP+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDeGokauidwxj7vwAyeKBDh1WJ17QoG/l5oGKO112OBWnb7CWVuJIHOZwDb4lyp3L
         rwMn5lSnWdN9CNN15WpTzaZsaDJ7enFc5gnzZS4q569BsudqwokRLRh6tWnL9OzZmh
         e6KvY0ScRwWz8w1ZiiJmWy4GSGn1XM71OcooAdnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/783] net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME
Date:   Thu, 12 Jan 2023 14:53:03 +0100
Message-Id: <20230112135545.882864248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 847cbfc014adafeac401e19e349b0fd524f201c3 ]

As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
timestamping on TX queues with tc-etf enabled"), hardware TX
timestamping requires an skb with skb->tstamp = 0. When a packet is sent
with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
so the drivers need to explicitly reset skb->tstamp to zero after
consuming the TX time.

Create a helper named skb_txtime_consumed() which does just that. All
drivers which offload TC_SETUP_QDISC_ETF should implement it, and it
would make it easier to assess during review whether they do the right
thing in order to be compatible with hardware timestamping or not.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++------
 drivers/net/ethernet/intel/igb/igb_main.c    | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 2 +-
 include/net/pkt_sched.h                      | 9 +++++++++
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 975762ccb66f..5f9603d4c049 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -5,6 +5,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
+#include <net/pkt_sched.h>
 
 /* ENETC overhead: optional extension BD + 1 BD gap */
 #define ENETC_TXBDS_NEEDED(val)	((val) + 2)
@@ -384,12 +385,7 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
-		/* Ensure skb_mstamp_ns, which might have been populated with
-		 * the txtime, is not mistaken for a software timestamp,
-		 * because this will prevent the dispatch of our hardware
-		 * timestamp to the socket.
-		 */
-		skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(skb);
 		skb_tstamp_tx(skb, &shhwtstamps);
 	}
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f24f1a8ec2fb..2646601c3487 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5879,7 +5879,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 */
 	if (tx_ring->launchtime_enable) {
 		ts = ktime_to_timespec64(first->skb->tstamp);
-		first->skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(first->skb);
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f438cdf83e55..48192594d3d7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -946,7 +946,7 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
 		ktime_t txtime = first->skb->tstamp;
 
-		first->skb->tstamp = ktime_set(0, 0);
+		skb_txtime_consumed(first->skb);
 		context_desc->launch_time = igc_tx_launchtime(adapter,
 							      txtime);
 	} else {
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 7e58b4470570..50d5ffbad473 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -179,4 +179,13 @@ struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
 						  *offload);
 void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
 
+/* Ensure skb_mstamp_ns, which might have been populated with the txtime, is
+ * not mistaken for a software timestamp, because this will otherwise prevent
+ * the dispatch of hardware timestamps to the socket.
+ */
+static inline void skb_txtime_consumed(struct sk_buff *skb)
+{
+	skb->tstamp = ktime_set(0, 0);
+}
+
 #endif
-- 
2.35.1



