Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C645B2C7406
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgK1Vtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731869AbgK1SAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:00:44 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA86DC0253F7;
        Sat, 28 Nov 2020 09:41:30 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so4217664plo.0;
        Sat, 28 Nov 2020 09:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40L//mR7mpkTS3t1iaELnVbQvjPoARioHELJuLQ1ZOA=;
        b=pgCPDm1rOx/KGw+G2zsZ96CTC3/SsDRwhMm57nw4knrqMFbvKIDkQEzD0bDuGjFg06
         qrAQNqeRfIYRbWlprQf5fc3bWlgjxUPQIw1Sk5AbWwdhsu2VlbbYM7VFBBHKm90qyWzJ
         k8Dzm7PH1tvsACKQ48DXq/iB0GLHIzc5v0QPZipTdYGw9mxzBEdQnb2ckuV50+asQp15
         apeu0PQFPCRM6SUup8X+yJXrtjkUzrsmm4y7/vMa/YKAKb5u27GXWfLpnXkpHeqfk515
         opvXeZRjKkiRhDMm484VO1f0KKmdYKDb8nUujZ8DhFGoJ6p/USH8SB4BZh/j1YQfGDFw
         eTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40L//mR7mpkTS3t1iaELnVbQvjPoARioHELJuLQ1ZOA=;
        b=MGizZ4gs/wtZQcvJG0UMP1kcyo93PYoewJhBquUeto3h6d1ZXfc8lhh2ozwMmxzQrV
         9NGzlcJqNVh6JB7nLm6ijmiaiRd/hhsvuIeL9Iry0TjEh1GhyxoYd1wRwTw+yM6bqrpA
         ucg+xO1aMsE1wYzd7B6sWCOPuqYc9R4ICRc0eKbc+s+He8oFeU1cDlyzjloKDsChVRwB
         1KRNJtjfyIrYe/2hDQbcbGQHPrZvXSwu24WTbrwwPnM4gc/HylM1/vKD0auJYm8JWKzi
         j72MIW/iGggutCaJ2F+mI/W2pEIfYwdUTj0vKyGY3jW+eY+C9a+yMbkg3h1TLC6kgSu5
         NfnQ==
X-Gm-Message-State: AOAM530D3QYPjLQ8LfHygY8meDLLJ+1IGS7IcAemVVN7rLkcjc6cJoAO
        rF8iVVi+DcgNRYhE/Dx0cfA=
X-Google-Smtp-Source: ABdhPJwPOscNvx1pSiNFc6Cpt1i7blHZkozSHzGjS9avpj0QcYGA1CLtmW6e+ZzXXJU5kXMuNPx8ww==
X-Received: by 2002:a17:902:32d:b029:d9:d8a9:11e4 with SMTP id 42-20020a170902032db02900d9d8a911e4mr11883997pld.6.1606585290184;
        Sat, 28 Nov 2020 09:41:30 -0800 (PST)
Received: from hpilion.hsd1.wa.comcast.net (50-47-105-203.evrt.wa.frontiernet.net. [50.47.105.203])
        by smtp.gmail.com with ESMTPSA id gb4sm15610246pjb.30.2020.11.28.09.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 09:41:29 -0800 (PST)
From:   Shachar Raindel <shacharr@gmail.com>
To:     jaegeuk@kernel.org, chao@kernel.org, ebiggers@google.com,
        daehojeong@google.com, linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shachar Raindel <shacharr@gmail.com>
Subject: [PATCH] f2fs: Fix deadlock between f2fs_quota_sync and block_operation
Date:   Sat, 28 Nov 2020 09:41:24 -0800
Message-Id: <20201128174124.22397-1-shacharr@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This deadlock is hitting Android users (Pixel 3/3a/4) with Magisk, due
to frequent umount/mount operations that trigger quota_sync, hitting
the race. See https://github.com/topjohnwu/Magisk/issues/3171 for
additional impact discussion.

In commit db6ec53b7e03, we added a semaphore to protect quota flags.
As part of this commit, we changed f2fs_quota_sync to call
f2fs_lock_op, in an attempt to prevent an AB/BA type deadlock with
quota_sem locking in block_operation.  However, rwsem in Linux is not
recursive. Therefore, the following deadlock can occur:

f2fs_quota_sync
down_read(cp_rwsem) // f2fs_lock_op
filemap_fdatawrite
f2fs_write_data_pages
...
                                   block_opertaion
				   down_write(cp_rwsem) - marks rwsem as
				                          "writer pending"
down_read_trylock(cp_rwsem) - fails as there is
                              a writer pending.
			      Code keeps on trying,
			      live-locking the filesystem.

We solve this by creating a new rwsem, used specifically to
synchronize this case, instead of attempting to reuse an existing
lock.

Signed-off-by: Shachar Raindel <shacharr@gmail.com>

Fixes: db6ec53b7e03 f2fs: add a rw_sem to cover quota flag changes
---
 fs/f2fs/f2fs.h  |  3 +++
 fs/f2fs/super.c | 13 +++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cb700d797296..b3e55137be7f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1448,6 +1448,7 @@ struct f2fs_sb_info {
 	struct inode *meta_inode;		/* cache meta blocks */
 	struct mutex cp_mutex;			/* checkpoint procedure lock */
 	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
+	struct rw_semaphore cp_quota_rwsem;    	/* blocking quota sync operations */
 	struct rw_semaphore node_write;		/* locking node writes */
 	struct rw_semaphore node_change;	/* locking node change */
 	wait_queue_head_t cp_wait;
@@ -1961,12 +1962,14 @@ static inline void f2fs_unlock_op(struct f2fs_sb_info *sbi)
 
 static inline void f2fs_lock_all(struct f2fs_sb_info *sbi)
 {
+	down_write(&sbi->cp_quota_rwsem);
 	down_write(&sbi->cp_rwsem);
 }
 
 static inline void f2fs_unlock_all(struct f2fs_sb_info *sbi)
 {
 	up_write(&sbi->cp_rwsem);
+	up_write(&sbi->cp_quota_rwsem);
 }
 
 static inline int __get_cp_reason(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 00eff2f51807..5ce61147d7e5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2209,8 +2209,16 @@ int f2fs_quota_sync(struct super_block *sb, int type)
 	 *  f2fs_dquot_commit
 	 *                            block_operation
 	 *                            down_read(quota_sem)
+	 *
+	 * However, we cannot use the cp_rwsem to prevent this
+	 * deadlock, as the cp_rwsem is taken for read inside the
+	 * f2fs_dquot_commit code, and rwsem is not recursive.
+	 *
+	 * We therefore use a special lock to synchronize
+	 * f2fs_quota_sync with block_operations, as this is the only
+	 * place where such recursion occurs.
 	 */
-	f2fs_lock_op(sbi);
+	down_read(&sbi->cp_quota_rwsem);
 
 	down_read(&sbi->quota_sem);
 	ret = dquot_writeback_dquots(sb, type);
@@ -2251,7 +2259,7 @@ int f2fs_quota_sync(struct super_block *sb, int type)
 	if (ret)
 		set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
 	up_read(&sbi->quota_sem);
-	f2fs_unlock_op(sbi);
+	up_read(&sbi->cp_quota_rwsem);
 	return ret;
 }
 
@@ -3599,6 +3607,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	init_rwsem(&sbi->cp_rwsem);
 	init_rwsem(&sbi->quota_sem);
+	init_rwsem(&sbi->cp_quota_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
 
-- 
2.29.2

