Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA5312EDA4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgABWaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbgABWaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EA220863;
        Thu,  2 Jan 2020 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004224;
        bh=m5jp6toHKvY6DICKeFo4tapw/949r6gZ/yCWEKg4VJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bQ3BXDR4LWA2BFtmzyfuTqnhUDfBgVUjkMR9v9o6vMARSO2zWCakPA4mrFqx62NT
         SPjGtwlXbNF9Xk3eFyddst0kFe3zYO11usjSfyC0hpcaRHB8Wta/93ePuI9YGNMNfd
         i4w7UmakKt1WPqY8iBM9FnCxcMw1OuS/XMnHQ3J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 089/171] btrfs: do not call synchronize_srcu() in inode_tree_del
Date:   Thu,  2 Jan 2020 23:07:00 +0100
Message-Id: <20200102220559.438935083@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f72ff01df9cf5db25c76674cac16605992d15467 ]

Testing with the new fsstress uncovered a pretty nasty deadlock with
lookup and snapshot deletion.

Process A
unlink
 -> final iput
   -> inode_tree_del
     -> synchronize_srcu(subvol_srcu)

Process B
btrfs_lookup  <- srcu_read_lock() acquired here
  -> btrfs_iget
    -> find inode that has I_FREEING set
      -> __wait_on_freeing_inode()

We're holding the srcu_read_lock() while doing the iget in order to make
sure our fs root doesn't go away, and then we are waiting for the inode
to finish freeing.  However because the free'ing process is doing a
synchronize_srcu() we deadlock.

Fix this by dropping the synchronize_srcu() in inode_tree_del().  We
don't need people to stop accessing the fs root at this point, we're
only adding our empty root to the dead roots list.

A larger much more invasive fix is forthcoming to address how we deal
with fs roots, but this fixes the immediate problem.

Fixes: 76dda93c6ae2 ("Btrfs: add snapshot/subvolume destroy ioctl")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bb8863958ac0..250c8403ec67 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5576,7 +5576,6 @@ static void inode_tree_del(struct inode *inode)
 	spin_unlock(&root->inode_lock);
 
 	if (empty && btrfs_root_refs(&root->root_item) == 0) {
-		synchronize_srcu(&root->fs_info->subvol_srcu);
 		spin_lock(&root->inode_lock);
 		empty = RB_EMPTY_ROOT(&root->inode_tree);
 		spin_unlock(&root->inode_lock);
-- 
2.20.1



