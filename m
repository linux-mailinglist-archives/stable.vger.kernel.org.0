Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650CD6CBDED
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjC1Lhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjC1Lhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:37:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B192959E9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58184B81BDF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B038AC433EF;
        Tue, 28 Mar 2023 11:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003453;
        bh=jWJaNJ1WCGlLky9IjylndoOibpXqoabQ1jFzbUpRw4I=;
        h=Subject:To:Cc:From:Date:From;
        b=QJvGNmTJc/xG3OxokZnu4yKl+f44APPrU7nrA7NRsJyjhSD2Zv1npRZN+Fw7+7phQ
         jnocUXjrmg5ewi5xTRmiJXXg5VpJpI9fI58X0wJjWr2b8gFVgIQ7UnnThtaAUNOGoM
         HpxejSBQh/wAYM6MBelX94pMhHxM/g/cGUgJopsU=
Subject: FAILED: patch "[PATCH] cifs: avoid race conditions with parallel reconnects" failed to apply to 6.1-stable tree
To:     sprasad@microsoft.com, pc@manguebit.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:37:22 +0200
Message-ID: <168000344221854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x bc962159e8e326af634a506508034a375bf2b858
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000344221854@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
1bcd548d935a ("cifs: prevent data race in cifs_reconnect_tcon()")
e77978de4765 ("cifs: update ip_addr for ses only for primary chan setup")
3c0070f54b31 ("cifs: prevent data race in smb2_reconnect()")
25cf01b7c920 ("cifs: set correct status of tcon ipc when reconnecting")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bc962159e8e326af634a506508034a375bf2b858 Mon Sep 17 00:00:00 2001
From: Shyam Prasad N <sprasad@microsoft.com>
Date: Mon, 20 Mar 2023 06:08:19 +0000
Subject: [PATCH] cifs: avoid race conditions with parallel reconnects

When multiple processes/channels do reconnects in parallel
we used to return success immediately
negotiate/session-setup/tree-connect, causing race conditions
between processes that enter the function in parallel.
This caused several errors related to session not found to
show up during parallel reconnects.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f42cc7077312..c3162ef9c9e9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -212,31 +212,42 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			cifs_chan_update_iface(ses, server);
 
 		spin_lock(&ses->chan_lock);
-		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server))
-			goto next_session;
+		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server)) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
 
 		if (mark_smb_session)
 			CIFS_SET_ALL_CHANS_NEED_RECONNECT(ses);
 		else
 			cifs_chan_set_need_reconnect(ses, server);
 
+		cifs_dbg(FYI, "%s: channel connect bitmap: 0x%lx\n",
+			 __func__, ses->chans_need_reconnect);
+
 		/* If all channels need reconnect, then tcon needs reconnect */
-		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses))
-			goto next_session;
+		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
+		spin_unlock(&ses->chan_lock);
 
+		spin_lock(&ses->ses_lock);
 		ses->ses_status = SES_NEED_RECON;
+		spin_unlock(&ses->ses_lock);
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
+			spin_lock(&tcon->tc_lock);
 			tcon->status = TID_NEED_RECON;
+			spin_unlock(&tcon->tc_lock);
 		}
 		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
+			spin_lock(&ses->tcon_ipc->tc_lock);
 			ses->tcon_ipc->status = TID_NEED_RECON;
+			spin_unlock(&ses->tcon_ipc->tc_lock);
 		}
-
-next_session:
-		spin_unlock(&ses->chan_lock);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 }
@@ -3653,11 +3664,19 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 
 	/* only send once per connect */
 	spin_lock(&server->srv_lock);
