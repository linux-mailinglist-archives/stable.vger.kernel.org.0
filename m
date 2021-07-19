Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3A3CE429
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhGSPmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhGSPg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C58A61026;
        Mon, 19 Jul 2021 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711457;
        bh=/W2RctiyWho+2IWMPdcHXQXviv+W/936yAW4DjQGAHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6c+da822t9fmsDQYtYcLsTAXiudMMcGkx+j6y97PiuS3eLZYcwl8EVYHqx/pAxwg
         w9IJtwA3gUddlK/+4LJq1KkYBF8hLUuHUpq9ctWQMkuzhn+UoKg2TDadxrceKrwtRc
         gdywwpncgpU6pLikSRY1pOikWXELk85G5PbaKvMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 002/292] cifs: handle reconnect of tcon when there is no cached dfs referral
Date:   Mon, 19 Jul 2021 16:51:04 +0200
Message-Id: <20210719144942.595068898@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
@@ -4185,7 +4185,8 @@ int cifs_tree_connect(const unsigned int
 	if (!tree)
 		return -ENOMEM;
 
-	if (!tcon->dfs_path) {
+	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
+	if (!tcon->dfs_path || dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl)) {
 		if (tcon->ipc) {
 			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
@@ -4195,9 +4196,6 @@ int cifs_tree_connect(const unsigned int
 		goto out;
 	}
 
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl);
-	if (rc)
-		goto out;
 	isroot = ref.server_type == DFS_TYPE_ROOT;
 	free_dfs_info_param(&ref);
 


