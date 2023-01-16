Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7CF66C862
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjAPQin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjAPQhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:37:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFAC26856
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B4B96104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69175C433F0;
        Mon, 16 Jan 2023 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886411;
        bh=LuAHi2MEmxJzATGZGGoXnCHjr0rmtyOXS+/nVIHQn2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+nxky6QZNPthY7d4YhIiWFHmBv4usldOfMXJUb2RPVCmJGCQ/x3h4N9MHHIsj6nW
         cWNdioKXiQAuuovz1ZcPmHRJbxzwyhz5zbM+rCN46v9S4QABxFLkke4o1wZrU9ltTH
         0l57F7Ispu0k9Ribv+i0l35fEdIJQ6qscAy6NVGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 413/658] net: add atomic_long_t to net_device_stats fields
Date:   Mon, 16 Jan 2023 16:48:21 +0100
Message-Id: <20230116154928.500222105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6c1c5097781f563b70a81683ea6fdac21637573b ]

Long standing KCSAN issues are caused by data-race around
some dev->stats changes.

Most performance critical paths already use per-cpu
variables, or per-queue ones.

It is reasonable (and more correct) to use atomic operations
for the slow paths.

This patch adds an union for each field of net_device_stats,
so that we can convert paths that are not yet protected
by a spinlock or a mutex.

netdev_stats_to_stats64() no longer has an #if BITS_PER_LONG==64

Note that the memcpy() we were using on 64bit arches
had no provision to avoid load-tearing,
while atomic_long_read() is providing the needed protection
at no cost.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 58 +++++++++++++++++++++++----------------
 include/net/dst.h         |  5 ++--
 net/core/dev.c            | 14 ++--------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c70b79dba1dc..73bc0f53303f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -160,31 +160,38 @@ static inline bool dev_xmit_complete(int rc)
  *	(unsigned long) so they can be read and written atomically.
  */
 
+#define NET_DEV_STAT(FIELD)			\
+	union {					\
+		unsigned long FIELD;		\
+		atomic_long_t __##FIELD;	\
+	}
+
 struct net_device_stats {
-	unsigned long	rx_packets;
-	unsigned long	tx_packets;
-	unsigned long	rx_bytes;
-	unsigned long	tx_bytes;
-	unsigned long	rx_errors;
-	unsigned long	tx_errors;
-	unsigned long	rx_dropped;
-	unsigned long	tx_dropped;
-	unsigned long	multicast;
-	unsigned long	collisions;
-	unsigned long	rx_length_errors;
-	unsigned long	rx_over_errors;
-	unsigned long	rx_crc_errors;
-	unsigned long	rx_frame_errors;
-	unsigned long	rx_fifo_errors;
-	unsigned long	rx_missed_errors;
-	unsigned long	tx_aborted_errors;
-	unsigned long	tx_carrier_errors;
-	unsigned long	tx_fifo_errors;
-	unsigned long	tx_heartbeat_errors;
-	unsigned long	tx_window_errors;
-	unsigned long	rx_compressed;
-	unsigned long	tx_compressed;
+	NET_DEV_STAT(rx_packets);
+	NET_DEV_STAT(tx_packets);
+	NET_DEV_STAT(rx_bytes);
+	NET_DEV_STAT(tx_bytes);
+	NET_DEV_STAT(rx_errors);
+	NET_DEV_STAT(tx_errors);
+	NET_DEV_STAT(rx_dropped);
+	NET_DEV_STAT(tx_dropped);
+	NET_DEV_STAT(multicast);
+	NET_DEV_STAT(collisions);
+	NET_DEV_STAT(rx_length_errors);
+	NET_DEV_STAT(rx_over_errors);
+	NET_DEV_STAT(rx_crc_errors);
+	NET_DEV_STAT(rx_frame_errors);
+	NET_DEV_STAT(rx_fifo_errors);
+	NET_DEV_STAT(rx_missed_errors);
+	NET_DEV_STAT(tx_aborted_errors);
+	NET_DEV_STAT(tx_carrier_errors);
+	NET_DEV_STAT(tx_fifo_errors);
+	NET_DEV_STAT(tx_heartbeat_errors);
+	NET_DEV_STAT(tx_window_errors);
+	NET_DEV_STAT(rx_compressed);
+	NET_DEV_STAT(tx_compressed);
 };
+#undef NET_DEV_STAT
 
 
 #include <linux/cache.h>
@@ -4936,4 +4943,9 @@ do {								\
 
 extern struct net_device *blackhole_netdev;
 
+/* Note: Avoid these macros in fast path, prefer per-cpu or per-queue counters. */
+#define DEV_STATS_INC(DEV, FIELD) atomic_long_inc(&(DEV)->stats.__##FIELD)
+#define DEV_STATS_ADD(DEV, FIELD, VAL) 	\
+		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
+
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/include/net/dst.h b/include/net/dst.h
index 433f7c1ce8a9..34185e527726 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -357,9 +357,8 @@ static inline void __skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 static inline void skb_tunnel_rx(struct sk_buff *skb, struct net_device *dev,
 				 struct net *net)
 {
-	/* TODO : stats should be SMP safe */
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
+	DEV_STATS_INC(dev, rx_packets);
+	DEV_STATS_ADD(dev, rx_bytes, skb->len);
 	__skb_tunnel_rx(skb, dev, net);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 84bc6d0e8560..296bed9431f3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9461,24 +9461,16 @@ void netdev_run_todo(void)
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats)
 {
-#if BITS_PER_LONG == 64
-	BUILD_BUG_ON(sizeof(*stats64) < sizeof(*netdev_stats));
-	memcpy(stats64, netdev_stats, sizeof(*netdev_stats));
-	/* zero out counters that only exist in rtnl_link_stats64 */
-	memset((char *)stats64 + sizeof(*netdev_stats), 0,
-	       sizeof(*stats64) - sizeof(*netdev_stats));
-#else
-	size_t i, n = sizeof(*netdev_stats) / sizeof(unsigned long);
-	const unsigned long *src = (const unsigned long *)netdev_stats;
+	size_t i, n = sizeof(*netdev_stats) / sizeof(atomic_long_t);
+	const atomic_long_t *src = (atomic_long_t *)netdev_stats;
 	u64 *dst = (u64 *)stats64;
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = src[i];
+		dst[i] = atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));
-#endif
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
 
-- 
2.35.1



