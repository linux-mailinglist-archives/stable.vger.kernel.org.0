Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCAEDCB1A9
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfJCWFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:05:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:49634 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731166AbfJCWFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 18:05:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C640B114;
        Thu,  3 Oct 2019 22:05:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 11D2E1E4815; Fri,  4 Oct 2019 00:06:14 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 03/22] ext4: Do not iput inode under running transaction in ext4_mkdir()
Date:   Fri,  4 Oct 2019 00:05:49 +0200
Message-Id: <20191003220613.10791-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ext4_mkdir() fails to add entry into directory, it ends up dropping
freshly created inode under the running transaction and thus inode
truncation happens under that transaction. That breaks assumptions that
ext4_evict_inode() does not get called from a transaction context
(although I'm not aware of any real issue) and is completely
unnecessary. Just stop the transaction before dropping inode reference.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a427d2031a8d..9c872a33aea7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2781,8 +2781,9 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		clear_nlink(inode);
 		unlock_new_inode(inode);
 		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
 		iput(inode);
-		goto out_stop;
+		goto out_retry;
 	}
 	ext4_inc_count(handle, dir);
 	ext4_update_dx_flag(dir);
@@ -2796,6 +2797,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 out_stop:
 	if (handle)
 		ext4_journal_stop(handle);
+out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
-- 
2.16.4

