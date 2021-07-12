Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D273C51D7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344307AbhGLHns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347993AbhGLHka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5B1610D1;
        Mon, 12 Jul 2021 07:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075442;
        bh=Ymu45t7TlxQJ8y8eCssQE2+SEyMCOeYfIk1UuvOaeLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMtO4zaf5vb4Fw+YfX0U/YW/5QOlEqlV0puwj5ac6JKOFeOlUFJEwbVDExXakr+Ws
         K9lce51AiSEpc8FLOhYtqPL7FI+QwyhcbwOcm5eXbvSVQYg2nelBE1sddX5OVMAhl3
         UrpdRr71hwLONLklORIjNmf7XQV2gFJzuRJzKVkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 222/800] fs: dlm: fix srcu read lock usage
Date:   Mon, 12 Jul 2021 08:04:05 +0200
Message-Id: <20210712060945.115912921@linuxfoundation.org>
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

[ Upstream commit b38bc9c2b3171f4411d80015ecb876bc6f9bcd26 ]

This patch holds the srcu connection read lock in cases where we lookup
the connections and accessing it. We don't hold the srcu lock in workers
function where the scheduled worker is part of the connection itself.
The connection should not be freed if any worker is scheduled or
pending.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 75 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 166e36fcf3e4..47bf99373f3e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -113,6 +113,7 @@ struct writequeue_entry {
 	int len;
 	int end;
 	int users;
+	int idx; /* get()/commit() idx exchange */
 	struct connection *con;
 };
 
@@ -163,21 +164,14 @@ static inline int nodeid_hash(int nodeid)
 	return nodeid & (CONN_HASH_SIZE-1);
 }
 
-static struct connection *__find_con(int nodeid)
+static struct connection *__find_con(int nodeid, int r)
 {
-	int r, idx;
 	struct connection *con;
 
-	r = nodeid_hash(nodeid);
-
-	idx = srcu_read_lock(&connections_srcu);
 	hlist_for_each_entry_rcu(con, &connection_hash[r], list) {
-		if (con->nodeid == nodeid) {
-			srcu_read_unlock(&connections_srcu, idx);
+		if (con->nodeid == nodeid)
 			return con;
-		}
 	}
-	srcu_read_unlock(&connections_srcu, idx);
 
 	return NULL;
 }
@@ -216,7 +210,8 @@ static struct connection *nodeid2con(int nodeid, gfp_t alloc)
 	struct connection *con, *tmp;
 	int r, ret;
 
-	con = __find_con(nodeid);
+	r = nodeid_hash(nodeid);
+	con = __find_con(nodeid, r);
 	if (con || !alloc)
 		return con;
 
@@ -230,8 +225,6 @@ static struct connection *nodeid2con(int nodeid, gfp_t alloc)
 		return NULL;
 	}
 
-	r = nodeid_hash(nodeid);
-
 	spin_lock(&connections_lock);
 	/* Because multiple workqueues/threads calls this function it can
 	 * race on multiple cpu's. Instead of locking hot path __find_con()
@@ -239,7 +232,7 @@ static struct connection *nodeid2con(int nodeid, gfp_t alloc)
 	 * under protection of connections_lock. If this is the case we
 	 * abort our connection creation and return the existing connection.
 	 */
