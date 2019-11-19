Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F87101782
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbfKSFmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbfKSFmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A3AE208C3;
        Tue, 19 Nov 2019 05:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142170;
        bh=Nyd3IFEncmva4CFy6JnvNMxW1suuTboYSQorV7E3X2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIeOiPlwdfWHqW0JvzDXvuPGTVKlvgqKbaMX/ZLmzF3ZutAMMUXMRQbhXpKk5gQlh
         WjN5bzJwR40NnBvSsRdUs1dtSLSRMyQWOj2gsJfYiMwTZr9arwhEU/fMpGbWxOU083
         uB1avqusxFRSy1hIISAy9Ba7RRuHaSUqIXTEeamk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tan Hu <tan.hu@zte.com.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 414/422] netfilter: masquerade: dont flush all conntracks if only one address deleted on device
Date:   Tue, 19 Nov 2019 06:20:11 +0100
Message-Id: <20191119051426.022572123@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tan Hu <tan.hu@zte.com.cn>

[ Upstream commit 097f95d319f817e651bd51f8846aced92a55a6a1 ]

We configured iptables as below, which only allowed incoming data on
established connections:

iptables -t mangle -A PREROUTING -m state --state ESTABLISHED -j ACCEPT
iptables -t mangle -P PREROUTING DROP

When deleting a secondary address, current masquerade implements would
flush all conntracks on this device. All the established connections on
primary address also be deleted, then subsequent incoming data on the
connections would be dropped wrongly because it was identified as NEW
connection.

So when an address was delete, it should only flush connections related
with the address.

Signed-off-by: Tan Hu <tan.hu@zte.com.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 22 ++++++++++++++++++---
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 19 +++++++++++++++---
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index 4c7fcd32f8e62..41327bb990932 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -104,12 +104,26 @@ static int masq_device_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
+static int inet_cmp(struct nf_conn *ct, void *ptr)
+{
+	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
+	struct net_device *dev = ifa->ifa_dev->dev;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ifa->ifa_address == tuple->dst.u3.ip;
+}
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
 	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct netdev_notifier_info info;
+	struct net *net = dev_net(idev->dev);
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
@@ -119,8 +133,10 @@ static int masq_inet_event(struct notifier_block *this,
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	netdev_notifier_info_init(&info, idev->dev);
-	return masq_device_event(this, event, &info);
+	if (event == NETDEV_DOWN)
+		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block masq_dev_notifier = {
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 37b1d413c825b..0ad0da5a26002 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -87,18 +87,30 @@ static struct notifier_block masq_dev_notifier = {
 struct masq_dev_work {
 	struct work_struct work;
 	struct net *net;
+	struct in6_addr addr;
 	int ifindex;
 };
 
+static int inet_cmp(struct nf_conn *ct, void *work)
+{
+	struct masq_dev_work *w = (struct masq_dev_work *)work;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)w->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
+}
+
 static void iterate_cleanup_work(struct work_struct *work)
 {
 	struct masq_dev_work *w;
-	long index;
 
 	w = container_of(work, struct masq_dev_work, work);
 
-	index = w->ifindex;
-	nf_ct_iterate_cleanup_net(w->net, device_cmp, (void *)index, 0, 0);
+	nf_ct_iterate_cleanup_net(w->net, inet_cmp, (void *)w, 0, 0);
 
 	put_net(w->net);
 	kfree(w);
@@ -147,6 +159,7 @@ static int masq_inet6_event(struct notifier_block *this,
 		INIT_WORK(&w->work, iterate_cleanup_work);
 		w->ifindex = dev->ifindex;
 		w->net = net;
+		w->addr = ifa->addr;
 		schedule_work(&w->work);
 
 		return NOTIFY_DONE;
-- 
2.20.1



