Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6871A5091
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgDKMTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgDKMTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568F620673;
        Sat, 11 Apr 2020 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607553;
        bh=N4EpxYEdzS6ZWH4QRjZmwxJ6IXMTRZp6CLlI2Jc6Mp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfBcDZk7nDPBV28aWk98nC4LF4tYxVroLhyDUc8YK/eVSunI+QA/6AellJecBQQRy
         /uR4VFyQRxlkviZoRVl7a8t6ZnS3ZUWyXN3qTJ7b1NSx1zKUio3Rb6XIUUqi4LnYFE
         xu8LH3Qms5rG8QCNUmiS9DBCxVowS4H/1u1SBDxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 25/44] RDMA/siw: Fix passive connection establishment
Date:   Sat, 11 Apr 2020 14:09:45 +0200
Message-Id: <20200411115459.307620096@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

commit 33fb27fd54465c74cbffba6315b2f043e90cec4c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/siw/siw_cm.c |  137 ++++++++-----------------------------
 1 file changed, 31 insertions(+), 106 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1769,14 +1769,23 @@ int siw_reject(struct iw_cm_id *id, cons
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
@@ -1791,9 +1800,25 @@ static int siw_listen_address(struct iw_
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
@@ -1852,7 +1877,7 @@ static int siw_listen_address(struct iw_
 	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
 	cep->state = SIW_EPSTATE_LISTENING;
 
-	siw_dbg(id->device, "Listen at laddr %pISp\n", laddr);
+	siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
 
 	return 0;
 
@@ -1910,106 +1935,6 @@ static void siw_drop_listeners(struct iw
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


