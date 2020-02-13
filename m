Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3115C5B7
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgBMPYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgBMPYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:12 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270AC246B8;
        Thu, 13 Feb 2020 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607451;
        bh=yRnA6JdzSxs+BXzyZy2xTQIqsLKnilJe/TavlJFPZ/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlVuJeG+RsefnrF9AeHYRDBiaOvTIYtUH8jgNP5e/gSSHEP12itGthqToxcKpPyhc
         FohIW9UyEiraXMGIqk3fAqA/jWHKEIWM3wyGjBAteJoZG500nyisT25n4cJZu3JK/B
         mf88udR6/wGrRNVlCRh4HXaYKfY8Pi1iL//kJ1tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/116] NFS: Fix bool initialization/comparison
Date:   Thu, 13 Feb 2020 07:20:22 -0800
Message-Id: <20200213151913.139663516@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

[ Upstream commit 6089dd0d731028531fb1148be9fd33274ff90da4 ]

Bool initializations should use true and false. Bool tests don't need
comparisons.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c |  2 +-
 fs/nfs/dir.c           | 10 +++++-----
 fs/nfs/nfs4client.c    |  2 +-
 fs/nfs/pnfs.c          |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 9d7537446260b..0d4a56c77a1a9 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -419,7 +419,7 @@ static bool referring_call_exists(struct nfs_client *clp,
 				  uint32_t nrclists,
 				  struct referring_call_list *rclists)
 {
-	bool status = 0;
+	bool status = false;
 	int i, j;
 	struct nfs4_session *session;
 	struct nfs4_slot_table *tbl;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5936c54ac5fdb..2c6e64dce2bdb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -289,7 +289,7 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *array, nfs_readdir_descri
 	desc->cache_entry_index = index;
 	return 0;
 out_eof:
-	desc->eof = 1;
+	desc->eof = true;
 	return -EBADCOOKIE;
 }
 
@@ -343,7 +343,7 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
 	if (array->eof_index >= 0) {
 		status = -EBADCOOKIE;
 		if (*desc->dir_cookie == array->last_cookie)
-			desc->eof = 1;
+			desc->eof = true;
 	}
 out:
 	return status;
@@ -812,7 +812,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 		ent = &array->array[i];
 		if (!dir_emit(desc->ctx, ent->string.name, ent->string.len,
 		    nfs_compat_user_ino64(ent->ino), ent->d_type)) {
-			desc->eof = 1;
+			desc->eof = true;
 			break;
 		}
 		desc->ctx->pos++;
@@ -824,7 +824,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 			ctx->duped = 1;
 	}
 	if (array->eof_index >= 0)
-		desc->eof = 1;
+		desc->eof = true;
 
 	nfs_readdir_release_array(desc->page);
 out:
@@ -925,7 +925,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 		if (res == -EBADCOOKIE) {
 			res = 0;
 			/* This means either end of directory */
-			if (*desc->dir_cookie && desc->eof == 0) {
+			if (*desc->dir_cookie && !desc->eof) {
 				/* Or that the server has 'lost' a cookie */
 				res = uncached_readdir(desc);
 				if (res == 0)
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 1ec6dd4f3e2e4..3ee60c5332179 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -847,7 +847,7 @@ nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
 
 	spin_lock(&nn->nfs_client_lock);
 	list_for_each_entry(clp, &nn->nfs_client_list, cl_share_link) {
-		if (nfs4_cb_match_client(addr, clp, minorversion) == false)
+		if (!nfs4_cb_match_client(addr, clp, minorversion))
 			continue;
 
 		if (!nfs4_has_session(clp))
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 0e008db16b169..c3abf92adfb7d 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1436,7 +1436,7 @@ pnfs_lseg_range_match(const struct pnfs_layout_range *ls_range,
 	if ((range->iomode == IOMODE_RW &&
 	     ls_range->iomode != IOMODE_RW) ||
 	    (range->iomode != ls_range->iomode &&
-	     strict_iomode == true) ||
+	     strict_iomode) ||
 	    !pnfs_lseg_range_intersecting(ls_range, range))
 		return 0;
 
-- 
2.20.1



