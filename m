Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0E3BBF0F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhGEPbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231952AbhGEPbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B75761968;
        Mon,  5 Jul 2021 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498920;
        bh=ZvUI8YraDjOeTxrtgKkUEaZ4W8o8n5LPF7JU3C9q2ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hO4Kqva1MLLLM3TNXrY4UJRmF9T21rmf6IZMJoQt/JyvR9ttwVW9uD2VogsKnq/2Y
         Nve0qHc9vWp7usc3eVPsMigzBMR2YurDkITww/qFHei23UsE6ylOMcyHeHa8snQht5
         3Acu+mwkQozuxe7tWOWCCsP4fDE/4RkrHqabYkjoBoP2Jzhpkb/kZ1OyIQNaoC+/nY
         y4EiCMKWhzADZ8f1qcHG6Pu4vDS735/jt8dPRVSHh9lQans91N5pAqtKnKVaJGB1f8
         FaCwCtcZUFn/K2/zicwF3GkPg8Ug43hkvQtgRSvsGTzeJQorlkbYxB5pmOGzHTXCnj
         WeIIi8MNOtmsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 18/59] fs: dlm: fix connection tcp EOF handling
Date:   Mon,  5 Jul 2021 11:27:34 -0400
Message-Id: <20210705152815.1520546-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 8aa31cbf20ad168c35dd83476629402aacbf5a44 ]

This patch fixes the EOF handling for TCP that if and EOF is received we
will close the socket next time the writequeue runs empty. This is a
half-closed socket functionality which doesn't exists in SCTP. The
midcomms layer will do a half closed socket functionality on DLM side to
solve this problem for the SCTP case. However there is still the last ack
flying around but other reset functionality will take care of it if it got
lost.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 48 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 138e8236ff6e..b1dd850a4699 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -81,10 +81,13 @@ struct connection {
 #define CF_CONNECTED 10
 #define CF_RECONNECT 11
 #define CF_DELAY_CONNECT 12
+#define CF_EOF 13
 	struct list_head writequeue;  /* List of outgoing writequeue_entries */
 	spinlock_t writequeue_lock;
+	atomic_t writequeue_cnt;
 	void (*connect_action) (struct connection *);	/* What to do to connect */
 	void (*shutdown_action)(struct connection *con); /* What to do to shutdown */
+	bool (*eof_condition)(struct connection *con); /* What to do to eof check */
 	int retries;
 #define MAX_CONNECT_RETRIES 3
 	struct hlist_node list;
@@ -179,6 +182,11 @@ static struct connection *__find_con(int nodeid, int r)
 	return NULL;
 }
 
+static bool tcp_eof_condition(struct connection *con)
+{
+	return atomic_read(&con->writequeue_cnt);
+}
+
 static int dlm_con_init(struct connection *con, int nodeid)
 {
 	con->rx_buflen = dlm_config.ci_buffer_size;
@@ -190,6 +198,7 @@ static int dlm_con_init(struct connection *con, int nodeid)
 	mutex_init(&con->sock_mutex);
 	INIT_LIST_HEAD(&con->writequeue);
 	spin_lock_init(&con->writequeue_lock);
+	atomic_set(&con->writequeue_cnt, 0);
 	INIT_WORK(&con->swork, process_send_sockets);
 	INIT_WORK(&con->rwork, process_recv_sockets);
 	init_waitqueue_head(&con->shutdown_wait);
@@ -197,6 +206,7 @@ static int dlm_con_init(struct connection *con, int nodeid)
 	if (dlm_config.ci_protocol == 0) {
 		con->connect_action = tcp_connect_to_sock;
 		con->shutdown_action = dlm_tcp_shutdown;
+		con->eof_condition = tcp_eof_condition;
 	} else {
 		con->connect_action = sctp_connect_to_sock;
 	}
@@ -723,6 +733,7 @@ static void close_connection(struct connection *con, bool and_other,
 	clear_bit(CF_CONNECTED, &con->flags);
 	clear_bit(CF_DELAY_CONNECT, &con->flags);
 	clear_bit(CF_RECONNECT, &con->flags);
+	clear_bit(CF_EOF, &con->flags);
 	mutex_unlock(&con->sock_mutex);
 	clear_bit(CF_CLOSING, &con->flags);
 }
@@ -860,16 +871,26 @@ static int receive_from_sock(struct connection *con)
 	return -EAGAIN;
 
 out_close:
-	mutex_unlock(&con->sock_mutex);
 	if (ret == 0) {
-		close_connection(con, false, true, false);
 		log_print("connection %p got EOF from %d",
 			  con, con->nodeid);
-		/* handling for tcp shutdown */
-		clear_bit(CF_SHUTDOWN, &con->flags);
-		wake_up(&con->shutdown_wait);
+
+		if (con->eof_condition && con->eof_condition(con)) {
+			set_bit(CF_EOF, &con->flags);
+			mutex_unlock(&con->sock_mutex);
+		} else {
+			mutex_unlock(&con->sock_mutex);
+			close_connection(con, false, true, false);
+
+			/* handling for tcp shutdown */
+			clear_bit(CF_SHUTDOWN, &con->flags);
+			wake_up(&con->shutdown_wait);
+		}
+
 		/* signal to breaking receive worker */
 		ret = -1;
+	} else {
+		mutex_unlock(&con->sock_mutex);
 	}
 	return ret;
 }
@@ -1020,6 +1041,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 
 	if (e->len == 0 && e->users == 0) {
 		list_del(&e->list);
+		atomic_dec(&e->con->writequeue_cnt);
 		free_entry(e);
 	}
 }
@@ -1416,6 +1438,7 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 
 	*ppc = page_address(e->page);
 	e->end += len;
+	atomic_inc(&con->writequeue_cnt);
 
 	spin_lock(&con->writequeue_lock);
 	list_add_tail(&e->list, &con->writequeue);
@@ -1535,6 +1558,21 @@ static void send_to_sock(struct connection *con)
 		writequeue_entry_complete(e, ret);
 	}
 	spin_unlock(&con->writequeue_lock);
+
+	/* close if we got EOF */
+	if (test_and_clear_bit(CF_EOF, &con->flags)) {
+		mutex_unlock(&con->sock_mutex);
+		close_connection(con, false, false, true);
+
+		/* handling for tcp shutdown */
+		clear_bit(CF_SHUTDOWN, &con->flags);
+		wake_up(&con->shutdown_wait);
+	} else {
+		mutex_unlock(&con->sock_mutex);
+	}
+
+	return;
+
 out:
 	mutex_unlock(&con->sock_mutex);
 	return;
-- 
2.30.2

