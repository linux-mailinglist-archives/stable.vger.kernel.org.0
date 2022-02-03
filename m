Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB644A8EA2
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiBCUio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38810 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354445AbiBCUgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A78B835B2;
        Thu,  3 Feb 2022 20:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E20C340E8;
        Thu,  3 Feb 2022 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920603;
        bh=NpZm3yFy3Z1UNqbMTXkFjMGIfCtrlF8R0qEN3T7AHQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4Vb2US30qd0XVuiU4aObVD5EFV2p/6Wcj3YPoit8MeeNZrsU66ZRPDk6iWLj6GF+
         qNcVXCnBNF1KEjDpB3oEnT/WwfMy2fS92PNU5zhfPwDnPeWsp5YBCBwgrsIPImOKSz
         9TnRIipCP2EfxcZtZmAV9Cx19bZezTIpDRLah+bD75dT+mPdURRLjlrKR5gLGbzH8Y
         IxzhQOc7BjE/z4sT1aFTtluKy1wCUxTiNF1MlwRv2pCiFekdUXKe3U8Rhgyf64NDDQ
         Fl1ltFp3guaq43usbh5nomOMcdVDUP6XAnuRItiHQzMsBKely+fxqYFp5DzVz7VZRv
         yPM79VeIYme1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/9] NFSv4 expose nfs_parse_server_name function
Date:   Thu,  3 Feb 2022 15:36:30 -0500
Message-Id: <20220203203633.4685-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203633.4685-1-sashal@kernel.org>
References: <20220203203633.4685-1-sashal@kernel.org>
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
index 22cff39cca29a..c9ca2237c3fec 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -242,7 +242,8 @@ struct vfsmount *nfs4_submount(struct nfs_server *, struct dentry *,
 			       struct nfs_fh *, struct nfs_fattr *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
-
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_call_sync(struct rpc_clnt *, struct nfs_server *,
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 8c3f327d858d5..b36361ca0d36b 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -121,8 +121,8 @@ static int nfs4_validate_fspath(struct dentry *dentry,
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

