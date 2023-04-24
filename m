Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921256D4930
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjDCOff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjDCOff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDB3E5A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3778FB81CA3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB11C433EF;
        Mon,  3 Apr 2023 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532531;
        bh=kBuQ9V3uPHntYhEysWPZWq7DDkPBSNcLII4/gXUfQHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PK31z0q+LNke1g0AZ/BubSnh/ZQCSIWmiJbZIM57geIiPjxdiRTDyXV7HYLUFkWsL
         fC8GsyKEIlSCpNK3HKNKrlhhCRBjJx82WHL3RoCglhxSaC76VfRYx2UWLJRx7uuOJ4
         p3mVo1DDv8cy+sIw9QJKRf/6WQU+paU47vCtaLbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/181] cifs: prevent data race in cifs_reconnect_tcon()
Date:   Mon,  3 Apr 2023 16:07:18 +0200
Message-Id: <20230403140415.207634969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 1bcd548d935a33c6fc58331405eb1b82fd6150de ]

Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
to waiting the server to be reconnected in cifs_reconnect_tcon().  It
is set in cifs_tcp_ses_needs_reconnect() and protected by
TCP_Server_Info::srv_lock.

Create a new cifs_wait_for_server_reconnect() helper that can be used
by both SMB2+ and CIFS reconnect code.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/cifssmb.c   | 43 ++----------------------
 fs/cifs/misc.c      | 44 ++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 82 ++++++++++++---------------------------------
 4 files changed, 69 insertions(+), 101 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index bc4475f6c0827..98513f5af3f96 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -691,5 +691,6 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 
 struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
 void cifs_put_tcon_super(struct super_block *sb);
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
 
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6c6a7fc47f3e3..4bc6ba87baf4c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -70,7 +70,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
 	struct nls_table *nls_codepage;
-	int retries;
 
 	/*
 	 * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check for
@@ -98,45 +97,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&tcon->tc_lock);
 
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      10 * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			break;
-		}
-		spin_unlock(&server->srv_lock);
-
-		if (retries && --retries)
-			continue;
-
-		/*
-		 * on "soft" mounts we wait once. Hard mounts keep
-		 * retrying until process is killed or server comes
-		 * back on-line
-		 */
-		if (!tcon->retry) {
-			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
-			return -EHOSTDOWN;
-		}
-		retries = server->nr_targets;
-	}
+	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	if (rc)
+		return rc;
 
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4e54736a06996..832856aef4b7a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1382,3 +1382,47 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	return 0;
 }
 #endif
+
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
+{
+	int timeout = 10;
+	int rc;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsNeedReconnect) {
+		spin_unlock(&server->srv_lock);
+		return 0;
+	}
+	timeout *= server->nr_targets;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * Give demultiplex thread up to 10 seconds to each target available for
+	 * reconnect -- should be greater than cifs socket timeout which is 7
+	 * seconds.
+	 *
+	 * On "soft" mounts we wait once. Hard mounts keep retrying until
+	 * process is killed or server comes back on-line.
+	 */
+	do {
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      timeout * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+
+		/* are we still trying to reconnect? */
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsNeedReconnect) {
+			spin_unlock(&server->srv_lock);
+			return 0;
+		}
+		spin_unlock(&server->srv_lock);
+	} while (retry);
+
+	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
+	return -EHOSTDOWN;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6e6e44d8b4c79..83d04cd2f9df8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -139,66 +139,6 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
-static int wait_for_server_reconnect(struct TCP_Server_Info *server,
-				     __le16 smb2_command, bool retry)
-{
-	int timeout = 10;
-	int rc;
-
-	spin_lock(&server->srv_lock);
-	if (server->tcpStatus != CifsNeedReconnect) {
-		spin_unlock(&server->srv_lock);
-		return 0;
-	}
-	timeout *= server->nr_targets;
-	spin_unlock(&server->srv_lock);
-
-	/*
-	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-	 * here since they are implicitly done when session drops.
-	 */
-	switch (smb2_command) {
-	/*
-	 * BB Should we keep oplock break and add flush to exceptions?
-	 */
-	case SMB2_TREE_DISCONNECT:
-	case SMB2_CANCEL:
-	case SMB2_CLOSE:
-	case SMB2_OPLOCK_BREAK:
-		return -EAGAIN;
-	}
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 *
-	 * On "soft" mounts we wait once. Hard mounts keep retrying until
-	 * process is killed or server comes back on-line.
-	 */
-	do {
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      timeout * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			return 0;
-		}
-		spin_unlock(&server->srv_lock);
-	} while (retry);
-
-	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
-	return -EHOSTDOWN;
-}
-
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
@@ -239,7 +179,27 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
-	rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsNeedReconnect) {
+		/*
+		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+		 * here since they are implicitly done when session drops.
+		 */
+		switch (smb2_command) {
+		/*
+		 * BB Should we keep oplock break and add flush to exceptions?
+		 */
+		case SMB2_TREE_DISCONNECT:
+		case SMB2_CANCEL:
+		case SMB2_CLOSE:
+		case SMB2_OPLOCK_BREAK:
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock(&server->srv_lock);
+
+	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
 	if (rc)
 		return rc;
 
-- 
2.39.2



