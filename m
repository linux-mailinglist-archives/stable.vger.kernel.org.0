Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5A437CC9C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbhELQpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239049AbhELQjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE9B261CDA;
        Wed, 12 May 2021 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835393;
        bh=q7qdVnuUeIr08s+JvqQJbgO5qKDfyI/vrU5HwDnxXXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMtuD+v/2H0l4/EcNEWM7c/mMpptDKIuNs//DM7Zd5uvOEj9nAyBE90dSc34Ae4pt
         Kgi9J/GyMN3JeL6jxMQtrBXbsjJgcjVlZ7VuwT5cjbEiseld1damWYmWqyvrQxPdAL
         a80SNva0vfn2xRXfy2UH1mHUPkduO27NzbadxtoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 326/677] btrfs: zoned: move log tree node allocation out of log_root_tree->log_mutex
Date:   Wed, 12 May 2021 16:46:12 +0200
Message-Id: <20210512144848.075752880@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit e75f9fd194090e69c5ffd856ba89160683d343da ]

Commit 6e37d2459941 ("btrfs: zoned: fix deadlock on log sync") pointed out
a deadlock warning and removed mutex_{lock,unlock} of fs_info::tree_root->log_mutex.
While it looks like it always cause a deadlock, we didn't see actual
deadlock in fstests runs. The reason is log_root_tree->log_mutex !=
fs_info->tree_root->log_mutex, not taking the same lock. So, the warning
was actually a false-positive.

Since btrfs_alloc_log_tree_node() is protected only by
fs_info->tree_root->log_mutex, we can (and should) move the code out of
the lock scope of log_root_tree->log_mutex and silence the warning.

Fixes: 6e37d2459941 ("btrfs: zoned: fix deadlock on log sync")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 92a368627791..72c4b66ed516 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3165,20 +3165,22 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	mutex_unlock(&root->log_mutex);
 
-	btrfs_init_log_ctx(&root_log_ctx, NULL);
-
-	mutex_lock(&log_root_tree->log_mutex);
-
 	if (btrfs_is_zoned(fs_info)) {
+		mutex_lock(&fs_info->tree_root->log_mutex);
 		if (!log_root_tree->node) {
 			ret = btrfs_alloc_log_tree_node(trans, log_root_tree);
 			if (ret) {
-				mutex_unlock(&log_root_tree->log_mutex);
+				mutex_unlock(&fs_info->tree_log_mutex);
 				goto out;
 			}
 		}
+		mutex_unlock(&fs_info->tree_root->log_mutex);
 	}
 
+	btrfs_init_log_ctx(&root_log_ctx, NULL);
+
+	mutex_lock(&log_root_tree->log_mutex);
+
 	index2 = log_root_tree->log_transid % 2;
 	list_add_tail(&root_log_ctx.list, &log_root_tree->log_ctxs[index2]);
 	root_log_ctx.log_transid = log_root_tree->log_transid;
-- 
2.30.2



