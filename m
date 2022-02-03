Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BECD4A8ED3
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbiBCUjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355075AbiBCUhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:37:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A086AC061749;
        Thu,  3 Feb 2022 12:35:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D6161B1F;
        Thu,  3 Feb 2022 20:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A09C340EF;
        Thu,  3 Feb 2022 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920499;
        bh=ktM89XCjdX4piqpIJRwOY3wrxDBa/THTYrXLVyRKYCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4JsDMKcy3g1HoR0Vs6o83tq8VNpWn3dBZ/q6rzxkj4CE5Ag/6r4HWuYqX0pJeMKC
         UDBgfS+05WLPfzNNg70v18+YnDQHKdNv5huX6xiZ8g0FzCN7oxRNXxL8wWXNvXe4Kg
         FLbR3SWJm9ZJ/XoHm95xHh/R+Ss4litd4jIpRHb6yWs0yRIcvBPvTRk/2XeaepA8t/
         2p6GQec+FiufDB+/YMS2PBbctHfoc+zx0zgCxVBeOWJksmJk+UkEpvqpGbn512EEuS
         3wVLoX29Ny24hKoPoB56BrrnP1p1/7eEYuGSl8ldRl/yI73TAv6oovnQyprVTJiYOL
         8cHqd3tVP11Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/25] NFSv4 handle port presence in fs_location server string
Date:   Thu,  3 Feb 2022 15:34:29 -0500
Message-Id: <20220203203447.3570-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
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
index de71cf89a24ee..6d916563356ef 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -282,7 +282,7 @@ int nfs4_submount(struct fs_context *, struct nfs_server *);
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

