Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC3A12156C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfLPSVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57289 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732301AbfLPSVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D96206EC;
        Mon, 16 Dec 2019 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520509;
        bh=pNacaEzUve952DMc+ojKhY/TSAljSVBx9N/TnS5BDmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyiNQ8ywoX2yo+CPjEMVZ2P4ouGa788stlfPvkJ3aoFdXkDyHARBzvbwgURNJQZWq
         kP+XWP8IOcUtuTAC/sdmlcoE8jhPs0REyL7voICh2jL9MLu2Y4hui9/4Xo4BMe+Ut/
         53m8ap8WnmNL+mouNBgmz4TQh1JdfqVO1J/PKyrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 177/177] ext4: fix leak of quota reservations
Date:   Mon, 16 Dec 2019 18:50:33 +0100
Message-Id: <20191216174851.197443318@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit f4c2d372b89a1e504ebb7b7eb3e29b8306479366 upstream.

Commit 8fcc3a580651 ("ext4: rework reserved cluster accounting when
invalidating pages") moved freeing of delayed allocation reservations
from dirty page invalidation time to time when we evict corresponding
status extent from extent status tree. For inodes which don't have any
blocks allocated this may actually happen only in ext4_clear_blocks()
which is after we've dropped references to quota structures from the
inode. Thus reservation of quota leaked. Fix the problem by clearing
quota information from the inode only after evicting extent status tree
in ext4_clear_inode().

Link: https://lore.kernel.org/r/20191108115420.GI20863@quack2.suse.cz
Reported-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: 8fcc3a580651 ("ext4: rework reserved cluster accounting when invalidating pages")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |    5 -----
 fs/ext4/super.c  |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -265,13 +265,8 @@ void ext4_free_inode(handle_t *handle, s
 	ext4_debug("freeing inode %lu\n", ino);
 	trace_ext4_free_inode(inode);
 
-	/*
-	 * Note: we must free any quota before locking the superblock,
-	 * as writing the quota to disk may need the lock as well.
-	 */
 	dquot_initialize(inode);
 	dquot_free_inode(inode);
-	dquot_drop(inode);
 
 	is_directory = S_ISDIR(inode->i_mode);
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1172,9 +1172,9 @@ void ext4_clear_inode(struct inode *inod
 {
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	dquot_drop(inode);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);


