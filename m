Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1664B6B4196
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCJNye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCJNyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEA8559DC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A410B822B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48E2C433EF;
        Fri, 10 Mar 2023 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456470;
        bh=nggTsU2HE3w1Am1s4BXYMJB9hWSPXbOe4p+QtxxzCUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltZRPMFkNQfbkW6xPKRKs2EhkYxMypPYUEzw76DUAuwNGsKjyX5b/fhXlc4b9ASaH
         IRy0WFuiORFdmsddPP3JGiv+r9yoH/NLAKJJpSjSMkiLQQfoKADR1MDtP7zsFSUNDk
         UsSN0LJJljk3t53jT1JMthXsm0ZnUkJzCrxS5glk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4793f6096d174c90b4f7@syzkaller.appspotmail.com,
        Chao Yu <chao@kernel.org>, Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 006/211] f2fs: fix to avoid potential deadlock
Date:   Fri, 10 Mar 2023 14:36:26 +0100
Message-Id: <20230310133718.913490363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5eaac835f27f2de6b73412d7c24e755733b49de0 ]

There is a potential deadlock reported by syzbot as below:

F2FS-fs (loop2): invalid crc value
F2FS-fs (loop2): Found nat_bits in checkpoint
F2FS-fs (loop2): Mounted with checkpoint version = 48b305e4
======================================================
WARNING: possible circular locking dependency detected
6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0 Not tainted
------------------------------------------------------
syz-executor.2/32123 is trying to acquire lock:
ffff0000c0e1a608 (&mm->mmap_lock){++++}-{3:3}, at: __might_fault+0x54/0xb4 mm/memory.c:5644

but task is already holding lock:
ffff0001317c6088 (&sbi->sb_lock){++++}-{3:3}, at: f2fs_down_write fs/f2fs/f2fs.h:2205 [inline]
ffff0001317c6088 (&sbi->sb_lock){++++}-{3:3}, at: f2fs_ioc_get_encryption_pwsalt fs/f2fs/file.c:2334 [inline]
ffff0001317c6088 (&sbi->sb_lock){++++}-{3:3}, at: __f2fs_ioctl+0x1370/0x3318 fs/f2fs/file.c:4151

which lock already depends on the new lock.

Chain exists of:
  &mm->mmap_lock --> &nm_i->nat_tree_lock --> &sbi->sb_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sbi->sb_lock);
                               lock(&nm_i->nat_tree_lock);
                               lock(&sbi->sb_lock);
  lock(&mm->mmap_lock);

Let's try to avoid above deadlock condition by moving __might_fault()
out of sbi->sb_lock coverage.

Fixes: 95fa90c9e5a7 ("f2fs: support recording errors into superblock")
Link: https://lore.kernel.org/linux-f2fs-devel/000000000000cd5fe305ef617fe2@google.com/T/#u
Reported-by: syzbot+4793f6096d174c90b4f7@syzkaller.appspotmail.com
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ecbc8c135b494..2498e5c70fd83 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2338,6 +2338,7 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	u8 encrypt_pw_salt[16];
 	int err;
 
 	if (!f2fs_sb_has_encrypt(sbi))
@@ -2362,12 +2363,14 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 		goto out_err;
 	}
 got_it:
-	if (copy_to_user((__u8 __user *)arg, sbi->raw_super->encrypt_pw_salt,
-									16))
-		err = -EFAULT;
+	memcpy(encrypt_pw_salt, sbi->raw_super->encrypt_pw_salt, 16);
 out_err:
 	f2fs_up_write(&sbi->sb_lock);
 	mnt_drop_write_file(filp);
+
+	if (!err && copy_to_user((__u8 __user *)arg, encrypt_pw_salt, 16))
+		err = -EFAULT;
+
 	return err;
 }
 
-- 
2.39.2



