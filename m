Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0F4B474E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245354AbiBNJrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245660AbiBNJqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C9F717BE;
        Mon, 14 Feb 2022 01:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE60C6102D;
        Mon, 14 Feb 2022 09:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE0C340E9;
        Mon, 14 Feb 2022 09:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831557;
        bh=ktM89XCjdX4piqpIJRwOY3wrxDBa/THTYrXLVyRKYCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ti2Fu8ntUg2ai2JOP4E2M/H2w3+NFFSRVXajq6uFwaRmUeThGRdDM0z+Wqn1DzWjf
         p6FVQ6vmdi3qT2NR9gApGAIoVDW3tG6KdJhIv5VvMADR8RRFGAQ+diG9Bl+DCTTRVS
         fP0rCkA4dUl9kQ6COQP1gbdHM1LNGkt58tZi1p/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/116] NFSv4 handle port presence in fs_location server string
Date:   Mon, 14 Feb 2022 10:25:19 +0100
Message-Id: <20220214092459.376263730@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



