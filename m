Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865155418F7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiFGVS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380740AbiFGVQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C90414B2CD;
        Tue,  7 Jun 2022 11:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24DB86159D;
        Tue,  7 Jun 2022 18:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1CAC385A5;
        Tue,  7 Jun 2022 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628221;
        bh=+Eu7a/01Gm0vvkEXgIQO9gAsjJXm9bL/OnGxnrNXiSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtjCq7GiMDxGfYpzMh4P/dQsrrOcsbx69a0CmEd+pGu79qmoRZwb/l6uJrzmxDvp5
         fOuLJjzgY5cY6j/PhH82D5zNSqm6n/dcr1hTPAURpj1aQWfuEUXHoZpz1mzq4ZIjkJ
         VKaqMRx/nZyQVLQc+OjrazDh8o5OwCLQfA1gievw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 251/879] cifs: do not use tcpStatus after negotiate completes
Date:   Tue,  7 Jun 2022 18:56:09 +0200
Message-Id: <20220607165010.135030627@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 1a6a41d4cedd9b302e2200e6f0e3c44dbbe13689 ]

Recent changes to multichannel to allow channel reconnects to
work in parallel and independent of each other did so by
making use of tcpStatus for the connection, and status for the
session. However, this did not take into account the multiuser
scenario, where same connection is used by multiple connections.

However, tcpStatus should be tracked only till the end of
negotiate exchange, and not used for session setup. This change
fixes this.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c       | 23 +++++++++++------------
 fs/cifs/smb2pdu.c       |  3 ++-
 fs/cifs/smb2transport.c |  3 ++-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b28b1ff39fed..aa2d4c49e2a5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3956,7 +3956,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	if (rc == 0) {
 		spin_lock(&cifs_tcp_ses_lock);
 		if (server->tcpStatus == CifsInNegotiate)
-			server->tcpStatus = CifsNeedSessSetup;
+			server->tcpStatus = CifsGood;
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -3979,19 +3979,18 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	bool is_binding = false;
 
 	/* only send once per connect */
+	spin_lock(&ses->chan_lock);
+	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
+	spin_unlock(&ses->chan_lock);
+
 	spin_lock(&cifs_tcp_ses_lock);
-	if ((server->tcpStatus != CifsNeedSessSetup) &&
-	    (ses->status == CifsGood)) {
+	if (ses->status == CifsExiting) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
-	server->tcpStatus = CifsInSessSetup;
+	ses->status = CifsInSessSetup;
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
-
 	if (!is_binding) {
 		ses->capabilities = server->capabilities;
 		if (!linuxExtEnabled)
@@ -4015,13 +4014,13 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 		spin_lock(&cifs_tcp_ses_lock);
-		if (server->tcpStatus == CifsInSessSetup)
-			server->tcpStatus = CifsNeedSessSetup;
+		if (ses->status == CifsInSessSetup)
+			ses->status = CifsNeedSessSetup;
 		spin_unlock(&cifs_tcp_ses_lock);
 	} else {
 		spin_lock(&cifs_tcp_ses_lock);
-		if (server->tcpStatus == CifsInSessSetup)
-			server->tcpStatus = CifsGood;
+		if (ses->status == CifsInSessSetup)
+			ses->status = CifsGood;
 		/* Even if one channel is active, session is in good state */
 		ses->status = CifsGood;
 		spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1b7ad0c09566..f5321a3500f3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3899,7 +3899,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "In echo request for conn_id %lld\n", server->conn_id);
 
 	spin_lock(&cifs_tcp_ses_lock);
-	if (server->tcpStatus == CifsNeedNegotiate) {
+	if (server->ops->need_neg &&
+	    server->ops->need_neg(server)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		/* No need to send echo on newly established connections */
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2af79093b78b..01b732641edb 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -641,7 +641,8 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if (!is_signed)
 		return 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	if (server->tcpStatus == CifsNeedNegotiate) {
+	if (server->ops->need_neg &&
+	    server->ops->need_neg(server)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
-- 
2.35.1



