Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E615A657F2A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiL1QCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiL1QCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:02:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D25193F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF186B817AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1192EC433EF;
        Wed, 28 Dec 2022 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243308;
        bh=1BN7NflcRNVQV6i2iiiSG7xD+G/qmlC9PE9l11AK3v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ory9I1x5pN7EyOTR9v6wacF2XU4cMuAhSSbpuOz9HTRzecJ9yvifPWphixgXysjG
         gO2GRGFNoONws6FQOTnXq5c6FQvqUwqpGeX2p6NOv2edRre4HKuguHEZLCWTZcqeUM
         30YVbzE8pY4VQAmicoQ85bmp6ofwE2E7W3wNtckQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0515/1073] net: Remove the obsolte u64_stats_fetch_*_irq() users (net).
Date:   Wed, 28 Dec 2022 15:35:03 +0100
Message-Id: <20221228144342.033602388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d120d1a63b2c484d6175873d8ee736a633f74b70 ]

Now that the 32bit UP oddity is gone and 32bit uses always a sequence
count, there is no need for the fetch_irq() variants anymore.

Convert to the regular interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1dbd8d9a82e3 ("ipvs: use u64_stats_t for the per-cpu counters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c           |  4 ++--
 net/bridge/br_multicast.c      |  4 ++--
 net/bridge/br_vlan.c           |  4 ++--
 net/core/dev.c                 |  4 ++--
 net/core/devlink.c             |  4 ++--
 net/core/drop_monitor.c        |  8 ++++----
 net/core/gen_stats.c           | 16 ++++++++--------
 net/dsa/slave.c                |  4 ++--
 net/ipv4/af_inet.c             |  4 ++--
 net/ipv6/seg6_local.c          |  4 ++--
 net/mac80211/sta_info.c        |  8 ++++----
 net/mpls/af_mpls.c             |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c |  4 ++--
 net/netfilter/nf_tables_api.c  |  4 ++--
 net/openvswitch/datapath.c     |  4 ++--
 net/openvswitch/flow_table.c   |  9 ++++-----
 16 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 035812b0461c..ecdb47712d95 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -712,13 +712,13 @@ static void vlan_dev_get_stats64(struct net_device *dev,
 
 		p = per_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			rxpackets	= u64_stats_read(&p->rx_packets);
 			rxbytes		= u64_stats_read(&p->rx_bytes);
 			rxmulticast	= u64_stats_read(&p->rx_multicast);
 			txpackets	= u64_stats_read(&p->tx_packets);
 			txbytes		= u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= rxpackets;
 		stats->rx_bytes		+= rxbytes;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd..7e2a9fb5786c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4899,9 +4899,9 @@ void br_multicast_get_stats(const struct net_bridge *br,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			memcpy(&temp, &cpu_stats->mstats, sizeof(temp));
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		mcast_stats_add_dir(tdst.igmp_v1queries, temp.igmp_v1queries);
 		mcast_stats_add_dir(tdst.igmp_v2queries, temp.igmp_v2queries);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 9ffd40b8270c..bc75fa1e4666 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1389,12 +1389,12 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 
 		cpu_stats = per_cpu_ptr(v->stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rxpackets = u64_stats_read(&cpu_stats->rx_packets);
 			rxbytes = u64_stats_read(&cpu_stats->rx_bytes);
 			txbytes = u64_stats_read(&cpu_stats->tx_bytes);
 			txpackets = u64_stats_read(&cpu_stats->tx_packets);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->rx_packets, rxpackets);
 		u64_stats_add(&stats->rx_bytes, rxbytes);
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c14f48d2457..d2ab54c9c3ed 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10496,12 +10496,12 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 
 		stats = per_cpu_ptr(netstats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			rx_packets = u64_stats_read(&stats->rx_packets);
 			rx_bytes   = u64_stats_read(&stats->rx_bytes);
 			tx_packets = u64_stats_read(&stats->tx_packets);
 			tx_bytes   = u64_stats_read(&stats->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		s->rx_packets += rx_packets;
 		s->rx_bytes   += rx_bytes;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b50bcc18b8d9..cfa6a099457a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8268,10 +8268,10 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 
 		cpu_stats = per_cpu_ptr(trap_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets = u64_stats_read(&cpu_stats->rx_packets);
 			rx_bytes = u64_stats_read(&cpu_stats->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->rx_packets, rx_packets);
 		u64_stats_add(&stats->rx_bytes, rx_bytes);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 75501e1bdd25..dfcaf61d972c 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1432,9 +1432,9 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
 		u64 dropped;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped = u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->dropped, dropped);
 	}
@@ -1476,9 +1476,9 @@ static void net_dm_hw_stats_read(struct net_dm_stats *stats)
 		u64 dropped;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped = u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->dropped, dropped);
 	}
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index c8d137ef5980..b71ccaec0991 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -135,10 +135,10 @@ static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_sync *bstats,
 		u64 bytes, packets;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&bcpu->syncp);
+			start = u64_stats_fetch_begin(&bcpu->syncp);
 			bytes = u64_stats_read(&bcpu->bytes);
 			packets = u64_stats_read(&bcpu->packets);
-		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+		} while (u64_stats_fetch_retry(&bcpu->syncp, start));
 
 		t_bytes += bytes;
 		t_packets += packets;
