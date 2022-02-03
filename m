Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0D74A8D4F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354138AbiBCUaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:30:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33054 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354117AbiBCUaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 332A7B835A7;
        Thu,  3 Feb 2022 20:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23793C340F0;
        Thu,  3 Feb 2022 20:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920202;
        bh=01qhbpbzi9zTKTLBiqQl76Ns3a+R6Qym8QX6U2G65A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYRjpWLbzP21Fayc2kW5+daD+eesGXl6q91baqGBTFBASizuetMpieDzPBH6MuSR3
         YcRLdVQ8dA8YoCDWWZOYMmxqAW/gebe0C6SiNw5L1z0ixCBeL6fH/K9DwPb64ZwbUP
         uNxfUtf724KSa7pU1RAxTDFR5HOlCWkogfIVGVQas+TTLdItF5vvENy+3Cf8FgUAoG
         R9rjxEnsyoWSxmgqUKj3Ekz6vuU5Puh7pq5xOR2JY2h38gdK/CenbnLxymQj4agCii
         Wx4BsCcYKKgpz7vOYdXScVMiN4CJAWZnvDZ9Jcdv7hep8I3pbBv2H8xVn4vojND4Cc
         Qjw0eFxYZgEcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/52] NFSv4 expose nfs_parse_server_name function
Date:   Thu,  3 Feb 2022 15:29:03 -0500
Message-Id: <20220203202947.2304-9-sashal@kernel.org>
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

[ Upstream commit f5b27cc6761e27ee6387a24df1a99ca77b360fea ]

Make nfs_parse_server_name available outside of nfs4namespace.c.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h       | 3 ++-
 fs/nfs/nfs4namespace.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 2402a3d8ba997..734ac09becf73 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -280,7 +280,8 @@ struct rpc_clnt *nfs4_negotiate_security(struct rpc_clnt *, struct inode *,
 int nfs4_submount(struct fs_context *, struct nfs_server *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
-
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_async_handle_error(struct rpc_task *task,
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 873342308dc0d..f1ed4f60a7f33 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -164,8 +164,8 @@ static int nfs4_validate_fspath(struct dentry *dentry,
 	return 0;
 }
 
-static size_t nfs_parse_server_name(char *string, size_t len,
-		struct sockaddr *sa, size_t salen, struct net *net)
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net)
 {
 	ssize_t ret;
 
-- 
2.34.1

