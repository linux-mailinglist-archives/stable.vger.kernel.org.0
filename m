Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2732C707D
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 19:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbgK1R76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 12:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732756AbgK1R56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 12:57:58 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47BEC0253F6;
        Sat, 28 Nov 2020 09:40:26 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id l1so4206394pld.5;
        Sat, 28 Nov 2020 09:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5M0Qk5wHG2QacembzBg5VIheheEu3YBTN3db8gj6qY=;
        b=XYeHz8VZPt56JJwlaQz3OfxTfaGeGURb9LOamoGaOMVgGH2KnHmYQLsFHcdEFvMqp+
         Am4yPx1+MpmrIx6g+fOnTymqPMrPdw06+9sfQf3pyuNN/Jl6FqXSmHT4Ki7VhwPfrzNd
         dbEny5yoS0sb3Nbt1Z/kxUC8m9LfFURHPgO5Z0mP+qyWWTJNOMhUmC/BfpRRU3dMF2IH
         CBLFkvUmqgLTprY55NoNpggd0w9YlYdMB9fwb8jd9FwDnmOorvm1gOcG4+f+BAX36e29
         Hugq3QIafEpOsIgEv86m4dFmz59ukcqc/YyyVLiPJcVaVytFl8LMLDdEkoxT64hCwKw2
         c2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5M0Qk5wHG2QacembzBg5VIheheEu3YBTN3db8gj6qY=;
        b=o6Xu54XK4P6tWis+oNRvN8JbPjDm/Vm2S3zVxVnRJ/OGqnRzVUcq7PAb3G+p7afqqa
         S0BA/oOqhSxQNvIY/CxmXMXjxySDsL/NxEsu6K+n1PyNpVhCmhaBc5krp8n0ennATDrb
         LdNiStV/HqS2mYVlBKhuujH9YQxlhsHQCW9q8Yb/vzR0Cx9a31hbCBsztUuY1CDO/iM4
         dmPUvNsYE1FYygfwYwerImTVf0DWSyxsl6ZyhX6+d4M64R8HMTtHBIOZr0YH1ESQXWS/
         X1c1zS0Z5vVHJLUIuPtGypdvPjXa90nUwFLGLL9gKxs9BsF9+W1ywXtQarjME6tS9oR1
         DVdg==
X-Gm-Message-State: AOAM532uZW8oONM5swL9iUAASNIHFkQfipcCcqOamEH5RVGHbPGMJdI5
        guDJ9k3Vbwd5K16X088fAac=
X-Google-Smtp-Source: ABdhPJwMyHd0UGC8sDAuAM35fHi+FccXiEOE281/CXiUDGgdd4ce+UAFHU0RhzQNrCMcLxc3By1INQ==
X-Received: by 2002:a17:902:b408:b029:d6:d1e2:e1be with SMTP id x8-20020a170902b408b02900d6d1e2e1bemr11911471plr.34.1606585226332;
        Sat, 28 Nov 2020 09:40:26 -0800 (PST)
Received: from hpilion.hsd1.wa.comcast.net (50-47-105-203.evrt.wa.frontiernet.net. [50.47.105.203])
        by smtp.gmail.com with ESMTPSA id y81sm11302246pfc.25.2020.11.28.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 09:40:25 -0800 (PST)
From:   Shachar Raindel <shacharr@gmail.com>
To:     jaegeuk@kernel.org, chao@kernel.org, ebiggers@google.com,
        daehojeong@google.com, linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shachar Raindel <shacharr@gmail.com>
Subject: [PATCH] f2fs: Fix deadlock between f2fs_quota_sync and block_operation
Date:   Sat, 28 Nov 2020 09:39:46 -0800
Message-Id: <20201128173946.22340-1-shacharr@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

f2fs_quota_sync is calling f2fs_lock_op, in an attempt to prevent
an AB/BA type deadlock with quota_sem locking in block_operation.
However, rwsem in Linux is not recursive. As a result, the following
deadlock may occur:

f2fs_quota_sync
down_read(cp_rwsem) // f2fs_lock_op
filemap_fdatawrite
f2fs_write_data_pages
...
                                       block_opertaion
				       down_write(cp_rwsem) - marks rwsem as "writer pending"
down_read_trylock(cp_rwsem) - fails as there is
                              a writer pending.
			      Code keeps on trying.

We solve this by creating a new rwsem, used specifically to
synchronize this case, instead of attempting to reuse an existing lock
for this
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
+	 * place where such recurrsion occurs.
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

