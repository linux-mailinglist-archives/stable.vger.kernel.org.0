Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5216639611C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhEaOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhEaOdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD43361C3E;
        Mon, 31 May 2021 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469016;
        bh=5wWAXwDd1+8lNt75Apd3en7MY6KsLBnr9VlAI1gWSdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybTIFwuLjd6Vl6bhhyiNTIr8c/y97IelknsDkpkWj5cfXHj0wcrIMYKAHoCmWWafT
         malohKgCDZup6/c99+fFyw6zA3Az1m81XIePvZxv2hgCMmezE2kLH1VdQAsEHhvhpg
         gr4GJahGXWE6YmHm7OiA7QcUXtdCSa+8g6EdfGuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.12 020/296] can: isotp: prevent race between isotp_bind() and isotp_setsockopt()
Date:   Mon, 31 May 2021 15:11:15 +0200
Message-Id: <20210531130704.442908261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

commit 2b17c400aeb44daf041627722581ade527bb3c1d upstream.

A race condition was found in isotp_setsockopt() which allows to
change socket options after the socket was bound.
For the specific case of SF_BROADCAST support, this might lead to possible
use-after-free because can_rx_unregister() is not called.

Checking for the flag under the socket lock in isotp_bind() and taking
the lock in isotp_setsockopt() fixes the issue.

Fixes: 921ca574cd38 ("can: isotp: add SF_BROADCAST support for functional addressing")
Link: https://lore.kernel.org/r/trinity-e6ae9efa-9afb-4326-84c0-f3609b9b8168-1620773528307@3c-app-gmx-bs06
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1062,27 +1062,31 @@ static int isotp_bind(struct socket *soc
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
+		return -EADDRNOTAVAIL;
+
+	if (!addr->can_ifindex)
+		return -ENODEV;
+
+	lock_sock(sk);
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
 
 	/* do not validate rx address for functional addressing */
 	if (do_rx_reg) {
-		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id)
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
 
-		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
 	}
 
-	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-		return -EADDRNOTAVAIL;
-
-	if (!addr->can_ifindex)
-		return -ENODEV;
-
-	lock_sock(sk);
-
 	if (so->bound && addr->can_ifindex == so->ifindex &&
 	    addr->can_addr.tp.rx_id == so->rxid &&
 	    addr->can_addr.tp.tx_id == so->txid)
@@ -1164,16 +1168,13 @@ static int isotp_getname(struct socket *
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt(struct socket *sock, int level, int optname,
+static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	int ret = 0;
 
-	if (level != SOL_CAN_ISOTP)
-		return -EINVAL;
-
 	if (so->bound)
 		return -EISCONN;
 
@@ -1248,6 +1249,22 @@ static int isotp_setsockopt(struct socke
 	return ret;
 }
 
+static int isotp_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	if (level != SOL_CAN_ISOTP)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret = isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {


