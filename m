Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF5D15C742
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgBMQIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbgBMPXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:01 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F9424699;
        Thu, 13 Feb 2020 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607381;
        bh=mI6jafeU6zIiuC+1CW1GrQ6YSAm34TlC8SVlyGH4GoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMzqvqBtZN5jmGrO2OdiKU1cnryTB7EZxdEMjEyMdyZv+xwIiF4yg3Ldn4NKchEch
         DrmaFxHYk+CiI0mJtbqduwpTG6zhcTBiQaiHQ/06z/W1mQrr69dC5AWGX2o05YPhs9
         +01bJwIOgLREN0JIKl0V1UuwbXamZPCsDcwE5f8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 61/91] NFS: Fix bool initialization/comparison
Date:   Thu, 13 Feb 2020 07:20:18 -0800
Message-Id: <20200213151845.653541388@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
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
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 807eb6ef4f916..6f4f68967c310 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -368,7 +368,7 @@ static bool referring_call_exists(struct nfs_client *clp,
 				  uint32_t nrclists,
 				  struct referring_call_list *rclists)
 {
-	bool status = 0;
+	bool status = false;
 	int i, j;
 	struct nfs4_session *session;
 	struct nfs4_slot_table *tbl;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5fae07590c3a9..e2927aeb092d0 100644
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
@@ -791,7 +791,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 		ent = &array->array[i];
 		if (!dir_emit(desc->ctx, ent->string.name, ent->string.len,
 		    nfs_compat_user_ino64(ent->ino), ent->d_type)) {
-			desc->eof = 1;
+			desc->eof = true;
 			break;
 		}
 		desc->ctx->pos++;
@@ -803,7 +803,7 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 			ctx->duped = 1;
 	}
 	if (array->eof_index >= 0)
-		desc->eof = 1;
+		desc->eof = true;
 
 	nfs_readdir_release_array(desc->page);
 out:
@@ -905,7 +905,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 		if (res == -EBADCOOKIE) {
 			res = 0;
 			/* This means either end of directory */
-			if (*desc->dir_cookie && desc->eof == 0) {
+			if (*desc->dir_cookie && !desc->eof) {
 				/* Or that the server has 'lost' a cookie */
 				res = uncached_readdir(desc);
 				if (res == 0)
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index dac20f31f01f8..92895f41d9a0f 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -751,7 +751,7 @@ nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
 
 	spin_lock(&nn->nfs_client_lock);
 	list_for_each_entry(clp, &nn->nfs_client_list, cl_share_link) {
-		if (nfs4_cb_match_client(addr, clp, minorversion) == false)
+		if (!nfs4_cb_match_client(addr, clp, minorversion))
 			continue;
 
 		if (!nfs4_has_session(clp))
-- 
2.20.1



