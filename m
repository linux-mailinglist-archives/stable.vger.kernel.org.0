Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11785412CD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356959AbiFGTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358338AbiFGTwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EE5A309A;
        Tue,  7 Jun 2022 11:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A638B8237C;
        Tue,  7 Jun 2022 18:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B707C385A2;
        Tue,  7 Jun 2022 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626002;
        bh=4XUh0RFtbtG9XcppbCuMDevgZM/YDH7BjHgc9P/vsMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDjtNKYVKQakNor0trvNAW0lLIdfvmFAJ745jyu+JKxtk/zIimlTda5nwNsoQ2yc0
         gQuoryqA+dWh3Q1MJCXMjaK10QCIZFAUIpykpkuaO4XOWjmq4OmmtM5h6S7wvGapxB
         9Hj0doyN22aKQXGIDTpHYJYSmdPf4dF9p7d+hGzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 223/772] cifs: do not use tcpStatus after negotiate completes
Date:   Tue,  7 Jun 2022 18:56:55 +0200
Message-Id: <20220607164955.604763471@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 82ae3b84caf6..faf4587804d9 100644
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
index 1704fd358b85..55e6879ef18b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3904,7 +3904,8 @@ SMB2_echo(struct TCP_Server_Info *server)
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



