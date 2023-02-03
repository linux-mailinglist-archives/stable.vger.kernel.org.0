Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01196895A8
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjBCKU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjBCKU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:20:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC6F93AFA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 966B561ECB
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4CEC433EF;
        Fri,  3 Feb 2023 10:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419557;
        bh=9UmmzKWw9WqmEW4XawhD9HNb9/Eel2VLfrF1JC1ckk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5OPPQ9oudLBLwKKiB8E5ZhTz4NhSQ47nrlEpogg1mCHzMMGInSbjX66ffDv7YXmP
         yxMBlC/Da9sn4gzSoL/sNKhSNXAdU8G+Z09asWeL4Fooq/d8/enSq3DgrlqvxAdq1O
         Ha8tlIL/4D04bQhWwqI7lFTOpZFrXkmrRJgk2hkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/80] smbd: Make upper layer decide when to destroy the transport
Date:   Fri,  3 Feb 2023 11:12:35 +0100
Message-Id: <20230203101016.948845126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 050b8c374019c10e4bcc3fbc9023884f76a85d9c ]

On transport recoonect, upper layer CIFS code destroys the current
transport and then recoonect. This code path is not used by SMBD, in that
SMBD destroys its transport on RDMA disconnect notification independent of
CIFS upper layer behavior.

This approach adds some costs to SMBD layer to handle transport shutdown
and restart, and to deal with several racing conditions on reconnecting
transport.

Re-work this code path by introducing a new smbd_destroy. This function is
called form upper layer to ask SMBD to destroy the transport. SMBD will no
longer need to destroy the transport by itself while worrying about data
transfer is in progress. The upper layer guarantees the transport is
locked.

change log:
v2: fix build errors when CONFIG_CIFS_SMB_DIRECT is not configured

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: b7ab9161cf5d ("cifs: Fix oops due to uncleared server->smbd_conn in reconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c   |   9 ++--
 fs/cifs/smbdirect.c | 114 ++++++++++++++++++++++++++++++++++++--------
 fs/cifs/smbdirect.h |   5 +-
 3 files changed, 101 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a7ef847f285d..37e91f27f49b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -429,7 +429,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			 server->ssocket->state, server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-	}
+	} else if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
 	server->sequence_number = 0;
 	server->session_estab = false;
 	kfree(server->session_key.response);
@@ -799,10 +800,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		smbd_destroy(server->smbd_conn);
-		server->smbd_conn = NULL;
-	}
+	if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 784628ec4bc4..c839ff9d4965 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -320,6 +320,9 @@ static int smbd_conn_upcall(
 
 		info->transport_status = SMBD_DISCONNECTED;
 		smbd_process_disconnected(info);
+		wake_up(&info->disconn_wait);
+		wake_up_interruptible(&info->wait_reassembly_queue);
+		wake_up_interruptible_all(&info->wait_send_queue);
 		break;
 
 	default:
@@ -1478,17 +1481,97 @@ static void idle_connection_timer(struct work_struct *work)
 			info->keep_alive_interval*HZ);
 }
 
