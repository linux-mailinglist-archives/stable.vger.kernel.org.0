Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1857F1E2F02
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgEZS4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389759AbgEZS4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E276208B3;
        Tue, 26 May 2020 18:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519373;
        bh=0rmIYhCI32PjklALZqYNsZSL7GFUZ3f9KGHDP0j7TdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufr68fdXnMaBPcl7aht0ZMdPv1Vw2PHl7qcm/7acOKSngWkh52eQ5KsEtpGmnweMJ
         buis1PZGcyT8cdA7/gGt+SVpRqQulYMW1YDPFBsAJWXSdhaSYeQWXI9ZdQJuzsixRE
         b0ekJqRh0IhBVVmN/UxeRsCea4CE3hUM2YXPBahw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 41/65] net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*
Date:   Tue, 26 May 2020 20:53:00 +0200
Message-Id: <20200526183920.096536213@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>

commit fba40c632c6473fa89660e870a6042c0fe733f8c upstream.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   54 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -230,7 +230,7 @@ static void pppol2tp_recv(struct l2tp_se
 
 	if (sk->sk_state & PPPOX_BOUND) {
 		struct pppox_sock *po;
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to ppp\n",
 			 session->name, data_len);
 
@@ -253,7 +253,7 @@ static void pppol2tp_recv(struct l2tp_se
 		po = pppox_sk(sk);
 		ppp_input(&po->chan, skb);
 	} else {
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to L2TP socket\n",
 			 session->name, data_len);
 
@@ -266,7 +266,7 @@ static void pppol2tp_recv(struct l2tp_se
 	return;
 
 no_sock:
-	l2tp_info(session, PPPOL2TP_MSG_DATA, "%s: no socket\n", session->name);
+	l2tp_info(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
 	kfree_skb(skb);
 }
 
@@ -797,7 +797,7 @@ out_no_ppp:
 	/* This is how we get the session context from the socket. */
 	sk->sk_user_data = session;
 	sk->sk_state = PPPOX_CONNECTED;
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
 
 end:
@@ -848,7 +848,7 @@ static int pppol2tp_session_create(struc
 	ps = l2tp_session_priv(session);
 	ps->tunnel_sock = tunnel->sock;
 
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
 
 	error = 0;
@@ -1010,7 +1010,7 @@ static int pppol2tp_session_ioctl(struct
 	struct l2tp_tunnel *tunnel = session->tunnel;
 	struct pppol2tp_ioc_stats stats;
 
-	l2tp_dbg(session, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(session, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_session_ioctl(cmd=%#x, arg=%#lx)\n",
 		 session->name, cmd, arg);
 
@@ -1033,7 +1033,7 @@ static int pppol2tp_session_ioctl(struct
 		if (copy_to_user((void __user *) arg, &ifr, sizeof(struct ifreq)))
 			break;
 
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mtu=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mtu=%d\n",
 			  session->name, session->mtu);
 		err = 0;
 		break;
@@ -1049,7 +1049,7 @@ static int pppol2tp_session_ioctl(struct
 
 		session->mtu = ifr.ifr_mtu;
 
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mtu=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mtu=%d\n",
 			  session->name, session->mtu);
 		err = 0;
 		break;
@@ -1063,7 +1063,7 @@ static int pppol2tp_session_ioctl(struct
 		if (put_user(session->mru, (int __user *) arg))
 			break;
 
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mru=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mru=%d\n",
 			  session->name, session->mru);
 		err = 0;
 		break;
@@ -1078,7 +1078,7 @@ static int pppol2tp_session_ioctl(struct
 			break;
 
 		session->mru = val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mru=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mru=%d\n",
 			  session->name, session->mru);
 		err = 0;
 		break;
@@ -1088,7 +1088,7 @@ static int pppol2tp_session_ioctl(struct
 		if (put_user(ps->flags, (int __user *) arg))
 			break;
 
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get flags=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get flags=%d\n",
 			  session->name, ps->flags);
 		err = 0;
 		break;
@@ -1098,7 +1098,7 @@ static int pppol2tp_session_ioctl(struct
 		if (get_user(val, (int __user *) arg))
 			break;
 		ps->flags = val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set flags=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set flags=%d\n",
 			  session->name, ps->flags);
 		err = 0;
 		break;
@@ -1115,7 +1115,7 @@ static int pppol2tp_session_ioctl(struct
 		if (copy_to_user((void __user *) arg, &stats,
 				 sizeof(stats)))
 			break;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  session->name);
 		err = 0;
 		break;
@@ -1143,7 +1143,7 @@ static int pppol2tp_tunnel_ioctl(struct
 	struct sock *sk;
 	struct pppol2tp_ioc_stats stats;
 
-	l2tp_dbg(tunnel, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(tunnel, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_tunnel_ioctl(cmd=%#x, arg=%#lx)\n",
 		 tunnel->name, cmd, arg);
 
@@ -1186,7 +1186,7 @@ static int pppol2tp_tunnel_ioctl(struct
 			err = -EFAULT;
 			break;
 		}
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  tunnel->name);
 		err = 0;
 		break;
@@ -1276,7 +1276,7 @@ static int pppol2tp_tunnel_setsockopt(st
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		tunnel->debug = val;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: set debug=%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: set debug=%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
 
@@ -1304,7 +1304,7 @@ static int pppol2tp_session_setsockopt(s
 			break;
 		}
 		session->recv_seq = val ? -1 : 0;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set recv_seq=%d\n",
 			  session->name, session->recv_seq);
 		break;
@@ -1322,7 +1322,7 @@ static int pppol2tp_session_setsockopt(s
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
 		l2tp_session_set_header_len(session, session->tunnel->version);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set send_seq=%d\n",
 			  session->name, session->send_seq);
 		break;
@@ -1333,20 +1333,20 @@ static int pppol2tp_session_setsockopt(s
 			break;
 		}
 		session->lns_mode = val ? -1 : 0;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set lns_mode=%d\n",
 			  session->name, session->lns_mode);
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
 		session->debug = val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set debug=%x\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set debug=%x\n",
 			  session->name, session->debug);
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
 		session->reorder_timeout = msecs_to_jiffies(val);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set reorder_timeout=%d\n",
 			  session->name, session->reorder_timeout);
 		break;
@@ -1427,7 +1427,7 @@ static int pppol2tp_tunnel_getsockopt(st
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		*val = tunnel->debug;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get debug=%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get debug=%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
 
@@ -1450,31 +1450,31 @@ static int pppol2tp_session_getsockopt(s
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
 		*val = session->recv_seq;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get recv_seq=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_SENDSEQ:
 		*val = session->send_seq;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get send_seq=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
 		*val = session->lns_mode;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get lns_mode=%d\n", session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
 		*val = session->debug;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get debug=%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get debug=%d\n",
 			  session->name, *val);
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
 		*val = (int) jiffies_to_msecs(session->reorder_timeout);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get reorder_timeout=%d\n", session->name, *val);
 		break;
 


