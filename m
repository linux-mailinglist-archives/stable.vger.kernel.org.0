Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D215A38309C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhEQO3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239579AbhEQO07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF87A613C8;
        Mon, 17 May 2021 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260837;
        bh=sX7UctcOPpUbZ80yVF/kjb7Q0kRghi7//tGDYtvRpDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfmJD+i8RxKAu/MR0a1aYONTGdTD6BnY0v6qyvvaNK6L4FO0EKIctAKS8sIgF3kRO
         36eDekNIHscvYHkJVPVIJJqnaeTLgKnEuLkPwLcHuPjtJDD+m+qc5hgaTlV/Kmem1v
         rKSM9Ay2sjXCoCWuvUNP7HD5dP/ta+A4mldjZnEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 015/329] fs: dlm: fix mark setting deadlock
Date:   Mon, 17 May 2021 15:58:46 +0200
Message-Id: <20210517140302.564932505@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit e125fbeb538e5e35a00c6c8150a5361bef34814c ]

This patch fixes an deadlock issue when dlm_lowcomms_close() is called.
When dlm_lowcomms_close() is called the clusters_root.subsys.su_mutex is
held to remove configfs items. At this time we flushing (e.g.
cancel_work_sync()) the workers of send and recv workqueue. Due the fact
that we accessing configfs items (mark values), these workers will lock
clusters_root.subsys.su_mutex as well which are already hold by
dlm_lowcomms_close() and ends in a deadlock situation.

[67170.703046] ======================================================
[67170.703965] WARNING: possible circular locking dependency detected
[67170.704758] 5.11.0-rc4+ #22 Tainted: G        W
[67170.705433] ------------------------------------------------------
[67170.706228] dlm_controld/280 is trying to acquire lock:
[67170.706915] ffff9f2f475a6948 ((wq_completion)dlm_recv){+.+.}-{0:0}, at: __flush_work+0x203/0x4c0
[67170.708026]
               but task is already holding lock:
[67170.708758] ffffffffa132f878 (&clusters_root.subsys.su_mutex){+.+.}-{3:3}, at: configfs_rmdir+0x29b/0x310
[67170.710016]
               which lock already depends on the new lock.

The new behaviour adds the mark value to the node address configuration
which doesn't require to held the clusters_root.subsys.su_mutex by
accessing mark values in a separate datastructure. However the mark
values can be set now only after a node address was set which is the
case when the user is using dlm_controld.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c   | 29 ++++++++++------------------
 fs/dlm/config.h   |  1 -
 fs/dlm/lowcomms.c | 49 ++++++++++++++++++++++++++++++++---------------
 fs/dlm/lowcomms.h |  1 +
 4 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 49c5f9407098..582bffa09a66 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -688,6 +688,7 @@ static ssize_t comm_mark_show(struct config_item *item, char *buf)
 static ssize_t comm_mark_store(struct config_item *item, const char *buf,
 			       size_t len)
 {
+	struct dlm_comm *comm;
 	unsigned int mark;
 	int rc;
 
@@ -695,7 +696,15 @@ static ssize_t comm_mark_store(struct config_item *item, const char *buf,
 	if (rc)
 		return rc;
 
-	config_item_to_comm(item)->mark = mark;
+	if (mark == 0)
+		mark = dlm_config.ci_mark;
+
+	comm = config_item_to_comm(item);
+	rc = dlm_lowcomms_nodes_set_mark(comm->nodeid, mark);
+	if (rc)
+		return rc;
+
+	comm->mark = mark;
 	return len;
 }
 
@@ -870,24 +879,6 @@ int dlm_comm_seq(int nodeid, uint32_t *seq)
 	return 0;
 }
 
-void dlm_comm_mark(int nodeid, unsigned int *mark)
-{
-	struct dlm_comm *cm;
-
-	cm = get_comm(nodeid);
-	if (!cm) {
-		*mark = dlm_config.ci_mark;
-		return;
-	}
-
-	if (cm->mark)
-		*mark = cm->mark;
-	else
-		*mark = dlm_config.ci_mark;
-
-	put_comm(cm);
-}
-
 int dlm_our_nodeid(void)
 {
 	return local_comm ? local_comm->nodeid : 0;
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index c210250a2581..d2cd4bd20313 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -48,7 +48,6 @@ void dlm_config_exit(void);
 int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
 		     int *count_out);
 int dlm_comm_seq(int nodeid, uint32_t *seq);
-void dlm_comm_mark(int nodeid, unsigned int *mark);
 int dlm_our_nodeid(void);
 int dlm_our_addr(struct sockaddr_storage *addr, int num);
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index f7d2c52791f8..a4fabcced0f2 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -116,6 +116,7 @@ struct writequeue_entry {
 struct dlm_node_addr {
 	struct list_head list;
 	int nodeid;
+	int mark;
 	int addr_count;
 	int curr_addr_index;
 	struct sockaddr_storage *addr[DLM_MAX_ADDR_COUNT];
@@ -303,7 +304,8 @@ static int addr_compare(const struct sockaddr_storage *x,
 }
 
 static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
-			  struct sockaddr *sa_out, bool try_new_addr)
+			  struct sockaddr *sa_out, bool try_new_addr,
+			  unsigned int *mark)
 {
 	struct sockaddr_storage sas;
 	struct dlm_node_addr *na;
@@ -331,6 +333,8 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 	if (!na->addr_count)
 		return -ENOENT;
 
+	*mark = na->mark;
+
 	if (sas_out)
 		memcpy(sas_out, &sas, sizeof(struct sockaddr_storage));
 
@@ -350,7 +354,8 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 	return 0;
 }
 
