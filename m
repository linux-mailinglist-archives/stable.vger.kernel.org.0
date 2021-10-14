Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0442DCFD
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhJNPDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhJNPCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D6E76120A;
        Thu, 14 Oct 2021 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223560;
        bh=D+8LE65aJeazr7MPs5PYlzMbV8Jvff7TNv/Kb2Y+raE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTbHJ+BDhN4ku3dWSwPRmjFsYX9W3x7yRxZgoG/nTJD1tPCYCpP6+A60e5xPXIfur
         T74gbqz9FBZ06OCSdxjyF9eJLSToJMHa1Jk8eZL36a9cb5ZNf5zDLAsyNzOl1y8r6E
         7e68GWmLj97CIv/9Z6QQl3QCNT4DdxcVUydH/1hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: [PATCH 5.4 07/16] netfilter: nf_nat_masquerade: defer conntrack walk to work queue
Date:   Thu, 14 Oct 2021 16:54:10 +0200
Message-Id: <20211014145207.557561703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970a19b71044bf4dc2c1becc200275bdf1884d4 ]

The ipv4 and device notifiers are called with RTNL mutex held.
The table walk can take some time, better not block other RTNL users.

'ip a' has been reported to block for up to 20 seconds when conntrack table
has many entries and device down events are frequent (e.g., PPP).

Reported-and-tested-by: Martin Zaharinov <micron10@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_masquerade.c | 50 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 415919a6ac1a..acd73f717a08 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -131,13 +131,14 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 	put_net(net);
 }
 
-static int device_cmp(struct nf_conn *i, void *ifindex)
+static int device_cmp(struct nf_conn *i, void *arg)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
+	const struct masq_dev_work *w = arg;
 
 	if (!nat)
 		return 0;
-	return nat->masq_index == (int)(long)ifindex;
+	return nat->masq_index == w->ifindex;
 }
 
 static int masq_device_event(struct notifier_block *this,
@@ -153,8 +154,8 @@ static int masq_device_event(struct notifier_block *this,
 		 * and forget them.
 		 */
 
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
+		nf_nat_masq_schedule(net, NULL, dev->ifindex,
+				     device_cmp, GFP_KERNEL);
 	}
 
 	return NOTIFY_DONE;
@@ -162,35 +163,45 @@ static int masq_device_event(struct notifier_block *this,
 
 static int inet_cmp(struct nf_conn *ct, void *ptr)
 {
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct net_device *dev = ifa->ifa_dev->dev;
 	struct nf_conntrack_tuple *tuple;
+	struct masq_dev_work *w = ptr;
 
-	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+	if (!device_cmp(ct, ptr))
 		return 0;
 
 	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
-	return ifa->ifa_address == tuple->dst.u3.ip;
+	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct net *net = dev_net(idev->dev);
+	const struct in_ifaddr *ifa = ptr;
+	const struct in_device *idev;
+	const struct net_device *dev;
+	union nf_inet_addr addr;
+
+	if (event != NETDEV_DOWN)
+		return NOTIFY_DONE;
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
 	 * no work to do.  Otherwise this is an individual address removal
 	 * and we have to perform the flush.
 	 */
+	idev = ifa->ifa_dev;
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+	memset(&addr, 0, sizeof(addr));
+
+	addr.ip = ifa->ifa_address;
+
+	dev = idev->dev;
+	nf_nat_masq_schedule(dev_net(idev->dev), &addr, dev->ifindex,
+			     inet_cmp, GFP_KERNEL);
 
 	return NOTIFY_DONE;
 }
@@ -253,19 +264,6 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-static int inet6_cmp(struct nf_conn *ct, void *work)
-{
-	struct masq_dev_work *w = (struct masq_dev_work *)work;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)w->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
-}
-
 /* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
  *
  * Defer it to the system workqueue.
@@ -289,7 +287,7 @@ static int masq_inet6_event(struct notifier_block *this,
 
 	addr.in6 = ifa->addr;
 
-	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet6_cmp,
+	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet_cmp,
 			     GFP_ATOMIC);
 	return NOTIFY_DONE;
 }
-- 
2.33.0



