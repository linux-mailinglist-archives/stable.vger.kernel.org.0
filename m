Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C94F27E6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiDEIJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiDEH6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACC8986ED;
        Tue,  5 Apr 2022 00:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0FFCB81BAD;
        Tue,  5 Apr 2022 07:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3176FC340EE;
        Tue,  5 Apr 2022 07:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145110;
        bh=MpZN47ZSjV63hyfxgu1kMyFg7GOt39ar8sPbyKyC1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k20u/KMN4kYfej7KK9Gz+1DpFZvl7Nt4bQRYIvEk+VLhQV4oKXLloiZeq7wWu6iYV
         r1LKiRTF5vjqHFpABzfRIVnj/XAMS5NrSGj8qXkSTax5KcMBV2666vZiFLlO94bUQc
         g74gfQ3Gh1E1Wl+RzraOra7N2wzhEdaauqhpSWZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0287/1126] cifs: use a different reconnect helper for non-cifsd threads
Date:   Tue,  5 Apr 2022 09:17:14 +0200
Message-Id: <20220405070416.037987281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit dca65818c80cf06e0f08ba2cf94060a5236e73c2 ]

The cifs_demultiplexer_thread should only call cifs_reconnect.
If any other thread wants to trigger a reconnect, they can do
so by updating the server tcpStatus to CifsNeedReconnect.

The last patch attempted to use the same helper function for
both types of threads, but that causes other issues
with lock dependencies.

This patch creates a new helper for non-cifsd threads, that
will indicate to cifsd that the server needs reconnect.

Fixes: 2a05137a0575 ("cifs: mark sessions for reconnection in helper function")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_swn.c  |  6 +++---
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/connect.c   | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/dfs_cache.c |  2 +-
 fs/cifs/smb1ops.c   |  2 +-
 fs/cifs/transport.c |  2 +-
 6 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index cdce1609c5c2..180c234c2f46 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -396,11 +396,11 @@ static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const ch
 	switch (state) {
 	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
-		cifs_mark_tcp_ses_conns_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
-		cifs_mark_tcp_ses_conns_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
@@ -498,7 +498,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 		goto unlock;
 	}
 
-	cifs_mark_tcp_ses_conns_for_reconnect(tcon->ses->server, false);
+	cifs_signal_cifsd_for_reconnect(tcon->ses->server, false);
 
 unlock:
 	mutex_unlock(&tcon->ses->server->srv_mutex);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d3701295402d..0df3b24a0bf4 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -132,6 +132,9 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 void
+cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
+				      bool all_channels);
+void
 cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 				      bool mark_smb_session);
 extern int cifs_reconnect(struct TCP_Server_Info *server,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 26dbc1d857ad..d6f8ccc7bfe2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -162,11 +162,51 @@ static void cifs_resolve_server(struct work_struct *work)
 	mutex_unlock(&server->srv_mutex);
 }
 
+/*
+ * Update the tcpStatus for the server.
+ * This is used to signal the cifsd thread to call cifs_reconnect
+ * ONLY cifsd thread should call cifs_reconnect. For any other
+ * thread, use this function
+ *
+ * @server: the tcp ses for which reconnect is needed
+ * @all_channels: if this needs to be done for all channels
+ */
+void
+cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
+				bool all_channels)
+{
+	struct TCP_Server_Info *pserver;
+	struct cifs_ses *ses;
+	int i;
+
+	/* If server is a channel, select the primary channel */
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	if (!all_channels) {
+		pserver->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&cifs_tcp_ses_lock);
+		return;
+	}
+
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		spin_lock(&ses->chan_lock);
+		for (i = 0; i < ses->chan_count; i++)
+			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&ses->chan_lock);
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+}
+
 /*
  * Mark all sessions and tcons for reconnect.
+ * IMPORTANT: make sure that this gets called only from
+ * cifsd thread. For any other thread, use
+ * cifs_signal_cifsd_for_reconnect
  *
+ * @server: the tcp ses for which reconnect is needed
  * @server needs to be previously set to CifsNeedReconnect.
- *
+ * @mark_smb_session: whether even sessions need to be marked
  */
 void
 cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 831f42458bf6..30e040da4f09 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1355,7 +1355,7 @@ static void mark_for_reconnect_if_needed(struct cifs_tcon *tcon, struct dfs_cach
 	}
 
 	cifs_dbg(FYI, "%s: no cached or matched targets. mark dfs share for reconnect.\n", __func__);
-	cifs_mark_tcp_ses_conns_for_reconnect(tcon->ses->server, true);
+	cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
 }
 
 /* Refresh dfs referral of tcon and mark it for reconnect if needed */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b2fb7bd11936..c71c9a44bef4 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -228,7 +228,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 
 	if (reconnect) {
-		cifs_mark_tcp_ses_conns_for_reconnect(server, false);
+		cifs_signal_cifsd_for_reconnect(server, false);
 	}
 
 	return mid;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index a4c3e027cca2..eeb1a699bd6f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -430,7 +430,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		 * be taken as the remainder of this one. We need to kill the
 		 * socket so the server throws away the partial SMB
 		 */
-		cifs_mark_tcp_ses_conns_for_reconnect(server, false);
+		cifs_signal_cifsd_for_reconnect(server, false);
 		trace_smb3_partial_send_reconnect(server->CurrentMid,
 						  server->conn_id, server->hostname);
 	}
-- 
2.34.1



