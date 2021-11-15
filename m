Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60E245247C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353848AbhKPBjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241320AbhKOSb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C53632D2;
        Mon, 15 Nov 2021 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999120;
        bh=cNGNPRZo9efANS2M+9NmsUSmfBuu1DU1RRBAgezUS+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZMENFXvZBPRt3RaNFqSbvrINfQOw05XsGhMiqlOrEyvQg0FtBNu4u3dR9b5OVilD
         mdeUZZX/3xi1gMA00BtXy9avCzihFR1X9I72wxHwdp5nzUpQEbwfD27CqbaJj9PILv
         eKEAzd6oT4s8/12EpfZ2ueKq44cDpWEr99oEeqj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 184/849] cifs: To match file servers, make sure the server hostname matches
Date:   Mon, 15 Nov 2021 17:54:27 +0100
Message-Id: <20211115165426.400782546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 7be3248f313930ff3d3436d4e9ddbe9fccc1f541 upstream.

We generally rely on a bunch of factors to differentiate between servers.
For example, IP address, port etc.

For certain server types (like Azure), it is important to make sure
that the server hostname matches too, even if the both hostnames currently
resolve to the same IP address.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c    |   19 +++++++++++--------
 fs/cifs/fs_context.c |    8 ++++++++
 fs/cifs/fs_context.h |    1 +
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -795,7 +795,6 @@ static void clean_demultiplex_info(struc
 		 */
 	}
 
-	kfree(server->hostname);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1236,6 +1235,9 @@ static int match_server(struct TCP_Serve
 	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
 		return 0;
 
+	if (strcasecmp(server->hostname, ctx->server_hostname))
+		return 0;
+
 	if (!match_address(server, addr,
 			   (struct sockaddr *)&ctx->srcaddr))
 		return 0;
@@ -1337,6 +1339,7 @@ cifs_put_tcp_session(struct TCP_Server_I
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
+	kfree(server->hostname);
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
@@ -1362,14 +1365,15 @@ cifs_get_tcp_session(struct smb3_fs_cont
 		goto out_err;
 	}
 
+	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
+	if (!tcp_ses->hostname) {
+		rc = -ENOMEM;
+		goto out_err;
+	}
+
 	tcp_ses->ops = ctx->ops;
 	tcp_ses->vals = ctx->vals;
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
-	tcp_ses->hostname = extract_hostname(ctx->UNC);
-	if (IS_ERR(tcp_ses->hostname)) {
-		rc = PTR_ERR(tcp_ses->hostname);
-		goto out_err_crypto_release;
-	}
 
 	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
 	tcp_ses->noblockcnt = ctx->rootfs;
@@ -1498,8 +1502,7 @@ out_err_crypto_release:
 
 out_err:
 	if (tcp_ses) {
-		if (!IS_ERR(tcp_ses->hostname))
-			kfree(tcp_ses->hostname);
+		kfree(tcp_ses->hostname);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
 		kfree(tcp_ses);
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -332,6 +332,7 @@ smb3_fs_context_dup(struct smb3_fs_conte
 	DUP_CTX_STR(mount_options);
 	DUP_CTX_STR(username);
 	DUP_CTX_STR(password);
+	DUP_CTX_STR(server_hostname);
 	DUP_CTX_STR(UNC);
 	DUP_CTX_STR(source);
 	DUP_CTX_STR(domainname);
@@ -470,6 +471,11 @@ smb3_parse_devname(const char *devname,
 	if (!pos)
 		return -EINVAL;
 
+	/* record the server hostname */
+	ctx->server_hostname = kstrndup(devname + 2, pos - devname - 2, GFP_KERNEL);
+	if (!ctx->server_hostname)
+		return -ENOMEM;
+
 	/* skip past delimiter */
 	++pos;
 
@@ -1510,6 +1516,8 @@ smb3_cleanup_fs_context_contents(struct
 	ctx->username = NULL;
 	kfree_sensitive(ctx->password);
 	ctx->password = NULL;
+	kfree(ctx->server_hostname);
+	ctx->server_hostname = NULL;
 	kfree(ctx->UNC);
 	ctx->UNC = NULL;
 	kfree(ctx->source);
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -169,6 +169,7 @@ struct smb3_fs_context {
 	char *password;
 	char *domainname;
 	char *source;
+	char *server_hostname;
 	char *UNC;
 	char *nodename;
 	char *iocharset;  /* local code page for mapping to and from Unicode */


