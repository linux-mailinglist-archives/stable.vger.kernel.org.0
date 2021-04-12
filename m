Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D635BD5C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhDLIvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238103AbhDLIsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F3E661277;
        Mon, 12 Apr 2021 08:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217249;
        bh=/Ij+4ZHgc47K8850hT13ZEgzS/NLhy8UK5GR1Y3im34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SasijkZOd/fIH+oCzvPLRlZPMyiFhf0udATnW2PzLlndtjA/MDeOYz688NJ36UtYi
         4w/QNhn2poWfWNC5DU1ecQuU0bv+XgPfbOROQN0a6VZ6obAW8cjQ49mPFBfCs/QGDa
         vN9ZiyYSmQdYgj13oPr83m6u0yxrtIIf48u9+axc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/111] can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE
Date:   Mon, 12 Apr 2021 10:40:38 +0200
Message-Id: <20210412084006.266418954@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 9e9714742fb70467464359693a73b911a630226f ]

Since commit f5223e9eee65 ("can: extend sockaddr_can to include j1939
members") the sockaddr_can has been extended in size and a new
CAN_REQUIRED_SIZE macro has been introduced to calculate the protocol
specific needed size.

The ABI for the msg_name and msg_namelen has not been adapted to the
new CAN_REQUIRED_SIZE macro for the other CAN protocols which leads to
a problem when an existing binary reads the (increased) struct
sockaddr_can in msg_name.

Fixes: f5223e9eee65 ("can: extend sockaddr_can to include j1939 members")
Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Link: https://lore.kernel.org/linux-can/1135648123.112255.1616613706554.JavaMail.zimbra@nod.at/T/#t
Link: https://lore.kernel.org/r/20210325125850.1620-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 10 ++++++----
 net/can/raw.c | 14 ++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index c96fa0f33db3..d3aac6a2479b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -88,6 +88,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 MODULE_ALIAS("can-proto-2");
 
+#define BCM_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 /*
  * easy access to the first 64 bit of can(fd)_frame payload. cp->data is
  * 64 bit aligned so the offset has to be multiples of 8 which is ensured
@@ -1294,7 +1296,7 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* no bound device as default => check msg_name */
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < BCM_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -1536,7 +1538,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 	struct net *net = sock_net(sk);
 	int ret = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < BCM_MIN_NAMELEN)
 		return -EINVAL;
 
 	lock_sock(sk);
@@ -1618,8 +1620,8 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
-		__sockaddr_check_size(sizeof(struct sockaddr_can));
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(BCM_MIN_NAMELEN);
+		msg->msg_namelen = BCM_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 59c039d73c6d..af513d0957c7 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -62,6 +62,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
 MODULE_ALIAS("can-proto-1");
 
+#define RAW_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 #define MASK_ALL 0
 
 /* A raw socket has a list of can_filters attached to it, each receiving
@@ -396,7 +398,7 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int err = 0;
 	int notify_enetdown = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < RAW_MIN_NAMELEN)
 		return -EINVAL;
 	if (addr->can_family != AF_CAN)
 		return -EINVAL;
@@ -477,11 +479,11 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
 	if (peer)
 		return -EOPNOTSUPP;
 
-	memset(addr, 0, sizeof(*addr));
+	memset(addr, 0, RAW_MIN_NAMELEN);
 	addr->can_family  = AF_CAN;
 	addr->can_ifindex = ro->ifindex;
 
-	return sizeof(*addr);
+	return RAW_MIN_NAMELEN;
 }
 
 static int raw_setsockopt(struct socket *sock, int level, int optname,
@@ -733,7 +735,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < RAW_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -822,8 +824,8 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
-		__sockaddr_check_size(sizeof(struct sockaddr_can));
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(RAW_MIN_NAMELEN);
+		msg->msg_namelen = RAW_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
-- 
2.30.2



