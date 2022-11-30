Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911C63DE11
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiK3Sdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiK3SdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1D291C27
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 127EFCE1ACC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC214C433D7;
        Wed, 30 Nov 2022 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833198;
        bh=6Elykrh5DDKCg3gb5B5oGWR+HukBgEH+EP3/mwgEbVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5bbEj5bXJs+Jlwt80uq4at7MwjERQB8zLFnb+BxPT8sDNcz99HRDC+O6iVenEdTc
         cuJ6YXRB0vd4d6nszMb0RmnSJsjBU54Qm0saHqCxycB87F7cED9VZNc30P5cnYgEfW
         TUCWNMfKRPnf8Dp+mdaA3DwmMhZwh8p6710ornX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/206] cifs: split out dfs code from cifs_reconnect()
Date:   Wed, 30 Nov 2022 19:21:01 +0100
Message-Id: <20221130180533.231776523@linuxfoundation.org>
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

[ Upstream commit bbcce368044572d0802c3bbb8ef3fe98f581d803 ]

Make two separate functions that handle dfs and non-dfs reconnect
logics since cifs_reconnect() became way too complex to handle both.
While at it, add some documentation.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 1dcdf5f5b213 ("cifs: Fix connections leak when tlink setup failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 295 +++++++++++++++++++++++++---------------------
 1 file changed, 162 insertions(+), 133 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ed429a442808..5d87d5c01762 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -148,57 +148,6 @@ static void cifs_resolve_server(struct work_struct *work)
 	mutex_unlock(&server->srv_mutex);
 }
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
-/* These functions must be called with server->srv_mutex held */
-static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
-				       struct cifs_sb_info *cifs_sb,
-				       struct dfs_cache_tgt_list *tgt_list,
-				       struct dfs_cache_tgt_iterator **tgt_it)
-{
-	const char *name;
-	int rc;
-
-	if (!cifs_sb || !cifs_sb->origin_fullpath)
-		return;
-
-	if (!*tgt_it) {
-		*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
-	} else {
-		*tgt_it = dfs_cache_get_next_tgt(tgt_list, *tgt_it);
-		if (!*tgt_it)
-			*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
-	}
-
-	cifs_dbg(FYI, "%s: UNC: %s\n", __func__, cifs_sb->origin_fullpath);
-
-	name = dfs_cache_get_tgt_name(*tgt_it);
-
-	kfree(server->hostname);
-
-	server->hostname = extract_hostname(name);
-	if (IS_ERR(server->hostname)) {
-		cifs_dbg(FYI,
-			 "%s: failed to extract hostname from target: %ld\n",
-			 __func__, PTR_ERR(server->hostname));
-		return;
-	}
-
-	rc = reconn_set_ipaddr_from_hostname(server);
-	if (rc) {
-		cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-			 __func__, rc);
-	}
-}
-
-static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
-					   struct dfs_cache_tgt_list *tl)
-{
-	if (!cifs_sb->origin_fullpath)
-		return -EOPNOTSUPP;
-	return dfs_cache_noreq_find(cifs_sb->origin_fullpath + 1, NULL, tl);
-}
-#endif
-
 /**
  * Mark all sessions and tcons for reconnect.
  *
@@ -284,6 +233,21 @@ static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server
 	}
 }
 
+static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
+{
+	spin_lock(&GlobalMid_Lock);
+	server->nr_targets = num_targets;
+	if (server->tcpStatus == CifsExiting) {
+		/* the demux thread will exit normally next time through the loop */
+		spin_unlock(&GlobalMid_Lock);
+		wake_up(&server->response_q);
+		return false;
+	}
+	server->tcpStatus = CifsNeedReconnect;
+	spin_unlock(&GlobalMid_Lock);
+	return true;
+}
+
 /*
  * cifs tcp session reconnection
  *
@@ -292,90 +256,23 @@ static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server
  * reconnect tcp session
  * wake up waiters on reconnection? - (not needed currently)
  */
-int
-cifs_reconnect(struct TCP_Server_Info *server)
+static int __cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
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
-		/* the demux thread will exit normally next time through the loop */
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
+	if (!cifs_tcp_ses_needs_reconnect(server, 1))
+		return 0;
 
 	cifs_mark_tcp_ses_conns_for_reconnect(server);
 
 	do {
 		try_to_freeze();
-
 		mutex_lock(&server->srv_mutex);
 
-
 		if (!cifs_swn_set_server_dstaddr(server)) {
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (cifs_sb && cifs_sb->origin_fullpath)
-			/*
-			 * Set up next DFS target server (if any) for reconnect. If DFS
-			 * feature is disabled, then we will retry last server we
-			 * connected to before.
-			 */
-			reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
-		else {
-#endif
-			/*
-			 * Resolve the hostname again to make sure that IP address is up-to-date.
-			 */
+			/* resolve the hostname again to make sure that IP address is up-to-date */
 			rc = reconn_set_ipaddr_from_hostname(server);
-			if (rc) {
-				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-						__func__, rc);
-			}
-
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		}
-#endif
-
-
+			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);
 		}
 
 		if (cifs_rdma_enabled(server))