-	if (!server->ops->need_neg(server) ||
+	if (server->tcpStatus != CifsGood &&
+	    server->tcpStatus != CifsNew &&
 	    server->tcpStatus != CifsNeedNegotiate) {
+		spin_unlock(&server->srv_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (!server->ops->need_neg(server) &&
+	    server->tcpStatus == CifsGood) {
 		spin_unlock(&server->srv_lock);
 		return 0;
 	}
+
 	server->tcpStatus = CifsInNegotiate;
 	spin_unlock(&server->srv_lock);
 
@@ -3691,23 +3710,28 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	bool is_binding = false;
 
 	spin_lock(&ses->ses_lock);
+	cifs_dbg(FYI, "%s: channel connect bitmap: 0x%lx\n",
+		 __func__, ses->chans_need_reconnect);
+
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
 		spin_unlock(&ses->ses_lock);
-		return 0;
+		return -EHOSTDOWN;
 	}
 
 	/* only send once per connect */
 	spin_lock(&ses->chan_lock);
-	if (CIFS_ALL_CHANS_GOOD(ses) ||
-	    cifs_chan_in_reconnect(ses, server)) {
+	if (CIFS_ALL_CHANS_GOOD(ses)) {
+		if (ses->ses_status == SES_NEED_RECON)
+			ses->ses_status = SES_GOOD;
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 		return 0;
 	}
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
+
 	cifs_chan_set_in_reconnect(ses, server);
+	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
 	spin_unlock(&ses->chan_lock);
 
 	if (!is_binding)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index caeb92a69b5f..a9fb95b7ef82 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -203,6 +203,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 	spin_unlock(&server->srv_lock);
 
+again:
 	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
 	if (rc)
 		return rc;
@@ -221,6 +222,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	nls_codepage = load_nls_default();
 
+	mutex_lock(&ses->session_mutex);
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
 	 * and the server never sends an answer the socket will be closed
@@ -229,6 +231,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
 		spin_unlock(&server->srv_lock);
+		mutex_unlock(&ses->session_mutex);
+
+		if (tcon->retry)
+			goto again;
+
 		rc = -EHOSTDOWN;
 		goto out;
 	}
@@ -238,19 +245,22 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * need to prevent multiple threads trying to simultaneously
 	 * reconnect the same SMB session
 	 */
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	if (!cifs_chan_needs_reconnect(ses, server)) {
+	if (!cifs_chan_needs_reconnect(ses, server) &&
+	    ses->ses_status == SES_GOOD) {
 		spin_unlock(&ses->chan_lock);
-
+		spin_unlock(&ses->ses_lock);
 		/* this means that we only need to tree connect */
 		if (tcon->need_reconnect)
 			goto skip_sess_setup;
 
+		mutex_unlock(&ses->session_mutex);
 		goto out;
 	}
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
-	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (!rc) {
 		rc = cifs_setup_session(0, ses, server, nls_codepage);
@@ -266,10 +276,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		mutex_unlock(&ses->session_mutex);
 		goto out;
 	}
-	mutex_unlock(&ses->session_mutex);
 
 skip_sess_setup:
-	mutex_lock(&ses->session_mutex);
 	if (!tcon->need_reconnect) {
 		mutex_unlock(&ses->session_mutex);
 		goto out;
@@ -284,7 +292,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc) {
 		/* If sess reconnected but tcon didn't, something strange ... */
-		pr_warn_once("reconnect tcon failed rc = %d\n", rc);
+		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
 		goto out;
 	}
 
@@ -1256,9 +1264,9 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	if (rc)
 		return rc;
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	if (is_binding) {
 		req->hdr.SessionId = cpu_to_le64(ses->Suid);
@@ -1416,9 +1424,9 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep session key if binding */
 	if (!is_binding) {
@@ -1542,9 +1550,9 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep existing ses id and flags if binding */
 	if (!is_binding) {
@@ -1610,9 +1618,9 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep existing ses id and flags if binding */
 	if (!is_binding) {
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index d827b7547ffa..790acf65a092 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -81,6 +81,7 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	struct cifs_ses *ses = NULL;
 	int i;
 	int rc = 0;
+	bool is_binding = false;
 
 	spin_lock(&cifs_tcp_ses_lock);
 
@@ -97,9 +98,12 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	goto out;
 
 found:
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	if (cifs_chan_needs_reconnect(ses, server) &&
-	    !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
+
+	is_binding = (cifs_chan_needs_reconnect(ses, server) &&
+		      ses->ses_status == SES_GOOD);
+	if (is_binding) {
 		/*
 		 * If we are in the process of binding a new channel
 		 * to an existing session, use the master connection
@@ -107,6 +111,7 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 		 */
 		memcpy(key, ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
 		goto out;
 	}
 
@@ -119,10 +124,12 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 		if (chan->server == server) {
 			memcpy(key, chan->signkey, SMB3_SIGN_KEY_SIZE);
 			spin_unlock(&ses->chan_lock);
+			spin_unlock(&ses->ses_lock);
 			goto out;
 		}
 	}
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
 	cifs_dbg(VFS,
 		 "%s: Could not find channel signing key for session 0x%llx\n",
@@ -392,11 +399,15 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	bool is_binding = false;
 	int chan_index = 0;
 
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
+	is_binding = (cifs_chan_needs_reconnect(ses, server) &&
+		      ses->ses_status == SES_GOOD);
+
 	chan_index = cifs_ses_get_chan_index(ses, server);
 	/* TODO: introduce ref counting for channels when the can be freed */
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
 	/*
 	 * All channels use the same encryption/decryption keys but

