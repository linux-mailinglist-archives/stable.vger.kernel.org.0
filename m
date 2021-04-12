Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FC235C081
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbhDLJOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240634AbhDLJKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8731160241;
        Mon, 12 Apr 2021 09:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218368;
        bh=V2hcMgmu2Y/ijX7604LZBPS6XB3qLctl9kakacKj+zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAnWVcwTlVTJel6enWiikelqDXMs7h8pRMUI7rvRXbURNUHbcIC6q+Wz4SQ1SvJWh
         tf0gpT6Kp3MRZgZL7Wdj/TRhbOTEjtFD5Kr57OC0k09lRf8Wrx366jsQdAXsOIKI4F
         pmYCrSHIBwwyMJHs05UfvsmAacO2NaDZSxsqrFOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 126/210] can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE
Date:   Mon, 12 Apr 2021 10:40:31 +0200
Message-Id: <20210412084020.204470446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 0e5c37be4a2b..909b9e684e04 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -86,6 +86,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 MODULE_ALIAS("can-proto-2");
 
+#define BCM_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 /*
  * easy access to the first 64 bit of can(fd)_frame payload. cp->data is
  * 64 bit aligned so the offset has to be multiples of 8 which is ensured
@@ -1292,7 +1294,7 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* no bound device as default => check msg_name */
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < BCM_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -1534,7 +1536,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 	struct net *net = sock_net(sk);
 	int ret = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < BCM_MIN_NAMELEN)
 		return -EINVAL;
 
 	lock_sock(sk);
@@ -1616,8 +1618,8 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
-		__sockaddr_check_size(sizeof(struct sockaddr_can));
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(BCM_MIN_NAMELEN);
+		msg->msg_namelen = BCM_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 6ec8aa1d0da4..95113b0898b2 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -60,6 +60,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
 MODULE_ALIAS("can-proto-1");
 
+#define RAW_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 #define MASK_ALL 0
 
 /* A raw socket has a list of can_filters attached to it, each receiving
@@ -394,7 +396,7 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int err = 0;
 	int notify_enetdown = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < RAW_MIN_NAMELEN)
 		return -EINVAL;
 	if (addr->can_family != AF_CAN)
 		return -EINVAL;
@@ -475,11 +477,11 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
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
@@ -731,7 +733,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < RAW_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -824,8 +826,8 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
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



