Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897E84A8F29
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiBCUmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356044AbiBCUk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:40:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B065C0613E3;
        Thu,  3 Feb 2022 12:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56FF360A77;
        Thu,  3 Feb 2022 20:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA6BC340F0;
        Thu,  3 Feb 2022 20:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920619;
        bh=J0oY2ELlrWXgd10fbeUVF1lyKQTWa7uQM3TycUZkb1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEUR+89R6QzFcM4YUA81VnO2Z5NO9sncV6j3LqwqBxND+kJup1ENdZsVncux7PbJM
         s5tGIx23CdtVIqiEYnHH5yxjbDs8WgVutJ6bHiLtA8fP53gEkQh2CfWviL+i/MXN93
         w0vurP2mNIWCPIxMcFaQr56w6jsA7EHBiG4U/CZhcH5t2G7RN6TYz4cyC/G77uoDTo
         QwDZmWnpsWNhXr1ELqKIbi4kOcJq7XBTQEqe2guUEriNz5hw7PGnwPeEXG1r6YLsmZ
         5v2OBg8wZoiDYV2I+Z/ZbEOVeYcMqarpu0WIoVSa1RVIpthr6WGtPaeNPhqa8GZ7lQ
         iHP7md/B03u+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/7] NFSv4 expose nfs_parse_server_name function
Date:   Thu,  3 Feb 2022 15:36:49 -0500
Message-Id: <20220203203651.5158-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203651.5158-1-sashal@kernel.org>
References: <20220203203651.5158-1-sashal@kernel.org>
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
index c719389381dc4..0b867d7c02992 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -241,7 +241,8 @@ struct vfsmount *nfs4_submount(struct nfs_server *, struct dentry *,
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
index d8b040bd9814d..2b1921bb5348b 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -120,8 +120,8 @@ static int nfs4_validate_fspath(struct dentry *dentry,
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

