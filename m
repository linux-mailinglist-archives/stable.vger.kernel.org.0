Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58E3CE19A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbhGSP0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348129AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE20E61450;
        Mon, 19 Jul 2021 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710548;
        bh=2ww6Zt5Z9tH5u7Ztkfep/h2tNTvSKSisSCOStG8SVPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIGXvppcXa1QmvFWtCOoTMD2D0zrOVl7J07md5tQONjvEk4FOg84Zdi08Df64a8rI
         P78O5VYfVkHmKPj6O2wkZgUz79iucjKOFeRaMjgfsD4LbKO0c/DB1o0Af2dUkpJvNC
         7tpUhLTZHojGkenO+f+0gvJCgOR5wihrUUi+zvdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 002/351] cifs: handle reconnect of tcon when there is no cached dfs referral
Date:   Mon, 19 Jul 2021 16:49:08 +0200
Message-Id: <20210719144944.618700919@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 507345b5ae6a57b7ecd7550ff39282ed20de7b8d upstream.

When there is no cached DFS referral of tcon->dfs_path, then reconnect
to same share.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4155,7 +4155,8 @@ int cifs_tree_connect(const unsigned int
 	if (!tree)
 		return -ENOMEM;
 
-	if (!tcon->dfs_path) {
+	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
+	if (!tcon->dfs_path || dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl)) {
 		if (tcon->ipc) {
 			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
@@ -4165,9 +4166,6 @@ int cifs_tree_connect(const unsigned int
 		goto out;
 	}
 
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl);
-	if (rc)
-		goto out;
 	isroot = ref.server_type == DFS_TYPE_ROOT;
 	free_dfs_info_param(&ref);
 