@@ -162,10 +162,10 @@ void gnet_stats_add_basic(struct gnet_stats_basic_sync *bstats,
 	}
 	do {
 		if (running)
-			start = u64_stats_fetch_begin_irq(&b->syncp);
+			start = u64_stats_fetch_begin(&b->syncp);
 		bytes = u64_stats_read(&b->bytes);
 		packets = u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
 
 	_bstats_update(bstats, bytes, packets);
 }
@@ -187,10 +187,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64 *ret_packets,
 			u64 bytes, packets;
 
 			do {
-				start = u64_stats_fetch_begin_irq(&bcpu->syncp);
+				start = u64_stats_fetch_begin(&bcpu->syncp);
 				bytes = u64_stats_read(&bcpu->bytes);
 				packets = u64_stats_read(&bcpu->packets);
-			} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+			} while (u64_stats_fetch_retry(&bcpu->syncp, start));
 
 			t_bytes += bytes;
 			t_packets += packets;
@@ -201,10 +201,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64 *ret_packets,
 	}
 	do {
 		if (running)
-			start = u64_stats_fetch_begin_irq(&b->syncp);
+			start = u64_stats_fetch_begin(&b->syncp);
 		*ret_bytes = u64_stats_read(&b->bytes);
 		*ret_packets = u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
 }
 
 static int
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1291c2431d44..dcc550b87162 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -934,12 +934,12 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 
 		s = per_cpu_ptr(dev->tstats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&s->syncp);
