Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FD13C51D6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbhGLHnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347983AbhGLHk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEC7B6112D;
        Mon, 12 Jul 2021 07:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075445;
        bh=hHnCkBARJjp/XP9erYy7rb5z9f2lqn5d854iN7YpWIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBf3aRJ2pyLaa4h6cxhBu/LahFgM3afpXUXidZyZ2PB4PhHMnIRC27UCCp2ctvDiu
         Y0RRR2CT4I5h1X4EQjff6XGN7yxWgjxkett77D70EQ4J52teJw99m6/y0aNOH6kMsx
         NSj1jO9L0YeQv0meoD/OAKt/Hc+o4kB7y1a2pFgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 223/800] fs: dlm: reconnect if socket error report occurs
Date:   Mon, 12 Jul 2021 08:04:06 +0200
Message-Id: <20210712060945.244033371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit ba868d9deaab2bb1c09e50650127823925154802 ]

This patch will change the reconnect handling that if an error occurs
if a socket error callback is occurred. This will also handle reconnects
in a non blocking connecting case which is currently missing. If error
ECONNREFUSED is reported we delay the reconnect by one second.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 60 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 47bf99373f3e..cdc50e9a5ab0 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -79,6 +79,8 @@ struct connection {
 #define CF_CLOSING 8
 #define CF_SHUTDOWN 9
 #define CF_CONNECTED 10
+#define CF_RECONNECT 11
+#define CF_DELAY_CONNECT 12
 	struct list_head writequeue;  /* List of outgoing writequeue_entries */
 	spinlock_t writequeue_lock;
 	void (*connect_action) (struct connection *);	/* What to do to connect */
@@ -87,6 +89,7 @@ struct connection {
 #define MAX_CONNECT_RETRIES 3
 	struct hlist_node list;
 	struct connection *othercon;
+	struct connection *sendcon;
 	struct work_struct rwork; /* Receive workqueue */
 	struct work_struct swork; /* Send workqueue */
 	wait_queue_head_t shutdown_wait; /* wait for graceful shutdown */
@@ -585,6 +588,22 @@ static void lowcomms_error_report(struct sock *sk)
 				   dlm_config.ci_tcp_port, sk->sk_err,
 				   sk->sk_err_soft);
 	}
+
+	/* below sendcon only handling */
+	if (test_bit(CF_IS_OTHERCON, &con->flags))
+		con = con->sendcon;
+
+	switch (sk->sk_err) {
+	case ECONNREFUSED:
+		set_bit(CF_DELAY_CONNECT, &con->flags);
+		break;
+	default:
+		break;
+	}
+
+	if (!test_and_set_bit(CF_RECONNECT, &con->flags))
+		queue_work(send_workqueue, &con->swork);
+
 out:
 	read_unlock_bh(&sk->sk_callback_lock);
 	if (orig_report)
@@ -702,6 +721,8 @@ static void close_connection(struct connection *con, bool and_other,
 	con->rx_leftover = 0;
 	con->retries = 0;
 	clear_bit(CF_CONNECTED, &con->flags);
+	clear_bit(CF_DELAY_CONNECT, &con->flags);
+	clear_bit(CF_RECONNECT, &con->flags);
 	mutex_unlock(&con->sock_mutex);
 	clear_bit(CF_CLOSING, &con->flags);
 }
@@ -840,18 +861,15 @@ out_resched:
 
 out_close:
 	mutex_unlock(&con->sock_mutex);
-	if (ret != -EAGAIN) {
-		/* Reconnect when there is something to send */
+	if (ret == 0) {
 		close_connection(con, false, true, false);
-		if (ret == 0) {
-			log_print("connection %p got EOF from %d",
-				  con, con->nodeid);
-			/* handling for tcp shutdown */
-			clear_bit(CF_SHUTDOWN, &con->flags);
-			wake_up(&con->shutdown_wait);
-			/* signal to breaking receive worker */
-			ret = -1;
-		}
+		log_print("connection %p got EOF from %d",
+			  con, con->nodeid);
+		/* handling for tcp shutdown */
+		clear_bit(CF_SHUTDOWN, &con->flags);
+		wake_up(&con->shutdown_wait);
+		/* signal to breaking receive worker */
+		ret = -1;
 	}
 	return ret;
 }
@@ -939,6 +957,7 @@ static int accept_from_sock(struct listen_connection *con)
 
 			lockdep_set_subclass(&othercon->sock_mutex, 1);
 			newcon->othercon = othercon;
+			othercon->sendcon = newcon;
 		} else {
 			/* close other sock con if we have something new */
 			close_connection(othercon, false, true, false);
@@ -1503,7 +1522,7 @@ static void send_to_sock(struct connection *con)
 				cond_resched();
 				goto out;
 			} else if (ret < 0)
-				goto send_error;
+				goto out;
 		}
 
 		/* Don't starve people filling buffers */
@@ -1520,14 +1539,6 @@ out:
 	mutex_unlock(&con->sock_mutex);
 	return;
 
-send_error:
-	mutex_unlock(&con->sock_mutex);
-	close_connection(con, false, false, true);
-	/* Requeue the send work. When the work daemon runs again, it will try
-	   a new connection, then call this function again. */
-	queue_work(send_workqueue, &con->swork);
-	return;
-
 out_connect:
 	mutex_unlock(&con->sock_mutex);
 	queue_work(send_workqueue, &con->swork);
@@ -1602,8 +1613,15 @@ static void process_send_sockets(struct work_struct *work)
 	struct connection *con = container_of(work, struct connection, swork);
 
 	clear_bit(CF_WRITE_PENDING, &con->flags);
-	if (con->sock == NULL) /* not mutex protected so check it inside too */
+
+	if (test_and_clear_bit(CF_RECONNECT, &con->flags))
+		close_connection(con, false, false, true);
+
+	if (con->sock == NULL) { /* not mutex protected so check it inside too */
+		if (test_and_clear_bit(CF_DELAY_CONNECT, &con->flags))
+			msleep(1000);
 		con->connect_action(con);
+	}
 	if (!list_empty(&con->writequeue))
 		send_to_sock(con);
 }
-- 
2.30.2



