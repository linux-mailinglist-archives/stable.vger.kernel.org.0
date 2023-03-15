Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C886BB2C1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjCOMiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbjCOMiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244DA9B2D7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A5BC61D78
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF1DC433D2;
        Wed, 15 Mar 2023 12:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883823;
        bh=q/Q4UasE/jzjq1EBtPH0SDQzjoKqcTP82h6ApCpZXTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD5WTWA6bd/+DmnBuvi/itxwgIiOk8DNhkh+FOGIxobGkS3k2nugxxj0SK8RSLLSa
         IFIG8/pw8PLyc8VLgxx5B2QMutgnH4Wgs6BvX33pOVGZQ4W2d8sG1uMvqO4hDThi45
         93H+oQs6yMvVx4DDZkWpMKkhxYx3pHKmutahVtF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9d16c39efb5fade84574@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/143] ext4: Fix deadlock during directory rename
Date:   Wed, 15 Mar 2023 13:13:21 +0100
Message-Id: <20230315115743.990429114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 3c92792da8506a295afb6d032b4476e46f979725 ]

As lockdep properly warns, we should not be locking i_rwsem while having
transactions started as the proper lock ordering used by all directory
handling operations is i_rwsem -> transaction start. Fix the lock
ordering by moving the locking of the directory earlier in
ext4_rename().

Reported-by: syzbot+9d16c39efb5fade84574@syzkaller.appspotmail.com
Fixes: 0813299c586b ("ext4: Fix possible corruption when moving a directory")
Link: https://syzkaller.appspot.com/bug?extid=9d16c39efb5fade84574
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230301141004.15087-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index dc8f8a435a7ea..800d631c920b4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3813,10 +3813,20 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			return retval;
 	}
 
+	/*
+	 * We need to protect against old.inode directory getting converted
+	 * from inline directory format into a normal one.
+	 */
+	if (S_ISDIR(old.inode->i_mode))
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
+
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
 				 &old.inlined);
-	if (IS_ERR(old.bh))
-		return PTR_ERR(old.bh);
+	if (IS_ERR(old.bh)) {
+		retval = PTR_ERR(old.bh);
+		goto unlock_moved_dir;
+	}
+
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3873,11 +3883,6 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
-		/*
-		 * We need to protect against old.inode directory getting
-		 * converted from inline directory format into a normal one.
-		 */
-		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
 		retval = ext4_rename_dir_prepare(handle, &old);
 		if (retval) {
 			inode_unlock(old.inode);
@@ -4014,12 +4019,15 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	} else {
 		ext4_journal_stop(handle);
 	}
-	if (old.dir_bh)
-		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
+
+unlock_moved_dir:
+	if (S_ISDIR(old.inode->i_mode))
+		inode_unlock(old.inode);
+
 	return retval;
 }
 
-- 
2.39.2



