Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196AB40E68E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbhIPRW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243724AbhIPQzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F5861AAD;
        Thu, 16 Sep 2021 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809837;
        bh=DHfUC0I0hWzaGWI9DCiRXd0dHCLPf74OZNF7j7C50+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4LuxOl61ff2LfEv8ezq1qzj8TvRt//v/lvatHhJcmbt4a0XgrAALbx/frc7QzSs8
         8FWrbx7bYcriJYgh5Zr+M+Lk9mxMykrfGL0Za+EtAKEvul+PxOQRpMmLp/CwZ8CMtM
         Nv1M/7Y43hzV8sVaTnx0OoE8GPkz3UolADQPrsug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 301/380] btrfs: remove racy and unnecessary inode transaction update when using no-holes
Date:   Thu, 16 Sep 2021 18:00:58 +0200
Message-Id: <20210916155814.298271341@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit cceaa89f02f15f232391ae4be214137b0a0285c0 ]

When using the NO_HOLES feature and expanding the size of an inode, we
update the inode's last_trans, last_sub_trans and last_log_commit fields
at maybe_insert_hole() so that a fsync does know that the inode needs to
be logged (by making sure that btrfs_inode_in_log() returns false). This
happens for expanding truncate operations, buffered writes, direct IO
writes and when cloning extents to an offset greater than the inode's
i_size.

However the way we do it is racy, because in between setting the inode's
last_sub_trans and last_log_commit fields, the log transaction ID that was
assigned to last_sub_trans might be committed before we read the root's
last_log_commit and assign that value to last_log_commit. If that happens
it would make a future call to btrfs_inode_in_log() return true. This is
a race that should be extremely unlikely to be hit in practice, and it is
the same that was described by commit bc0939fcfab0d7 ("btrfs: fix race
between marking inode needs to be logged and log syncing").

The fix would simply be to set last_log_commit to the value we assigned
to last_sub_trans minus 1, like it was done in that commit. However
updating these two fields plus the last_trans field is pointless here
because all the callers of btrfs_cont_expand() (which is the only
caller of maybe_insert_hole()) always call btrfs_set_inode_last_trans()
or btrfs_update_inode() after calling btrfs_cont_expand(). Calling either
btrfs_set_inode_last_trans() or btrfs_update_inode() guarantees that the
next fsync will log the inode, as it makes btrfs_inode_in_log() return
false.

So just remove the code that explicitly sets the inode's last_trans,
last_sub_trans and last_log_commit fields.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c3810c6430d9..044300db5e22 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5064,15 +5064,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct btrfs_inode *inode,
 	int ret;
 
 	/*
-	 * Still need to make sure the inode looks like it's been updated so
-	 * that any holes get logged if we fsync.
+	 * If NO_HOLES is enabled, we don't need to do anything.
+	 * Later, up in the call chain, either btrfs_set_inode_last_sub_trans()
+	 * or btrfs_update_inode() will be called, which guarantee that the next
+	 * fsync will know this inode was changed and needs to be logged.
 	 */
-	if (btrfs_fs_incompat(fs_info, NO_HOLES)) {
-		inode->last_trans = fs_info->generation;
-		inode->last_sub_trans = root->log_transid;
-		inode->last_log_commit = root->last_log_commit;
+	if (btrfs_fs_incompat(fs_info, NO_HOLES))
 		return 0;
-	}
 
 	/*
 	 * 1 - for the one we're dropping
-- 
2.30.2



