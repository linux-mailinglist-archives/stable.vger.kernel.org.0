Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C414A8D50
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354142AbiBCUaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:30:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354121AbiBCUaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1242761A94;
        Thu,  3 Feb 2022 20:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E583C340EF;
        Thu,  3 Feb 2022 20:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920203;
        bh=HXnNm6mwzS+bCFc9d1VT6vJ6HYKUrgR+hVfGKlNwGIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJcKf82+kNCQ0lZdlq0/KngmfiWylQHCXfpyg1o4GqwX/giIayzdD7j/U2VKLB6bG
         jX77SWE3HtWH6vAdXfCaoWdzDA4EKWAEySGyhYAhTnGR6oR+kOgsXLZFsWi0Wx/Hew
         bQbpYUz0sLc0il1Ao2R8KqAabFRParXx+NmlDsnPUnibQja1oN++OuTGzzq3NHPxFH
         xDp7s4ilBqC7v8+e7xwmmLCuI4uNFhLHZ6tNtmiwVJphpF9LoAdvVxHdKfpiXB9eLg
         +KJb3vy+tgNyi7LEAukYlNuY+0ilXNsbH4n/ETjBhjjUxyJ7ObN/Bh8mL9Zl+B7Erc
         VB59NDKGszE6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 10/52] NFSv4 handle port presence in fs_location server string
Date:   Thu,  3 Feb 2022 15:29:04 -0500
Message-Id: <20220203202947.2304-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit a8d54baba7c65db2d3278873def61f8d3753d766 ]

An fs_location attribute returns a string that can be ipv4, ipv6,
or DNS name. An ip location can have a port appended to it and if
no port is present a default port needs to be set. If rpc_pton()
fails to parse, try calling rpc_uaddr2socaddr() that can convert
an universal address.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h       |  2 +-
 fs/nfs/nfs4namespace.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 734ac09becf73..85c5d08dfa9cc 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -281,7 +281,7 @@ int nfs4_submount(struct fs_context *, struct nfs_server *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
 size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
-			     size_t salen, struct net *net);
+			     size_t salen, struct net *net, int port);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_async_handle_error(struct rpc_task *task,
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index f1ed4f60a7f33..3680c8da510c9 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -165,15 +165,20 @@ static int nfs4_validate_fspath(struct dentry *dentry,
 }
 
 size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
-			     size_t salen, struct net *net)
+			     size_t salen, struct net *net, int port)
 {
 	ssize_t ret;
 
 	ret = rpc_pton(net, string, len, sa, salen);
 	if (ret == 0) {
-		ret = nfs_dns_resolve_name(net, string, len, sa, salen);
-		if (ret < 0)
-			ret = 0;
+		ret = rpc_uaddr2sockaddr(net, string, len, sa, salen);
+		if (ret == 0) {
+			ret = nfs_dns_resolve_name(net, string, len, sa, salen);
+			if (ret < 0)
+				ret = 0;
+		}
+	} else if (port) {
+		rpc_set_port(sa, port);
 	}
 	return ret;
 }
@@ -328,7 +333,7 @@ static int try_location(struct fs_context *fc,
 			nfs_parse_server_name(buf->data, buf->len,
 					      &ctx->nfs_server.address,
 					      sizeof(ctx->nfs_server._address),
-					      fc->net_ns);
+					      fc->net_ns, 0);
 		if (ctx->nfs_server.addrlen == 0)
 			continue;
 
@@ -496,7 +501,7 @@ static int nfs4_try_replacing_one_location(struct nfs_server *server,
 			continue;
 
 		salen = nfs_parse_server_name(buf->data, buf->len,
-						sap, addr_bufsize, net);
+						sap, addr_bufsize, net, 0);
 		if (salen == 0)
 			continue;
 		rpc_set_port(sap, NFS_PORT);
-- 
2.34.1

