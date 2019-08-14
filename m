Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156EF8C69E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfHNCRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbfHNCRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395A6216F4;
        Wed, 14 Aug 2019 02:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749023;
        bh=T+bCEsE5VY9kB7z/mO4FDutJmkT99Aa9hwOeiWd+EkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM1cfL4bGGdRySlDCZYi0uV7Y0nNkKLVet81q9OMxjZJTX/ss4YI2hGqDDYAHCjcS
         KA7g3wn7C49SBzYI2brIDtFqtg7qJ7bNcJfvnZu51NyI3IwNbz1lGX2iQksZcSdmVb
         aazDttQTAKOwn/mtcZ8KfrU92GzDn44Ear5i3tlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Steve Dickson <steved@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 41/68] NFS: Fix regression whereby fscache errors are appearing on 'nofsc' mounts
Date:   Tue, 13 Aug 2019 22:15:19 -0400
Message-Id: <20190814021548.16001-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dea1bb35c5f35e0577cfc61f79261d80b8715221 ]

People are reporing seeing fscache errors being reported concerning
duplicate cookies even in cases where they are not setting up fscache
at all. The rule needs to be that if fscache is not enabled, then it
should have no side effects at all.

To ensure this is the case, we disable fscache completely on all superblocks
for which the 'fsc' mount option was not set. In order to avoid issues
with '-oremount', we also disable the ability to turn fscache on via
remount.

Fixes: f1fe29b4a02d ("NFS: Use i_writecount to control whether...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200145
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Steve Dickson <steved@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache.c | 7 ++++++-
 fs/nfs/fscache.h | 2 +-
 fs/nfs/super.c   | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 4dc887813c71d..a7bc4e0494f92 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -118,6 +118,10 @@ void nfs_fscache_get_super_cookie(struct super_block *sb, const char *uniq, int
 	struct rb_node **p, *parent;
 	int diff;
 
+	nfss->fscache_key = NULL;
+	nfss->fscache = NULL;
+	if (!(nfss->options & NFS_OPTION_FSCACHE))
+		return;
 	if (!uniq) {
 		uniq = "";
 		ulen = 1;
@@ -230,10 +234,11 @@ void nfs_fscache_release_super_cookie(struct super_block *sb)
 void nfs_fscache_init_inode(struct inode *inode)
 {
 	struct nfs_fscache_inode_auxdata auxdata;
+	struct nfs_server *nfss = NFS_SERVER(inode);
 	struct nfs_inode *nfsi = NFS_I(inode);
 
 	nfsi->fscache = NULL;
-	if (!S_ISREG(inode->i_mode))
+	if (!(nfss->fscache && S_ISREG(inode->i_mode)))
 		return;
 
 	memset(&auxdata, 0, sizeof(auxdata));
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 161ba2edb9d04..6363ea9568581 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -186,7 +186,7 @@ static inline void nfs_fscache_wait_on_invalidate(struct inode *inode)
  */
 static inline const char *nfs_server_fscache_state(struct nfs_server *server)
 {
-	if (server->fscache && (server->options & NFS_OPTION_FSCACHE))
+	if (server->fscache)
 		return "yes";
 	return "no ";
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6df9b85caf205..d90efdea9fbd6 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2239,6 +2239,7 @@ nfs_compare_remount_data(struct nfs_server *nfss,
 	    data->acdirmin != nfss->acdirmin / HZ ||
 	    data->acdirmax != nfss->acdirmax / HZ ||
 	    data->timeo != (10U * nfss->client->cl_timeout->to_initval / HZ) ||
+	    (data->options & NFS_OPTION_FSCACHE) != (nfss->options & NFS_OPTION_FSCACHE) ||
 	    data->nfs_server.port != nfss->port ||
 	    data->nfs_server.addrlen != nfss->nfs_client->cl_addrlen ||
 	    !rpc_cmp_addr((struct sockaddr *)&data->nfs_server.address,
-- 
2.20.1

