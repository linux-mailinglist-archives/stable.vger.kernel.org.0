Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701C210BD1F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbfK0VBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbfK0VBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2132721555;
        Wed, 27 Nov 2019 21:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888499;
        bh=LjgfDLWpducmF8pDBK9oB34UqtgHeQLfOEMFR1elg2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLXHlOhCPr7/j9FD6rbMGtvmqa0McgcXWBV7LMoo91mizCGUvlY0KklUz3HKQbv7Z
         iiuk8Z0C9DYJsoUkWXXZ8PZepo518fVbUbb+juewNyNej/zp3yFDaRST0hfheuJPPm
         vAXr+CT27bXyppHjzBV8Fc3HQYpLig/yv+2TC5eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/306] ipv4/igmp: fix v1/v2 switchback timeout based on rfc3376, 8.12
Date:   Wed, 27 Nov 2019 21:30:09 +0100
Message-Id: <20191127203127.152724285@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 966c37f2d77eb44d47af8e919267b1ba675b2eca ]

Similiar with ipv6 mcast commit 89225d1ce6af3 ("net: ipv6: mld: fix v1/v2
switchback timeout to rfc3810, 9.12.")

i) RFC3376 8.12. Older Version Querier Present Timeout says:

   The Older Version Querier Interval is the time-out for transitioning
   a host back to IGMPv3 mode once an older version query is heard.
   When an older version query is received, hosts set their Older
   Version Querier Present Timer to Older Version Querier Interval.

   This value MUST be ((the Robustness Variable) times (the Query
   Interval in the last Query received)) plus (one Query Response
   Interval).

Currently we only use a hardcode value IGMP_V1/v2_ROUTER_PRESENT_TIMEOUT.
Fix it by adding two new items mr_qi(Query Interval) and mr_qri(Query Response
Interval) in struct in_device.

Now we can calculate the switchback time via (mr_qrv * mr_qi) + mr_qri.
We need update these values when receive IGMPv3 queries.

Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h |  4 ++-
 net/ipv4/igmp.c            | 53 ++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index c759d1cbcedd8..a64f21a97369a 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -37,7 +37,9 @@ struct in_device {
 	unsigned long		mr_v1_seen;
 	unsigned long		mr_v2_seen;
 	unsigned long		mr_maxdelay;
-	unsigned char		mr_qrv;
+	unsigned long		mr_qi;		/* Query Interval */
+	unsigned long		mr_qri;		/* Query Response Interval */
+	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
 	unsigned char		mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index b2240b7f225d5..523d26f5e22e2 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -111,13 +111,10 @@
 #ifdef CONFIG_IP_MULTICAST
 /* Parameter names and values are taken from igmp-v2-06 draft */
 
-#define IGMP_V1_ROUTER_PRESENT_TIMEOUT		(400*HZ)
-#define IGMP_V2_ROUTER_PRESENT_TIMEOUT		(400*HZ)
 #define IGMP_V2_UNSOLICITED_REPORT_INTERVAL	(10*HZ)
 #define IGMP_V3_UNSOLICITED_REPORT_INTERVAL	(1*HZ)
+#define IGMP_QUERY_INTERVAL			(125*HZ)
 #define IGMP_QUERY_RESPONSE_INTERVAL		(10*HZ)
-#define IGMP_QUERY_ROBUSTNESS_VARIABLE		2
-
 
 #define IGMP_INITIAL_REPORT_DELAY		(1)
 
@@ -953,13 +950,15 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 
 			max_delay = IGMP_QUERY_RESPONSE_INTERVAL;
 			in_dev->mr_v1_seen = jiffies +
-				IGMP_V1_ROUTER_PRESENT_TIMEOUT;
+				(in_dev->mr_qrv * in_dev->mr_qi) +
+				in_dev->mr_qri;
 			group = 0;
 		} else {
 			/* v2 router present */
 			max_delay = ih->code*(HZ/IGMP_TIMER_SCALE);
 			in_dev->mr_v2_seen = jiffies +
-				IGMP_V2_ROUTER_PRESENT_TIMEOUT;
+				(in_dev->mr_qrv * in_dev->mr_qi) +
+				in_dev->mr_qri;
 		}
 		/* cancel the interface change timer */
 		in_dev->mr_ifc_count = 0;
@@ -999,8 +998,21 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (!max_delay)
 			max_delay = 1;	/* can't mod w/ 0 */
 		in_dev->mr_maxdelay = max_delay;
-		if (ih3->qrv)
-			in_dev->mr_qrv = ih3->qrv;
+
+		/* RFC3376, 4.1.6. QRV and 4.1.7. QQIC, when the most recently
+		 * received value was zero, use the default or statically
+		 * configured value.
+		 */
+		in_dev->mr_qrv = ih3->qrv ?: net->ipv4.sysctl_igmp_qrv;
+		in_dev->mr_qi = IGMPV3_QQIC(ih3->qqic)*HZ ?: IGMP_QUERY_INTERVAL;
+
+		/* RFC3376, 8.3. Query Response Interval:
+		 * The number of seconds represented by the [Query Response
+		 * Interval] must be less than the [Query Interval].
+		 */
+		if (in_dev->mr_qri >= in_dev->mr_qi)
+			in_dev->mr_qri = (in_dev->mr_qi/HZ - 1)*HZ;
+
 		if (!group) { /* general query */
 			if (ih3->nsrcs)
 				return true;	/* no sources allowed */
@@ -1738,18 +1750,30 @@ void ip_mc_down(struct in_device *in_dev)
 	ip_mc_dec_group(in_dev, IGMP_ALL_HOSTS);
 }
 
-void ip_mc_init_dev(struct in_device *in_dev)
-{
 #ifdef CONFIG_IP_MULTICAST
+static void ip_mc_reset(struct in_device *in_dev)
+{
 	struct net *net = dev_net(in_dev->dev);
+
+	in_dev->mr_qi = IGMP_QUERY_INTERVAL;
+	in_dev->mr_qri = IGMP_QUERY_RESPONSE_INTERVAL;
+	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
+}
+#else
+static void ip_mc_reset(struct in_device *in_dev)
+{
+}
 #endif
+
+void ip_mc_init_dev(struct in_device *in_dev)
+{
 	ASSERT_RTNL();
 
 #ifdef CONFIG_IP_MULTICAST
 	timer_setup(&in_dev->mr_gq_timer, igmp_gq_timer_expire, 0);
 	timer_setup(&in_dev->mr_ifc_timer, igmp_ifc_timer_expire, 0);
-	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
 #endif
+	ip_mc_reset(in_dev);
 
 	spin_lock_init(&in_dev->mc_tomb_lock);
 }
@@ -1759,15 +1783,10 @@ void ip_mc_init_dev(struct in_device *in_dev)
 void ip_mc_up(struct in_device *in_dev)
 {
 	struct ip_mc_list *pmc;
-#ifdef CONFIG_IP_MULTICAST
-	struct net *net = dev_net(in_dev->dev);
-#endif
 
 	ASSERT_RTNL();
 
-#ifdef CONFIG_IP_MULTICAST
-	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
-#endif
+	ip_mc_reset(in_dev);
 	ip_mc_inc_group(in_dev, IGMP_ALL_HOSTS);
 
 	for_each_pmc_rtnl(in_dev, pmc) {
-- 
2.20.1