-	tmp = __find_con(nodeid);
+	tmp = __find_con(nodeid, r);
 	if (tmp) {
 		spin_unlock(&connections_lock);
 		kfree(con->rx_buf);
@@ -256,15 +249,13 @@ static struct connection *nodeid2con(int nodeid, gfp_t alloc)
 /* Loop round all connections */
 static void foreach_conn(void (*conn_func)(struct connection *c))
 {
-	int i, idx;
+	int i;
 	struct connection *con;
 
-	idx = srcu_read_lock(&connections_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
 		hlist_for_each_entry_rcu(con, &connection_hash[i], list)
 			conn_func(con);
 	}
-	srcu_read_unlock(&connections_srcu, idx);
 }
 
 static struct dlm_node_addr *find_node_addr(int nodeid)
@@ -518,14 +509,21 @@ static void lowcomms_state_change(struct sock *sk)
 int dlm_lowcomms_connect_node(int nodeid)
 {
 	struct connection *con;
+	int idx;
 
 	if (nodeid == dlm_our_nodeid())
 		return 0;
 
+	idx = srcu_read_lock(&connections_srcu);
 	con = nodeid2con(nodeid, GFP_NOFS);
-	if (!con)
+	if (!con) {
+		srcu_read_unlock(&connections_srcu, idx);
 		return -ENOMEM;
+	}
+
 	lowcomms_connect_sock(con);
+	srcu_read_unlock(&connections_srcu, idx);
+
 	return 0;
 }
 
@@ -864,7 +862,7 @@ static int accept_from_sock(struct listen_connection *con)
 	int result;
 	struct sockaddr_storage peeraddr;
 	struct socket *newsock;
-	int len;
+	int len, idx;
 	int nodeid;
 	struct connection *newcon;
 	struct connection *addcon;
@@ -907,8 +905,10 @@ static int accept_from_sock(struct listen_connection *con)
 	 *  the same time and the connections cross on the wire.
 	 *  In this case we store the incoming one in "othercon"
 	 */
+	idx = srcu_read_lock(&connections_srcu);
 	newcon = nodeid2con(nodeid, GFP_NOFS);
 	if (!newcon) {
+		srcu_read_unlock(&connections_srcu, idx);
 		result = -ENOMEM;
 		goto accept_err;
 	}
@@ -924,6 +924,7 @@ static int accept_from_sock(struct listen_connection *con)
 			if (!othercon) {
 				log_print("failed to allocate incoming socket");
 				mutex_unlock(&newcon->sock_mutex);
+				srcu_read_unlock(&connections_srcu, idx);
 				result = -ENOMEM;
 				goto accept_err;
 			}
@@ -932,6 +933,7 @@ static int accept_from_sock(struct listen_connection *con)
 			if (result < 0) {
 				kfree(othercon);
 				mutex_unlock(&newcon->sock_mutex);
+				srcu_read_unlock(&connections_srcu, idx);
 				goto accept_err;
 			}
 
@@ -966,6 +968,8 @@ static int accept_from_sock(struct listen_connection *con)
 	if (!test_and_set_bit(CF_READ_PENDING, &addcon->flags))
 		queue_work(recv_workqueue, &addcon->rwork);
 
+	srcu_read_unlock(&connections_srcu, idx);
+
 	return 0;
 
 accept_err:
@@ -1403,7 +1407,9 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 
 void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 {
+	struct writequeue_entry *e;
 	struct connection *con;
+	int idx;
 
 	if (len > DEFAULT_BUFFER_SIZE ||
 	    len < sizeof(struct dlm_header)) {
@@ -1413,11 +1419,23 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 		return NULL;
 	}
 
+	idx = srcu_read_lock(&connections_srcu);
 	con = nodeid2con(nodeid, allocation);
-	if (!con)
+	if (!con) {
+		srcu_read_unlock(&connections_srcu, idx);
 		return NULL;
+	}
+
+	e = new_wq_entry(con, len, allocation, ppc);
+	if (!e) {
+		srcu_read_unlock(&connections_srcu, idx);
+		return NULL;
+	}
+
+	/* we assume if successful commit must called */
+	e->idx = idx;
 
-	return new_wq_entry(con, len, allocation, ppc);
+	return e;
 }
 
 void dlm_lowcomms_commit_buffer(void *mh)
@@ -1435,10 +1453,12 @@ void dlm_lowcomms_commit_buffer(void *mh)
 	spin_unlock(&con->writequeue_lock);
 
 	queue_work(send_workqueue, &con->swork);
+	srcu_read_unlock(&connections_srcu, e->idx);
 	return;
 
 out:
 	spin_unlock(&con->writequeue_lock);
+	srcu_read_unlock(&connections_srcu, e->idx);
 	return;
 }
 
@@ -1532,8 +1552,10 @@ int dlm_lowcomms_close(int nodeid)
 {
 	struct connection *con;
 	struct dlm_node_addr *na;
+	int idx;
 
 	log_print("closing connection to node %d", nodeid);
+	idx = srcu_read_lock(&connections_srcu);
 	con = nodeid2con(nodeid, 0);
 	if (con) {
 		set_bit(CF_CLOSE, &con->flags);
@@ -1542,6 +1564,7 @@ int dlm_lowcomms_close(int nodeid)
 		if (con->othercon)
 			clean_one_writequeue(con->othercon);
 	}
+	srcu_read_unlock(&connections_srcu, idx);
 
 	spin_lock(&dlm_node_addrs_spin);
 	na = find_node_addr(nodeid);
@@ -1621,6 +1644,8 @@ static void shutdown_conn(struct connection *con)
 
 void dlm_lowcomms_shutdown(void)
 {
+	int idx;
+
 	/* Set all the flags to prevent any
 	 * socket activity.
 	 */
@@ -1633,7 +1658,9 @@ void dlm_lowcomms_shutdown(void)
 
 	dlm_close_sock(&listen_con.sock);
 
+	idx = srcu_read_lock(&connections_srcu);
 	foreach_conn(shutdown_conn);
+	srcu_read_unlock(&connections_srcu, idx);
 }
 
 static void _stop_conn(struct connection *con, bool and_other)
@@ -1682,7 +1709,7 @@ static void free_conn(struct connection *con)
 
 static void work_flush(void)
 {
-	int ok, idx;
+	int ok;
 	int i;
 	struct connection *con;
 
@@ -1693,7 +1720,6 @@ static void work_flush(void)
 			flush_workqueue(recv_workqueue);
 		if (send_workqueue)
 			flush_workqueue(send_workqueue);
-		idx = srcu_read_lock(&connections_srcu);
 		for (i = 0; i < CONN_HASH_SIZE && ok; i++) {
 			hlist_for_each_entry_rcu(con, &connection_hash[i],
 						 list) {
@@ -1707,14 +1733,17 @@ static void work_flush(void)
 				}
 			}
 		}
-		srcu_read_unlock(&connections_srcu, idx);
 	} while (!ok);
 }
 
 void dlm_lowcomms_stop(void)
 {
+	int idx;
+
+	idx = srcu_read_lock(&connections_srcu);
 	work_flush();
 	foreach_conn(free_conn);
+	srcu_read_unlock(&connections_srcu, idx);
 	work_stop();
 	deinit_local();
 }
-- 
2.30.2