-static int addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid)
+static int addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid,
+			  unsigned int *mark)
 {
 	struct dlm_node_addr *na;
 	int rv = -EEXIST;
@@ -364,6 +369,7 @@ static int addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid)
 		for (addr_i = 0; addr_i < na->addr_count; addr_i++) {
 			if (addr_compare(na->addr[addr_i], addr)) {
 				*nodeid = na->nodeid;
+				*mark = na->mark;
 				rv = 0;
 				goto unlock;
 			}
@@ -412,6 +418,7 @@ int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr, int len)
 		new_node->nodeid = nodeid;
 		new_node->addr[0] = new_addr;
 		new_node->addr_count = 1;
+		new_node->mark = dlm_config.ci_mark;
 		list_add(&new_node->list, &dlm_node_addrs);
 		spin_unlock(&dlm_node_addrs_spin);
 		return 0;
@@ -519,6 +526,23 @@ int dlm_lowcomms_connect_node(int nodeid)
 	return 0;
 }
 
+int dlm_lowcomms_nodes_set_mark(int nodeid, unsigned int mark)
+{
+	struct dlm_node_addr *na;
+
+	spin_lock(&dlm_node_addrs_spin);
+	na = find_node_addr(nodeid);
+	if (!na) {
+		spin_unlock(&dlm_node_addrs_spin);
+		return -ENOENT;
+	}
+
+	na->mark = mark;
+	spin_unlock(&dlm_node_addrs_spin);
+
+	return 0;
+}
+
 static void lowcomms_error_report(struct sock *sk)
 {
 	struct connection *con;
@@ -867,7 +891,7 @@ static int accept_from_sock(struct listen_connection *con)
 
 	/* Get the new node's NODEID */
 	make_sockaddr(&peeraddr, 0, &len);
-	if (addr_to_nodeid(&peeraddr, &nodeid)) {
+	if (addr_to_nodeid(&peeraddr, &nodeid, &mark)) {
 		unsigned char *b=(unsigned char *)&peeraddr;
 		log_print("connect from non cluster node");
 		print_hex_dump_bytes("ss: ", DUMP_PREFIX_NONE, 
@@ -876,9 +900,6 @@ static int accept_from_sock(struct listen_connection *con)
 		return -1;
 	}
 
-	dlm_comm_mark(nodeid, &mark);
-	sock_set_mark(newsock->sk, mark);
-
 	log_print("got connection from %d", nodeid);
 
 	/*  Check to see if we already have a connection to this node. This
@@ -892,6 +913,8 @@ static int accept_from_sock(struct listen_connection *con)
 		goto accept_err;
 	}
 
+	sock_set_mark(newsock->sk, mark);
+
 	mutex_lock(&newcon->sock_mutex);
 	if (newcon->sock) {
 		struct connection *othercon = newcon->othercon;
@@ -1016,8 +1039,6 @@ static void sctp_connect_to_sock(struct connection *con)
 	struct socket *sock;
 	unsigned int mark;
 
-	dlm_comm_mark(con->nodeid, &mark);
-
 	mutex_lock(&con->sock_mutex);
 
 	/* Some odd races can cause double-connects, ignore them */
@@ -1030,7 +1051,7 @@ static void sctp_connect_to_sock(struct connection *con)
 	}
 
 	memset(&daddr, 0, sizeof(daddr));
-	result = nodeid_to_addr(con->nodeid, &daddr, NULL, true);
+	result = nodeid_to_addr(con->nodeid, &daddr, NULL, true, &mark);
 	if (result < 0) {
 		log_print("no address for nodeid %d", con->nodeid);
 		goto out;
@@ -1105,13 +1126,11 @@ out:
 static void tcp_connect_to_sock(struct connection *con)
 {
 	struct sockaddr_storage saddr, src_addr;
+	unsigned int mark;
 	int addr_len;
 	struct socket *sock = NULL;
-	unsigned int mark;
 	int result;
 
-	dlm_comm_mark(con->nodeid, &mark);
-
 	mutex_lock(&con->sock_mutex);
 	if (con->retries++ > MAX_CONNECT_RETRIES)
 		goto out;
@@ -1126,15 +1145,15 @@ static void tcp_connect_to_sock(struct connection *con)
 	if (result < 0)
 		goto out_err;
 
-	sock_set_mark(sock->sk, mark);
-
 	memset(&saddr, 0, sizeof(saddr));
-	result = nodeid_to_addr(con->nodeid, &saddr, NULL, false);
+	result = nodeid_to_addr(con->nodeid, &saddr, NULL, false, &mark);
 	if (result < 0) {
 		log_print("no address for nodeid %d", con->nodeid);
 		goto out_err;
 	}
 
+	sock_set_mark(sock->sk, mark);
+
 	add_sock(sock, con);
 
 	/* Bind to our cluster-known address connecting to avoid
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index 0918f9376489..790d6703b17e 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -21,6 +21,7 @@ int dlm_lowcomms_close(int nodeid);
 void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc);
 void dlm_lowcomms_commit_buffer(void *mh);
 int dlm_lowcomms_connect_node(int nodeid);
+int dlm_lowcomms_nodes_set_mark(int nodeid, unsigned int mark);
 int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr, int len);
 
 #endif				/* __LOWCOMMS_DOT_H__ */
-- 
2.30.2



