Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074164B4A51
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbiBNKC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiBNKBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB34E0CA;
        Mon, 14 Feb 2022 01:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C434DB80DC4;
        Mon, 14 Feb 2022 09:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4276C340EF;
        Mon, 14 Feb 2022 09:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832047;
        bh=SeiQ8rRzQyBwPXJWscgWn7Gf9uDRWBYWJf02DAfTknA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcg9N0ewWpdO6sI94FuBbH1VwDPFSFEN0+zkmc4E+3ZxILMLiaUMQwRrgIZrBkZU2
         ey+tYDxZY/wQTytYsU0DEHSwG+FsoIH+kHb7FLnvtGTAJl7P46T2YRYDlG/Rooucso
         xzxh5fx9GZeMIawuu5fPVxHy0ILmBrgUta8tmZcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/172] NFSv4 handle port presence in fs_location server string
Date:   Mon, 14 Feb 2022 10:24:49 +0100
Message-Id: <20220214092507.476379392@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index 0eb8e5d2ec395..f8672a34fd635 100644
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



