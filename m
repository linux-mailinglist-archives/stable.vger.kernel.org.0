Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6C35C05D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhDLJND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239073AbhDLJJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA9416127C;
        Mon, 12 Apr 2021 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218269;
        bh=VgZj1g8p1J86/7y/ptqcYnufa5MabCMQ905fL1HsYGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPOJB4srOlJzXRXEte67IcoYhRkySAI8XqpOItYYBnkusGQdSDJHL1QdXjMjal33l
         hTNjwGQxoY5AmYx6hUGo+lcx2mkb43TdLbEhf5O9p5TVQoUt3awOLbU/qeSRxjRj3X
         7DM3RttxehOj49F3/7qq8wXM5vcM3oUQh7YVKNos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 127/210] can: isotp: fix msg_namelen values depending on CAN_REQUIRED_SIZE
Date:   Mon, 12 Apr 2021 10:40:32 +0200
Message-Id: <20210412084020.243493034@linuxfoundation.org>
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

[ Upstream commit f522d9559b07854c231cf8f0b8cb5a3578f8b44e ]

Since commit f5223e9eee65 ("can: extend sockaddr_can to include j1939
members") the sockaddr_can has been extended in size and a new
CAN_REQUIRED_SIZE macro has been introduced to calculate the protocol
specific needed size.

The ABI for the msg_name and msg_namelen has not been adapted to the
new CAN_REQUIRED_SIZE macro for the other CAN protocols which leads to
a problem when an existing binary reads the (increased) struct
sockaddr_can in msg_name.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Reported-by: Richard Weinberger <richard@nod.at>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Link: https://lore.kernel.org/linux-can/1135648123.112255.1616613706554.JavaMail.zimbra@nod.at/T/#t
Link: https://lore.kernel.org/r/20210325125850.1620-2-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 15ea1234d457..9f94ad3caee9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -77,6 +77,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 MODULE_ALIAS("can-proto-6");
 
+#define ISOTP_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_addr.tp)
+
 #define SINGLE_MASK(id) (((id) & CAN_EFF_FLAG) ? \
 			 (CAN_EFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG) : \
 			 (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
@@ -986,7 +988,8 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_timestamp(msg, sk, skb);
 
 	if (msg->msg_name) {
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(ISOTP_MIN_NAMELEN);
+		msg->msg_namelen = ISOTP_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
@@ -1056,7 +1059,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int notify_enetdown = 0;
 	int do_rx_reg = 1;
 
-	if (len < CAN_REQUIRED_SIZE(struct sockaddr_can, can_addr.tp))
+	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
 	/* do not register frame reception for functional addressing */
@@ -1152,13 +1155,13 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	if (peer)
 		return -EOPNOTSUPP;
 
-	memset(addr, 0, sizeof(*addr));
+	memset(addr, 0, ISOTP_MIN_NAMELEN);
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = so->ifindex;
 	addr->can_addr.tp.rx_id = so->rxid;
 	addr->can_addr.tp.tx_id = so->txid;
 
-	return sizeof(*addr);
+	return ISOTP_MIN_NAMELEN;
 }
 
 static int isotp_setsockopt(struct socket *sock, int level, int optname,
-- 
2.30.2



