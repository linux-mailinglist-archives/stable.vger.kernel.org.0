Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B684D1A5ABD
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgDKXFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgDKXFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28B4F20708;
        Sat, 11 Apr 2020 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646346;
        bh=tiG4R9B0XK469qNjh5qexrTHfyt8hJ7k2PoELGRgtgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFRzsD59bDUAR2iefkXxHNDkbpMZ/8yQSLkAKaEfdFdgAFTxsHsvOuI52NkwRfUDz
         5QqCFICq03BHV/NcJjEciuVEYNub34r5GQuMNJ/NP2BmFwy4W9E1csR4aeJ8NJMrD0
         J1joiYKWl+GWLvLAOZTdRFOItj78ToCpcFmfWxGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Metzler <bmt@zurich.ibm.com>,
        syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 094/149] RDMA/siw: Fix passive connection establishment
Date:   Sat, 11 Apr 2020 19:02:51 -0400
Message-Id: <20200411230347.22371-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 33fb27fd54465c74cbffba6315b2f043e90cec4c ]

Holding the rtnl_lock while iterating a devices interface address list
potentially causes deadlocks with the cma_netdev_callback. While this was
implemented to limit the scope of a wildcard listen to addresses of the
current device only, a better solution limits the scope of the socket to
the device. This completely avoiding locking, and also results in
significant code simplification.

Fixes: c421651fa229 ("RDMA/siw: Add missing rtnl_lock around access to ifa")
Link: https://lore.kernel.org/r/20200228173534.26815-1-bmt@zurich.ibm.com
Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 137 +++++++----------------------
 1 file changed, 31 insertions(+), 106 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index c5651a96b1964..559e5fd3bad8b 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1769,14 +1769,23 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 	return 0;
 }
 