-/* Destroy this SMBD connection, called from upper layer */
-void smbd_destroy(struct smbd_connection *info)
+/*
+ * Destroy the transport and related RDMA and memory resources
+ * Need to go through all the pending counters and make sure on one is using
+ * the transport while it is destroyed
+ */
+void smbd_destroy(struct TCP_Server_Info *server)
 {
+	struct smbd_connection *info = server->smbd_conn;
+	struct smbd_response *response;
+	unsigned long flags;
+
+	if (!info) {
+		log_rdma_event(INFO, "rdma session already destroyed\n");
+		return;
+	}
+
 	log_rdma_event(INFO, "destroying rdma session\n");
+	if (info->transport_status != SMBD_DISCONNECTED) {
+		rdma_disconnect(server->smbd_conn->id);
+		log_rdma_event(INFO, "wait for transport being disconnected\n");
+		wait_event(
+			info->disconn_wait,
+			info->transport_status == SMBD_DISCONNECTED);
+	}
 
-	/* Kick off the disconnection process */
-	smbd_disconnect_rdma_connection(info);
+	log_rdma_event(INFO, "destroying qp\n");
+	ib_drain_qp(info->id->qp);
+	rdma_destroy_qp(info->id);
+
+	log_rdma_event(INFO, "cancelling idle timer\n");
+	cancel_delayed_work_sync(&info->idle_timer_work);
+	log_rdma_event(INFO, "cancelling send immediate work\n");
+	cancel_delayed_work_sync(&info->send_immediate_work);
+
+	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
+	wait_event(info->wait_send_pending,
+		atomic_read(&info->send_pending) == 0);
+	wait_event(info->wait_send_payload_pending,
+		atomic_read(&info->send_payload_pending) == 0);
+
+	/* It's not posssible for upper layer to get to reassembly */
+	log_rdma_event(INFO, "drain the reassembly queue\n");
+	do {
+		spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+		response = _get_first_reassembly(info);
+		if (response) {
+			list_del(&response->list);
+			spin_unlock_irqrestore(
+				&info->reassembly_queue_lock, flags);
+			put_receive_buffer(info, response);
+		} else
+			spin_unlock_irqrestore(
+				&info->reassembly_queue_lock, flags);
+	} while (response);
+	info->reassembly_data_length = 0;
+
+	log_rdma_event(INFO, "free receive buffers\n");
+	wait_event(info->wait_receive_queues,
+		info->count_receive_queue + info->count_empty_packet_queue
+			== info->receive_credit_max);
+	destroy_receive_buffers(info);
+
+	/*
+	 * For performance reasons, memory registration and deregistration
+	 * are not locked by srv_mutex. It is possible some processes are
+	 * blocked on transport srv_mutex while holding memory registration.
+	 * Release the transport srv_mutex to allow them to hit the failure
+	 * path when sending data, and then release memory registartions.
+	 */
+	log_rdma_event(INFO, "freeing mr list\n");
+	wake_up_interruptible_all(&info->wait_mr);
+	while (atomic_read(&info->mr_used_count)) {
+		mutex_unlock(&server->srv_mutex);
+		msleep(1000);
+		mutex_lock(&server->srv_mutex);
+	}
+	destroy_mr_list(info);
+
+	ib_free_cq(info->send_cq);
+	ib_free_cq(info->recv_cq);
+	ib_dealloc_pd(info->pd);
+	rdma_destroy_id(info->id);
 
-	log_rdma_event(INFO, "wait for transport being destroyed\n");
-	wait_event(info->wait_destroy,
-		info->transport_status == SMBD_DESTROYED);
+	/* free mempools */
+	mempool_destroy(info->request_mempool);
+	kmem_cache_destroy(info->request_cache);
+
+	mempool_destroy(info->response_mempool);
+	kmem_cache_destroy(info->response_cache);
+
+	info->transport_status = SMBD_DESTROYED;
 
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
@@ -1514,17 +1597,9 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	 */
 	if (server->smbd_conn->transport_status == SMBD_CONNECTED) {
 		log_rdma_event(INFO, "disconnecting transport\n");
-		smbd_disconnect_rdma_connection(server->smbd_conn);
+		smbd_destroy(server);
 	}
 
-	/* wait until the transport is destroyed */
-	if (!wait_event_timeout(server->smbd_conn->wait_destroy,
-		server->smbd_conn->transport_status == SMBD_DESTROYED, 5*HZ))
-		return -EAGAIN;
-
-	destroy_workqueue(server->smbd_conn->workqueue);
-	kfree(server->smbd_conn);
-
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
 	server->smbd_conn = smbd_get_connection(
@@ -1741,12 +1816,13 @@ static struct smbd_connection *_smbd_get_connection(
 	conn_param.retry_count = SMBD_CM_RETRY;
 	conn_param.rnr_retry_count = SMBD_CM_RNR_RETRY;
 	conn_param.flow_control = 0;
-	init_waitqueue_head(&info->wait_destroy);
 
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
 	init_waitqueue_head(&info->conn_wait);
+	init_waitqueue_head(&info->disconn_wait);
+	init_waitqueue_head(&info->wait_reassembly_queue);
 	rc = rdma_connect(info->id, &conn_param);
 	if (rc) {
 		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
@@ -1770,8 +1846,6 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	init_waitqueue_head(&info->wait_send_queue);
-	init_waitqueue_head(&info->wait_reassembly_queue);
-
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
 	INIT_DELAYED_WORK(&info->send_immediate_work, send_immediate_work);
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -1812,7 +1886,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
-	smbd_destroy(info);
+	smbd_destroy(server);
 	return NULL;
 
 negotiation_failed:
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index b5c240ff2191..b0ca7df41454 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -71,6 +71,7 @@ struct smbd_connection {
 	struct completion ri_done;
 	wait_queue_head_t conn_wait;
 	wait_queue_head_t wait_destroy;
+	wait_queue_head_t disconn_wait;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
@@ -288,7 +289,7 @@ struct smbd_connection *smbd_get_connection(
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
 /* Destroy SMBDirect session */
-void smbd_destroy(struct smbd_connection *info);
+void smbd_destroy(struct TCP_Server_Info *server);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
@@ -331,7 +332,7 @@ struct smbd_connection {};
 static inline void *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
-static inline void smbd_destroy(struct smbd_connection *info) {}
+static inline void smbd_destroy(struct TCP_Server_Info *server) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
 static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
 #endif
-- 
2.39.0