+			start = u64_stats_fetch_begin(&s->syncp);
 			tx_packets = u64_stats_read(&s->tx_packets);
 			tx_bytes = u64_stats_read(&s->tx_bytes);
 			rx_packets = u64_stats_read(&s->rx_packets);
 			rx_bytes = u64_stats_read(&s->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+		} while (u64_stats_fetch_retry(&s->syncp, start));
 		data[0] += tx_packets;
 		data[1] += tx_bytes;
 		data[2] += rx_packets;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 4c8782df8eef..31f463f46f6e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1686,9 +1686,9 @@ u64 snmp_get_cpu_field64(void __percpu *mib, int cpu, int offt,
 	bhptr = per_cpu_ptr(mib, cpu);
 	syncp = (struct u64_stats_sync *)(bhptr + syncp_offset);
 	do {
-		start = u64_stats_fetch_begin_irq(syncp);
+		start = u64_stats_fetch_begin(syncp);
 		v = *(((u64 *)bhptr) + offt);
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 
 	return v;
 }
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b7de5e46fdd8..f84da849819c 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1508,13 +1508,13 @@ static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 
 		pcounters = per_cpu_ptr(slwt->pcpu_counters, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&pcounters->syncp);
+			start = u64_stats_fetch_begin(&pcounters->syncp);
 
 			packets = u64_stats_read(&pcounters->packets);
 			bytes = u64_stats_read(&pcounters->bytes);
 			errors = u64_stats_read(&pcounters->errors);
 
-		} while (u64_stats_fetch_retry_irq(&pcounters->syncp, start));
+		} while (u64_stats_fetch_retry(&pcounters->syncp, start));
 
 		counters.packets += packets;
 		counters.bytes += bytes;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9d7b238a6737..965b9cb2ef3f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2316,9 +2316,9 @@ static inline u64 sta_get_tidstats_msdu(struct ieee80211_sta_rx_stats *rxstats,
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
+		start = u64_stats_fetch_begin(&rxstats->syncp);
 		value = rxstats->msdu[tid];
-	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
 
 	return value;
 }
@@ -2384,9 +2384,9 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
+		start = u64_stats_fetch_begin(&rxstats->syncp);
 		value = rxstats->bytes;
-	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
 
 	return value;
 }
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index b52afe316dc4..35b5f806fdda 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1079,9 +1079,9 @@ static void mpls_get_stats(struct mpls_dev *mdev,
 
 		p = per_cpu_ptr(mdev->stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			local = p->stats;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= local.rx_packets;
 		stats->rx_bytes		+= local.rx_bytes;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index efab2b06d373..5a7349002508 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2296,13 +2296,13 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 		u64 conns, inpkts, outpkts, inbytes, outbytes;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&u->syncp);
+			start = u64_stats_fetch_begin(&u->syncp);
 			conns = u->cnt.conns;
 			inpkts = u->cnt.inpkts;
 			outpkts = u->cnt.outpkts;
 			inbytes = u->cnt.inbytes;
 			outbytes = u->cnt.outbytes;
-		} while (u64_stats_fetch_retry_irq(&u->syncp, start));
+		} while (u64_stats_fetch_retry(&u->syncp, start));
 
 		seq_printf(seq, "%3X %8LX %8LX %8LX %16LX %16LX\n",
 			   i, (u64)conns, (u64)inpkts,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a6f3c1e9ab7..7977f0422ecf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1534,10 +1534,10 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
 		do {
-			seq = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			seq = u64_stats_fetch_begin(&cpu_stats->syncp);
 			pkts = cpu_stats->pkts;
 			bytes = cpu_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, seq));
 		total.pkts += pkts;
 		total.bytes += bytes;
 	}
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8a22574ed7ad..ae7d4d03790c 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -715,9 +715,9 @@ static void get_dp_stats(const struct datapath *dp, struct ovs_dp_stats *stats,
 		percpu_stats = per_cpu_ptr(dp->stats_percpu, i);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&percpu_stats->syncp);
+			start = u64_stats_fetch_begin(&percpu_stats->syncp);
 			local_stats = *percpu_stats;
-		} while (u64_stats_fetch_retry_irq(&percpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&percpu_stats->syncp, start));
 
 		stats->n_hit += local_stats.n_hit;
 		stats->n_missed += local_stats.n_missed;
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index d4a2db0b2299..0a0e4c283f02 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -205,9 +205,9 @@ static void tbl_mask_array_reset_counters(struct mask_array *ma)
 
 			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				start = u64_stats_fetch_begin(&stats->syncp);
 				counter = stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 			ma->masks_usage_zero_cntr[i] += counter;
 		}
@@ -1136,10 +1136,9 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 
 			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				start = u64_stats_fetch_begin(&stats->syncp);
 				counter = stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp,
-							   start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 			masks_and_count[i].counter += counter;
 		}
-- 
2.35.1