-static int siw_listen_address(struct iw_cm_id *id, int backlog,
-			      struct sockaddr *laddr, int addr_family)
+/*
+ * siw_create_listen - Create resources for a listener's IWCM ID @id
+ *
+ * Starts listen on the socket address id->local_addr.
+ *
+ */
+int siw_create_listen(struct iw_cm_id *id, int backlog)
 {
 	struct socket *s;
 	struct siw_cep *cep = NULL;
 	struct siw_device *sdev = to_siw_dev(id->device);
+	int addr_family = id->local_addr.ss_family;
 	int rv = 0, s_val;
 
+	if (addr_family != AF_INET && addr_family != AF_INET6)
+		return -EAFNOSUPPORT;
+
 	rv = sock_create(addr_family, SOCK_STREAM, IPPROTO_TCP, &s);
 	if (rv < 0)
 		return rv;
@@ -1791,9 +1800,25 @@ static int siw_listen_address(struct iw_cm_id *id, int backlog,
 		siw_dbg(id->device, "setsockopt error: %d\n", rv);
 		goto error;
 	}
-	rv = s->ops->bind(s, laddr, addr_family == AF_INET ?
-				    sizeof(struct sockaddr_in) :
-				    sizeof(struct sockaddr_in6));
+	if (addr_family == AF_INET) {
+		struct sockaddr_in *laddr = &to_sockaddr_in(id->local_addr);
+
+		/* For wildcard addr, limit binding to current device only */
+		if (ipv4_is_zeronet(laddr->sin_addr.s_addr))
+			s->sk->sk_bound_dev_if = sdev->netdev->ifindex;
+
+		rv = s->ops->bind(s, (struct sockaddr *)laddr,
+				  sizeof(struct sockaddr_in));
+	} else {
+		struct sockaddr_in6 *laddr = &to_sockaddr_in6(id->local_addr);
+
+		/* For wildcard addr, limit binding to current device only */
+		if (ipv6_addr_any(&laddr->sin6_addr))
+			s->sk->sk_bound_dev_if = sdev->netdev->ifindex;
+
+		rv = s->ops->bind(s, (struct sockaddr *)laddr,
+				  sizeof(struct sockaddr_in6));
+	}
 	if (rv) {
 		siw_dbg(id->device, "socket bind error: %d\n", rv);
 		goto error;
@@ -1852,7 +1877,7 @@ static int siw_listen_address(struct iw_cm_id *id, int backlog,
 	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
 	cep->state = SIW_EPSTATE_LISTENING;
 
-	siw_dbg(id->device, "Listen at laddr %pISp\n", laddr);
+	siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
 
 	return 0;
 
@@ -1910,106 +1935,6 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 	}
 }
 
-/*
- * siw_create_listen - Create resources for a listener's IWCM ID @id
- *
- * Listens on the socket address id->local_addr.
- *
- * If the listener's @id provides a specific local IP address, at most one
- * listening socket is created and associated with @id.
- *
- * If the listener's @id provides the wildcard (zero) local IP address,
- * a separate listen is performed for each local IP address of the device
- * by creating a listening socket and binding to that local IP address.
- *
- */
-int siw_create_listen(struct iw_cm_id *id, int backlog)
-{
-	struct net_device *dev = to_siw_dev(id->device)->netdev;
-	int rv = 0, listeners = 0;
-
-	siw_dbg(id->device, "backlog %d\n", backlog);
-
-	/*
-	 * For each attached address of the interface, create a
-	 * listening socket, if id->local_addr is the wildcard
-	 * IP address or matches the IP address.
-	 */
-	if (id->local_addr.ss_family == AF_INET) {
-		struct in_device *in_dev = in_dev_get(dev);
-		struct sockaddr_in s_laddr;
-		const struct in_ifaddr *ifa;
-
-		if (!in_dev) {
-			rv = -ENODEV;
-			goto out;
-		}
-		memcpy(&s_laddr, &id->local_addr, sizeof(s_laddr));
-
-		siw_dbg(id->device, "laddr %pISp\n", &s_laddr);
-
-		rtnl_lock();
-		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
-			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
-			    s_laddr.sin_addr.s_addr == ifa->ifa_address) {
-				s_laddr.sin_addr.s_addr = ifa->ifa_address;
-
-				rv = siw_listen_address(id, backlog,
-						(struct sockaddr *)&s_laddr,
-						AF_INET);
-				if (!rv)
-					listeners++;
-			}
-		}
-		rtnl_unlock();
-		in_dev_put(in_dev);
-	} else if (id->local_addr.ss_family == AF_INET6) {
-		struct inet6_dev *in6_dev = in6_dev_get(dev);
-		struct inet6_ifaddr *ifp;
-		struct sockaddr_in6 *s_laddr = &to_sockaddr_in6(id->local_addr);
-
-		if (!in6_dev) {
-			rv = -ENODEV;
-			goto out;
-		}
-		siw_dbg(id->device, "laddr %pISp\n", &s_laddr);
-
-		rtnl_lock();
-		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
-			if (ifp->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
-				continue;
-			if (ipv6_addr_any(&s_laddr->sin6_addr) ||
-			    ipv6_addr_equal(&s_laddr->sin6_addr, &ifp->addr)) {
-				struct sockaddr_in6 bind_addr  = {
-					.sin6_family = AF_INET6,
-					.sin6_port = s_laddr->sin6_port,
-					.sin6_flowinfo = 0,
-					.sin6_addr = ifp->addr,
-					.sin6_scope_id = dev->ifindex };
-
-				rv = siw_listen_address(id, backlog,
-						(struct sockaddr *)&bind_addr,
-						AF_INET6);
-				if (!rv)
-					listeners++;
-			}
-		}
-		rtnl_unlock();
-		in6_dev_put(in6_dev);
-	} else {
-		rv = -EAFNOSUPPORT;
-	}
-out:
-	if (listeners)
-		rv = 0;
-	else if (!rv)
-		rv = -EINVAL;
-
-	siw_dbg(id->device, "%s\n", rv ? "FAIL" : "OK");
-
-	return rv;
-}
-
 int siw_destroy_listen(struct iw_cm_id *id)
 {
 	if (!id->provider_data) {
-- 
2.20.1

