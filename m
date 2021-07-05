Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9E3BBF81
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhGEPcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232345AbhGEPcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5EE6197D;
        Mon,  5 Jul 2021 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498971;
        bh=qTN4LHwomydgfa8qwuB7OVji1kdxFGW/5aGA1WTDcZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stRKNiF7qNglNn0PGYbQnnflmtmCiRP+AEXfuZta92LJm2unz3t/2tyvGTTIVTrxF
         taPoaGsTBQv19DEXopobHTvrxeZXiqUFIJ14GDjN8PGZ/mSEHhmINpI0IlfGS2Ijal
         1rMQ3DaJfo95FyROeihftpAyjCixMXiUAQQFuD2oiR5yh+/8HUUrv6fWMaLyQGRsJB
         lSBS3/g8f+BjRFSK9UuiFVrFGQoaCF/1JiCYtXojgGa/JOoSEzFDtYc6Cr/kZvM0Tv
         SYGPgSIkCnhk0dJjkccXw8NnmPm8GEoxRM0UHOC+I8sIxqQh2RefwMSD2J198GFKzK
         RsbohrXyjmwQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 14/52] fs: dlm: reconnect if socket error report occurs
Date:   Mon,  5 Jul 2021 11:28:35 -0400
Message-Id: <20210705152913.1521036-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 45c2fdaf34c4..01b672cee783 100644
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
@@ -584,6 +587,22 @@ static void lowcomms_error_report(struct sock *sk)
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
@@ -701,6 +720,8 @@ static void close_connection(struct connection *con, bool and_other,
 	con->rx_leftover = 0;
 	con->retries = 0;
 	clear_bit(CF_CONNECTED, &con->flags);
+	clear_bit(CF_DELAY_CONNECT, &con->flags);
+	clear_bit(CF_RECONNECT, &con->flags);
 	mutex_unlock(&con->sock_mutex);
 	clear_bit(CF_CLOSING, &con->flags);
 }
@@ -839,18 +860,15 @@ static int receive_from_sock(struct connection *con)
 
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
@@ -933,6 +951,7 @@ static int accept_from_sock(struct listen_connection *con)
 			}
 
 			newcon->othercon = othercon;
+			othercon->sendcon = newcon;
 		} else {
 			/* close other sock con if we have something new */
 			close_connection(othercon, false, true, false);
@@ -1478,7 +1497,7 @@ static void send_to_sock(struct connection *con)
 				cond_resched();
 				goto out;
 			} else if (ret < 0)
-				goto send_error;
+				goto out;
 		}
 
 		/* Don't starve people filling buffers */
@@ -1495,14 +1514,6 @@ static void send_to_sock(struct connection *con)
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
@@ -1574,8 +1585,15 @@ static void process_send_sockets(struct work_struct *work)
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

