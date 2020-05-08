Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB991CAF84
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgEHMkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgEHMkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2964F2495C;
        Fri,  8 May 2020 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941635;
        bh=40u871YJ9o8oK080r6+2RBE7QW3VdIIeM4m8daGeq/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZXVryt7xJxXXf3zQDpunUBUIAn3h9qixKUpRfa2hNjc4rEVypALpQWvq+nL/vSdn
         6cgK2ygk8sl6bJ/pVsKJlF7dJeIq1SpL7Zo1Bkzxu7VJSxlF5IumZhoEJZSQFFa+la
         0EjTGoJepa4SNXOnXJZPyiej3OfSRXxJ/cr86t4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 112/312] RDS:TCP: Synchronize rds_tcp_accept_one with rds_send_xmit when resetting t_sock
Date:   Fri,  8 May 2020 14:31:43 +0200
Message-Id: <20200508123132.361006801@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowmini Varadhan <sowmini.varadhan@oracle.com>

commit eb192840266fab3e3da644018121eed30153355d upstream.

There is a race condition between rds_send_xmit -> rds_tcp_xmit
and the code that deals with resolution of duelling syns added
by commit 241b271952eb ("RDS-TCP: Reset tcp callbacks if re-using an
outgoing socket in rds_tcp_accept_one()").

Specifically, we may end up derefencing a null pointer in rds_send_xmit
if we have the interleaving sequence:
           rds_tcp_accept_one                  rds_send_xmit

                                             conn is RDS_CONN_UP, so
    					 invoke rds_tcp_xmit

                                             tc = conn->c_transport_data
        rds_tcp_restore_callbacks
            /* reset t_sock */
    					 null ptr deref from tc->t_sock

The race condition can be avoided without adding the overhead of
additional locking in the xmit path: have rds_tcp_accept_one wait
for rds_tcp_xmit threads to complete before resetting callbacks.
The synchronization can be done in the same manner as rds_conn_shutdown().
First set the rds_conn_state to something other than RDS_CONN_UP
(so that new threads cannot get into rds_tcp_xmit()), then wait for
RDS_IN_XMIT to be cleared in the conn->c_flags indicating that any
threads in rds_tcp_xmit are done.

Fixes: 241b271952eb ("RDS-TCP: Reset tcp callbacks if re-using an
outgoing socket in rds_tcp_accept_one()")
Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rds/tcp.c        |    2 +-
 net/rds/tcp_listen.c |   38 +++++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 16 deletions(-)

--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -110,7 +110,7 @@ void rds_tcp_restore_callbacks(struct so
 
 /*
  * This is the only path that sets tc->t_sock.  Send and receive trust that
- * it is set.  The RDS_CONN_CONNECTED bit protects those paths from being
+ * it is set.  The RDS_CONN_UP bit protects those paths from being
  * called while it isn't set.
  */
 void rds_tcp_set_callbacks(struct socket *sock, struct rds_connection *conn)
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -115,24 +115,32 @@ int rds_tcp_accept_one(struct socket *so
 	 * rds_tcp_state_change() will do that cleanup
 	 */
 	rs_tcp = (struct rds_tcp_connection *)conn->c_transport_data;
-	if (rs_tcp->t_sock &&
-	    ntohl(inet->inet_saddr) < ntohl(inet->inet_daddr)) {
-		struct sock *nsk = new_sock->sk;
+	rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING);
+	if (rs_tcp->t_sock) {
+		/* Need to resolve a duelling SYN between peers.
+		 * We have an outstanding SYN to this peer, which may
+		 * potentially have transitioned to the RDS_CONN_UP state,
+		 * so we must quiesce any send threads before resetting
+		 * c_transport_data.
+		 */
+		wait_event(conn->c_waitq,
+			   !test_bit(RDS_IN_XMIT, &conn->c_flags));
+		if (ntohl(inet->inet_saddr) < ntohl(inet->inet_daddr)) {
+			struct sock *nsk = new_sock->sk;
 
-		nsk->sk_user_data = NULL;
-		nsk->sk_prot->disconnect(nsk, 0);
-		tcp_done(nsk);
-		new_sock = NULL;
-		ret = 0;
-		goto out;
-	} else if (rs_tcp->t_sock) {
-		rds_tcp_restore_callbacks(rs_tcp->t_sock, rs_tcp);
-		conn->c_outgoing = 0;
+			nsk->sk_user_data = NULL;
+			nsk->sk_prot->disconnect(nsk, 0);
+			tcp_done(nsk);
+			new_sock = NULL;
+			ret = 0;
+			goto out;
+		} else if (rs_tcp->t_sock) {
+			rds_tcp_restore_callbacks(rs_tcp->t_sock, rs_tcp);
+			conn->c_outgoing = 0;
+		}
 	}
-
-	rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING);
 	rds_tcp_set_callbacks(new_sock, conn);
-	rds_connect_complete(conn);
+	rds_connect_complete(conn); /* marks RDS_CONN_UP */
 	new_sock = NULL;
 	ret = 0;
 


