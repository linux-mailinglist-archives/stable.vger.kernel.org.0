Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC682EA1C2
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAEAzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbhAEAzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 19:55:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D69D622573;
        Tue,  5 Jan 2021 00:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808107;
        bh=yfLor65DiiDuUyAFfmLknF94i9VyZ+d0RMnYmOcXc4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcHKHrhaoruYAQ5HHU5nfeR3wPqWWJRuX9SdUqzWXifBuynZRhAtxo2xi1I9ryELL
         jYk6KvnE5QMyEiyeHAI3hRYCQILCytEhaOfPVjfXreCFemcvnM/Nkq/iq5Q+RtkaZs
         FREWALhhzmJ/GUgLJp5mIG1Yxi6coO7FsXLWzisbVwJM+KeK7uPQyfmumSJ2f9w81e
         HW5IKeMMrfvPE1S+tMNafipk6MHE7F2WSksulFTT8sNGigCoztUjO6ThghPZs3+eWU
         kOgtkaqdduPXOiRgahNp8ljEYKSiIq2KPfLo4pr7ZLNHalGDepljvOaxQXxDFbKpsh
         Bo4e5vfoJCM7w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH 01/13] fs: avoid double-writing inodes on lazytime expiration
Date:   Mon,  4 Jan 2021 16:54:40 -0800
Message-Id: <20210105005452.92521-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105005452.92521-1-ebiggers@kernel.org>
References: <20210105005452.92521-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When lazytime is enabled and an inode with dirty timestamps is being
expired, either due to dirtytime_expire_interval being exceeded or due
to a sync or syncfs system call, we need to inform the filesystem that
the inode is dirty so that the inode's timestamps can be copied out to
the on-disk data structures.  That's because if the filesystem supports
lazytime, it will have ignored the ->dirty_inode(inode, I_DIRTY_TIME)
notification when the timestamp was modified in memory.

Currently this is accomplished by calling mark_inode_dirty_sync() from
__writeback_single_inode().  However, this has the unfortunate side
effect of also putting the inode the writeback list.  That's not
appropriate in this case, since the inode is already being written.

That causes the inode to remain dirty after a sync.  Normally that's
just wasteful, as it causes the inode to be written twice.  But when
fscrypt is used this bug also partially breaks the
FS_IOC_REMOVE_ENCRYPTION_KEY ioctl, as the ioctl reports that files are
still in-use when they aren't.  For more details, see the original
report at https://lore.kernel.org/r/20200306004555.GB225345@gmail.com

Fix this by calling ->dirty_inode(inode, I_DIRTY_SYNC) directly instead
of mark_inode_dirty_sync().

This fixes xfstest generic/580 when lazytime is enabled.

A later patch will introduce a ->lazytime_expired method to cleanly
separate out the lazytime expiration case, in particular for XFS which
uses the VFS-level dirtiness tracking only for lazytime.  But that's
separate from fixing this bug.  Also, note that XFS will incorrectly
ignore the I_DIRTY_SYNC notification from __writeback_single_inode()
both before and after this patch, as I_DIRTY_TIME was already cleared in
i_state.  Later patches will fix this separate bug.

Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/fs-writeback.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index acfb55834af23..081e335cdee47 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1509,11 +1509,22 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	spin_unlock(&inode->i_lock);
 
-	if (dirty & I_DIRTY_TIME)
-		mark_inode_dirty_sync(inode);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & ~I_DIRTY_PAGES) {
-		int err = write_inode(inode, wbc);
+		int err;
+
+		/*
+		 * If the inode is being written due to a lazytime timestamp
+		 * expiration, then the filesystem needs to be notified about it
+		 * so that e.g. the filesystem can update on-disk fields and
+		 * journal the timestamp update.  Just calling write_inode()
+		 * isn't enough.  Don't call mark_inode_dirty_sync(), as that
+		 * would put the inode back on the dirty list.
+		 */
+		if ((dirty & I_DIRTY_TIME) && inode->i_sb->s_op->dirty_inode)
+			inode->i_sb->s_op->dirty_inode(inode, I_DIRTY_SYNC);
+
+		err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
 	}

base-commit: e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62
-- 
2.30.0