@@ -383,8 +280,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		else
 			rc = generic_ip_connect(server);
 		if (rc) {
-			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
+			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -398,19 +295,109 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
+	if (server->tcpStatus == CifsNeedNegotiate)
+		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+
+	wake_up(&server->response_q);
+	return rc;
+}
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	if (tgt_it) {
-		rc = dfs_cache_noreq_update_tgthint(cifs_sb->origin_fullpath + 1,
-						    tgt_it);
+static int reconnect_dfs_server(struct TCP_Server_Info *server, struct cifs_sb_info *cifs_sb)
+{
+	int rc = 0;
+	const char *refpath = cifs_sb->origin_fullpath + 1;
+	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
+	struct dfs_cache_tgt_iterator *tit = NULL;
+	int num_targets = 1;
+	char *hostname;
+
+	/*
+	 * Determine the number of dfs targets the referral path in @cifs_sb resolves to.
+	 *
+	 * smb2_reconnect() needs to know how long it should wait based upon the number of dfs
+	 * targets (server->nr_targets).  It's also possible that the cached referral was cleared
+	 * through /proc/fs/cifs/dfscache or the target list is empty due to server settings after
+	 * refreshing the referral, so, in this case, default it to 1.
+	 */
+	if (!dfs_cache_noreq_find(refpath, NULL, &tl)) {
+		num_targets = dfs_cache_get_nr_tgts(&tl);
+		if (!num_targets)
+			num_targets = 1;
+	}
+
+	if (!cifs_tcp_ses_needs_reconnect(server, num_targets))
+		return 0;
+
+	cifs_mark_tcp_ses_conns_for_reconnect(server);
+
+	do {
+		/* Get next dfs target from target list (if any) */
+		if (!tit)
+			tit = dfs_cache_get_tgt_iterator(&tl);
+		else
+			tit = dfs_cache_get_next_tgt(&tl, tit);
+
+		try_to_freeze();
+		mutex_lock(&server->srv_mutex);
+
+		if (!cifs_swn_set_server_dstaddr(server)) {
+			/*
+			 * If any dfs target was selected, then update @server with either a
+			 * hostname or an address.
+			 */
+			if (tit) {
+				hostname = extract_hostname(dfs_cache_get_tgt_name(tit));
+				if (!IS_ERR(hostname)) {
+					kfree(server->hostname);
+					server->hostname = hostname;
+				} else {
+					cifs_dbg(FYI, "%s: couldn't extract hostname or address from dfs target: %ld\n",
+						 __func__, PTR_ERR(hostname));
+					cifs_dbg(FYI, "%s: default to last target server: %s\n",
+						 __func__, server->hostname);
+				}
+			}
+			/* resolve the hostname again to make sure that IP address is up-to-date. */
+			rc = reconn_set_ipaddr_from_hostname(server);
+			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);
+		}
+
+		/* Reconnect the socket */
+		if (cifs_rdma_enabled(server))
+			rc = smbd_reconnect(server);
+		else
+			rc = generic_ip_connect(server);
+
 		if (rc) {
-			cifs_server_dbg(VFS, "%s: failed to update DFS target hint: rc = %d\n",
-				 __func__, rc);
+			/* Failed to reconnect socket.  Retry next dfs target. */
+			mutex_unlock(&server->srv_mutex);
+			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
+			msleep(3000);
+			continue;
 		}
-		dfs_cache_free_tgts(&tgt_list);
-	}
 
-	cifs_put_tcp_super(sb);
-#endif
+		/*
+		 * Socket was created.  Update tcp session status to CifsNeedNegotiate so that a
+		 * process waiting for reconnect will know it needs to re-establish session and tcon
+		 * through the reconnected target server.
+		 */
+		atomic_inc(&tcpSesReconnectCount);
+		set_credits(server, 1);
+		spin_lock(&GlobalMid_Lock);
+		if (server->tcpStatus != CifsExiting)
+			server->tcpStatus = CifsNeedNegotiate;
+		spin_unlock(&GlobalMid_Lock);
+		cifs_swn_reset_server_dstaddr(server);
+		mutex_unlock(&server->srv_mutex);
+	} while (server->tcpStatus == CifsNeedReconnect);
+
+	if (tit)
+		dfs_cache_noreq_update_tgthint(refpath, tit);
+
+	dfs_cache_free_tgts(&tl);
+
+	/* Need to set up echo worker again once connection has been established */
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
@@ -418,6 +405,48 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	return rc;
 }
 
+int cifs_reconnect(struct TCP_Server_Info *server)
+{
+	int rc;
+	struct super_block *sb;
+	struct cifs_sb_info *cifs_sb;
+
+	/*
+	 * If tcp session is not an dfs connection or it is a channel, then reconnect to last target
+	 * server.
+	 */
+	spin_lock(&cifs_tcp_ses_lock);
+	if (!server->is_dfs_conn || server->is_channel) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return __cifs_reconnect(server);
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	/* If no superblock, then it might be an ipc connection */
+	sb = cifs_get_tcp_super(server);
+	if (IS_ERR(sb))
+		return __cifs_reconnect(server);
+
+	/*
+	 * Check for a referral path to look up in superblock.  If unset, then simply reconnect to
+	 * last target server.
+	 */
+	cifs_sb = CIFS_SB(sb);
+	if (!cifs_sb->origin_fullpath || !cifs_sb->origin_fullpath[0])
+		rc = __cifs_reconnect(server);
+	else
+		rc = reconnect_dfs_server(server, cifs_sb);
+
+	cifs_put_tcp_super(sb);
+	return rc;
+}
+#else
+int cifs_reconnect(struct TCP_Server_Info *server)
+{
+	return __cifs_reconnect(server);
+}
+#endif
+
 static void
 cifs_echo_request(struct work_struct *work)
 {
-- 
2.35.1



