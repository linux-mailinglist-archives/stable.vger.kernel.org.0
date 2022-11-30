Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF963DE10
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiK3Sd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiK3SdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB01248E2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D775B81B82
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E458C433C1;
        Wed, 30 Nov 2022 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833195;
        bh=3iks4pyKQbBxx5OPkeB21/BEmVJwOls7wqnK5JgVhIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUqJSKkkT6h5uX1vCtIgGkxcUPoiUAK1Zr2mBss5WGPdc40VjEXwfECf+XS+4hbZY
         A7gD2e/4TEgupaT6DmBwfR5qUbsWNdLg9WKDAay3532YwzyVJOPvHKmEjdz5UAuBjg
         qXGt9n6Or39+l0oVhF5EkxTmpm1Zt7h6rPF82Rjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/206] cifs: introduce new helper for cifs_reconnect()
Date:   Wed, 30 Nov 2022 19:21:00 +0100
Message-Id: <20221130180533.204728493@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 43b459aa5e222cb6610dac8723b40c19532ea00d ]

Create cifs_mark_tcp_ses_conns_for_reconnect() helper to mark all
sessions and tcons for reconnect when reconnecting tcp server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 1dcdf5f5b213 ("cifs: Fix connections leak when tlink setup failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 139 +++++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 64 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ad5c935f7f06..ed429a442808 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -199,80 +199,29 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 }
 #endif
 
-/*
- * cifs tcp session reconnection
+/**
+ * Mark all sessions and tcons for reconnect.
  *
- * mark tcp session as reconnecting so temporarily locked
- * mark all smb sessions as reconnecting for tcp session
- * reconnect tcp session
- * wake up waiters on reconnection? - (not needed currently)
+ * @server needs to be previously set to CifsNeedReconnect.
  */
-int
-cifs_reconnect(struct TCP_Server_Info *server)
+static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server)
 {
-	int rc = 0;
 	struct list_head *tmp, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct mid_q_entry *mid_entry;
 	struct list_head retry_list;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	struct super_block *sb = NULL;
-	struct cifs_sb_info *cifs_sb = NULL;
-	struct dfs_cache_tgt_list tgt_list = DFS_CACHE_TGT_LIST_INIT(tgt_list);
-	struct dfs_cache_tgt_iterator *tgt_it = NULL;
-#endif
 
-	spin_lock(&GlobalMid_Lock);
-	server->nr_targets = 1;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	spin_unlock(&GlobalMid_Lock);
-	sb = cifs_get_tcp_super(server);
-	if (IS_ERR(sb)) {
-		rc = PTR_ERR(sb);
-		cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
-			 __func__, rc);
-		sb = NULL;
-	} else {
-		cifs_sb = CIFS_SB(sb);
-		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list);
-		if (rc) {
-			cifs_sb = NULL;
-			if (rc != -EOPNOTSUPP) {
-				cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
-						__func__);
-			}
-		} else {
-			server->nr_targets = dfs_cache_get_nr_tgts(&tgt_list);
-		}
-	}
-	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
-		 server->nr_targets);
-	spin_lock(&GlobalMid_Lock);
-#endif
-	if (server->tcpStatus == CifsExiting) {
-		/* the demux thread will exit normally
-		next time through the loop */
-		spin_unlock(&GlobalMid_Lock);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		dfs_cache_free_tgts(&tgt_list);
-		cifs_put_tcp_super(sb);
-#endif
-		wake_up(&server->response_q);
-		return rc;
-	} else
-		server->tcpStatus = CifsNeedReconnect;
-	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
 	server->max_read = 0;
 
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->CurrentMid, server->conn_id, server->hostname);
-
-	/* before reconnecting the tcp session, mark the smb session (uid)
-		and the tid bad so they are not used until reconnected */
-	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n",
-		 __func__);
+	/*
+	 * before reconnecting the tcp session, mark the smb session (uid) and the tid bad so they
+	 * are not used until reconnected.
+	 */
+	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n", __func__);
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
@@ -290,11 +239,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
-		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
+		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n", server->ssocket->state,
+			 server->ssocket->flags);
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
+		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n", server->ssocket->state,
+			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
@@ -333,6 +282,68 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		smbd_destroy(server);
 		mutex_unlock(&server->srv_mutex);
 	}
+}
+
+/*
+ * cifs tcp session reconnection
+ *
+ * mark tcp session as reconnecting so temporarily locked
+ * mark all smb sessions as reconnecting for tcp session
+ * reconnect tcp session
+ * wake up waiters on reconnection? - (not needed currently)
+ */
+int
+cifs_reconnect(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	struct super_block *sb = NULL;
+	struct cifs_sb_info *cifs_sb = NULL;
+	struct dfs_cache_tgt_list tgt_list = DFS_CACHE_TGT_LIST_INIT(tgt_list);
+	struct dfs_cache_tgt_iterator *tgt_it = NULL;
+#endif
+
+	spin_lock(&GlobalMid_Lock);
+	server->nr_targets = 1;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	spin_unlock(&GlobalMid_Lock);
+	sb = cifs_get_tcp_super(server);
+	if (IS_ERR(sb)) {
+		rc = PTR_ERR(sb);
+		cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
+			 __func__, rc);
+		sb = NULL;
+	} else {
+		cifs_sb = CIFS_SB(sb);
+		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list);
+		if (rc) {
+			cifs_sb = NULL;
+			if (rc != -EOPNOTSUPP) {
+				cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
+						__func__);
+			}
+		} else {
+			server->nr_targets = dfs_cache_get_nr_tgts(&tgt_list);
+		}
+	}
+	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
+		 server->nr_targets);
+	spin_lock(&GlobalMid_Lock);
+#endif
+	if (server->tcpStatus == CifsExiting) {
+		/* the demux thread will exit normally next time through the loop */
+		spin_unlock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		dfs_cache_free_tgts(&tgt_list);
+		cifs_put_tcp_super(sb);
+#endif
+		wake_up(&server->response_q);
+		return rc;
+	} else
+		server->tcpStatus = CifsNeedReconnect;
+	spin_unlock(&GlobalMid_Lock);
+
+	cifs_mark_tcp_ses_conns_for_reconnect(server);
 
 	do {
 		try_to_freeze();
-- 
2.35.1



