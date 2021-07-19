Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDD3CE01A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbhGSPNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345657AbhGSPMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5C36128D;
        Mon, 19 Jul 2021 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709966;
        bh=DN12DoBl/MGtiLQsU+mZ80hhRkf98LVSc3dzCI7ikwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuK4x8aEKsLbjx7tJiTPLvTjAFBGumP1VumnfPNjRWwL/se4ETCBWdmmubihFWNBv
         AJYQW7lY5tZlBlNkORgPP7cBhffiitNk92OxneATt6EA//BvioWm57MnD1Jijp+JbR
         ZbEmT+eYj8sbepmjtPupf3PVAciKZNjKvD/8n1DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 002/243] cifs: handle reconnect of tcon when there is no cached dfs referral
Date:   Mon, 19 Jul 2021 16:50:31 +0200
Message-Id: <20210719144940.987200832@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
@@ -5352,7 +5352,8 @@ int cifs_tree_connect(const unsigned int
 	if (!tree)
 		return -ENOMEM;
 
-	if (!tcon->dfs_path) {
+	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
+	if (!tcon->dfs_path || dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl)) {
 		if (tcon->ipc) {
 			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
@@ -5362,9 +5363,6 @@ int cifs_tree_connect(const unsigned int
 		goto out;
 	}
 
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl);
-	if (rc)
-		goto out;
 	isroot = ref.server_type == DFS_TYPE_ROOT;
 	free_dfs_info_param(&ref);
 


