Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672EA53A7C5
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353158AbiFAOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354525AbiFAOA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7652511A06;
        Wed,  1 Jun 2022 06:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5729AB81B07;
        Wed,  1 Jun 2022 13:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37F6C385A5;
        Wed,  1 Jun 2022 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091776;
        bh=0ao9rCtXzF+E1mhOIXSzAMgWHTlay5M9C7gXZhzBtCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5P/g24FoPmBzO63+/rkOSUwdOFEYOQrl3ea2BXlizbkSJ7b5yIqiVjCl+Wd6wPzR
         lvKIaw2idaa58VowoVkpHy7BHhEtuf5OC2eWBOg1T4PxmRVico6f9F6Yjw9fIaxq8P
         054fwl5RR0Vb/HUINO19dPEU8c02laArckEdrViPRHaUOky4ZfZzTYs5Kv3zj/imGq
         4C44XP/E0l0VBZtGtwhWutG5+4r+qLSSAgiUZ0qG+JDlWaPqPqh5+r6AoUuwxtoWrH
         xtr93NtuhRnOD8Ei4/dQHswePnVGqGmWmHDkCml4v2JyAj9PHu9DNWR95ji70YkmUT
         bZ2788vPQI70w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 46/48] cifs: do not use tcpStatus after negotiate completes
Date:   Wed,  1 Jun 2022 09:54:19 -0400
Message-Id: <20220601135421.2003328-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1ec77ebc71a0..9aae410a17f8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3962,7 +3962,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	if (rc == 0) {
 		spin_lock(&cifs_tcp_ses_lock);
 		if (server->tcpStatus == CifsInNegotiate)
-			server->tcpStatus = CifsNeedSessSetup;
+			server->tcpStatus = CifsGood;
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -3985,19 +3985,18 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
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
@@ -4021,13 +4020,13 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
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

