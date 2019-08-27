Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18289E12A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbfH0ICo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbfH0ICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59E71206BA;
        Tue, 27 Aug 2019 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892962;
        bh=XggU+zeG8dIlkxxfLnrwanGtmdueLn1I1rN1AMZpw3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B93Lfs981GAUPRhdb2zoJnfsjKHfPPTE0dSyMTK1Fo+YKeLhYJdEpjEIIC98MCe5z
         WMjY/MnRN683+tlFJDQVayjhxTHznjjKcrNhNhQxicN8AnsZqq3Y0RjtKxycbAGRq9
         6HFTYOiP6fZQY+P0BiiUd91jWsTZ4LTPH3jWBrhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Steve Dickson <steved@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 076/162] NFS: Fix regression whereby fscache errors are appearing on nofsc mounts
Date:   Tue, 27 Aug 2019 09:50:04 +0200
Message-Id: <20190827072740.760244501@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 53507aa96b0b6..3800ab6f08fa8 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -114,6 +114,10 @@ void nfs_fscache_get_super_cookie(struct super_block *sb, const char *uniq, int
 	struct rb_node **p, *parent;
 	int diff;
 
+	nfss->fscache_key = NULL;
+	nfss->fscache = NULL;
+	if (!(nfss->options & NFS_OPTION_FSCACHE))
+		return;
 	if (!uniq) {
 		uniq = "";
 		ulen = 1;
@@ -226,10 +230,11 @@ void nfs_fscache_release_super_cookie(struct super_block *sb)
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
index 25a75e40d91d9..ad041cfbf9ec0 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -182,7 +182,7 @@ static inline void nfs_fscache_wait_on_invalidate(struct inode *inode)
  */
 static inline const char *nfs_server_fscache_state(struct nfs_server *server)
 {
-	if (server->fscache && (server->options & NFS_OPTION_FSCACHE))
+	if (server->fscache)
 		return "yes";
 	return "no ";
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f88ddac2dcdf3..4d375b517eda8 100644
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



