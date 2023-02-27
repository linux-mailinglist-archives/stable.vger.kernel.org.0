Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A596A36F9
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjB0CGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjB0CFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A3293CF;
        Sun, 26 Feb 2023 18:05:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C26A4B80CB8;
        Mon, 27 Feb 2023 02:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF77C433EF;
        Mon, 27 Feb 2023 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463495;
        bh=aX33SRqerFUyiaj7L3wpdhPgq5nA9KLi7yJvCLV7lzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdUKH4qJl2Iy6WB74h7Q8vFzIUYGag9xmAHZ54uOwc2mM5eJvgPHpe4UnTaqLLhUD
         h5n7CZwB3LfYKWJky6xJnsgK/LgsEczoSdS7bKvnYkERqshhQio/kFkb/77gTXNnxo
         jAeySjh0Y/sXbq3IxcVgmnSgEpCm74nER2eyii3RY7WdKM6MtisU0SQu0fL6Z7A3rb
         DjSahzoV8yfFciiE2UIg+VXaZKIjKYDkiD2ayZJ0xBjbHHsXSULz8zycSlUqU3xV7O
         0oALQHMlR5VrTQjk20UQCy7glyuVQFVkB5y/dNzloV6qsYz17ffcUx7phBFW/HsxZa
         dj+oi1ChtSUxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.2 60/60] cifs: prevent data race in smb2_reconnect()
Date:   Sun, 26 Feb 2023 21:00:45 -0500
Message-Id: <20230227020045.1045105-60-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 3c0070f54b3128de498c2dd9934a21f0dd867111 ]

Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
to waiting the server to be reconnected in smb2_reconnect().  It is
set in cifs_tcp_ses_needs_reconnect() and protected by
TCP_Server_Info::srv_lock.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 119 +++++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c9ffa921e6f6..2d5c3df2277d4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -139,6 +139,66 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
+static int wait_for_server_reconnect(struct TCP_Server_Info *server,
+				     __le16 smb2_command, bool retry)
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
+	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+	 * here since they are implicitly done when session drops.
+	 */
+	switch (smb2_command) {
+	/*
+	 * BB Should we keep oplock break and add flush to exceptions?
+	 */
+	case SMB2_TREE_DISCONNECT:
+	case SMB2_CANCEL:
+	case SMB2_CLOSE:
+	case SMB2_OPLOCK_BREAK:
+		return -EAGAIN;
+	}
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
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
@@ -146,7 +206,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
-	int retries;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -184,61 +243,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
-	ses = tcon->ses;
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
-		/*
-		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-		 * here since they are implicitly done when session drops.
-		 */
-		switch (smb2_command) {
-		/*
-		 * BB Should we keep oplock break and add flush to exceptions?
-		 */
-		case SMB2_TREE_DISCONNECT:
-		case SMB2_CANCEL:
-		case SMB2_CLOSE:
-		case SMB2_OPLOCK_BREAK:
-			return -EAGAIN;
-		}
-
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
+	rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
+	if (rc)
+		return rc;
 
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
+	ses = tcon->ses;
 
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
-- 
2.39.0

