Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7CA12EF7C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgABWaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbgABWaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9A92253D;
        Thu,  2 Jan 2020 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004222;
        bh=p/VQ5XvFfXoxpzlYbitgprfWPKotHqsZENTAFtN7H3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ye/nl9lOep10zxofr4r00Lr2mx3CSii1k3chEcY1jhNzQ+gOImrPVsjzo0jvL89E2
         wASTuzmH9ChV14/hY/mGlIIUsl7og5JCE7ysSFhWNh6IlNZ+v8/hAp65ToBtZKjU4f
         uDbVnvVPohqUOmivjEiA5WLCILrk704LKyZa0iXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 088/171] btrfs: dont double lock the subvol_sem for rename exchange
Date:   Thu,  2 Jan 2020 23:06:59 +0100
Message-Id: <20200102220559.262428738@linuxfoundation.org>
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

[ Upstream commit 943eb3bf25f4a7b745dd799e031be276aa104d82 ]

If we're rename exchanging two subvols we'll try to lock this lock
twice, which is bad.  Just lock once if either of the ino's are subvols.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80937c5ca477..bb8863958ac0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9597,9 +9597,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		return -EXDEV;
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&root->fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&dest->fs_info->subvol_sem);
 
 	/*
@@ -9785,9 +9784,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	ret2 = btrfs_end_transaction(trans, root);
 	ret = ret ? ret : ret2;
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&dest->fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
 	return ret;
-- 
2.20.1



