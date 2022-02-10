Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BEC4B05FD
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 07:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiBJGAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 01:00:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiBJGA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 01:00:27 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 22:00:29 PST
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2581C5;
        Wed,  9 Feb 2022 22:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644472829; x=1676008829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BskrxKkk4ZgB0vbGwHcFCr4Bnt7JqRs+SAZMxpuzF6U=;
  b=IlICHxOt5IVJiJsg7T2C7Mnr6SjDWwOBzGtXSO+4Zgg1XI3nmQaKHNh3
   NiqY/T9hywLMYZ5rUEaKKQMTPncAKr1VxpfztTxzFAj97TN1WvDbnPlWN
   OVgs/rmLWnm6P+0i2QdBXeKEzKmILVXMQ9ISBfSgJPdG7TjClehDut2AL
   n004u/izmAueymMC8MunGda7uBeaBnIWkdib/aVbWTg1QgEUUHsIUqJI3
   d7NmLLQKmxdJ0dx46UzoAUpDbJMWmmsEmELAtQcDyFi6hqkzWZpbrrx55
   /pHsHljzLL3DE4B25SN+hNV9OXrm5VOnitZi/Op0mzF67Crgb1B0AP0+Y
   A==;
X-IronPort-AV: E=Sophos;i="5.88,357,1635177600"; 
   d="scan'208";a="191512599"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 13:59:23 +0800
IronPort-SDR: 4eFZiF35f47U4Jvn8873x1hapHzSxj3uJoA7HR8P+RqLdwZ2OWFJp7JOCgi0Jz74fw51qZikVl
 P3OTMFkjlDc4/Iyr+GLx76x4L/RiPDarQFOqxKuj9LG6fzvgTpvVAhQ0eUQO7Mb4vCdJP5ByDq
 TrjE0CDLximwvFUmaIYjnIxQK0ONsowwG6NZ+ra3y++tOBAQ9eAIdHdLe3IU8qTUFtwY26v53x
 wN+zJ99T/LmCiYsXcwi8ZsK+hWc4s1Mp/LgxZNPhH9THNkD+vR6Ss5X1LUqvxM044sW83qxawD
 LktA7yOKqPzFcu8BGF2mccxx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 21:32:21 -0800
IronPort-SDR: EhaxfJoriGF0CnzQ2z5+VDI7p/jAwtYYk7HME3QWqhk2ud4vsK8HpojGeEwopOHe3q1JAxT6LK
 ICdYBK+C8x3lE8G+D4wDP5IxIoGpoU2WOI4mbO3LvD2N/uhqp/VBzwAwsgi+gwGrYnjjSt8VrR
 yAv3/0ir0XiChz7e+KApJvr202xnT/M1x/OGUeFiIu0G4zJ9Urjg6fKCUCXNIQ9/K3D/k6S+tr
 TBpmnYLshQblEmYcYBpLICsUg0uGQT9TZS6VRT+MgHqs6p1RfmCfJeYLVuNPK8zkKsZKInWn4E
 wiY=
WDCIronportException: Internal
Received: from chmc3h2.ad.shared (HELO naota-xeon.wdc.com) ([10.225.51.94])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Feb 2022 21:59:24 -0800
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Naohiro Aota <naohiro.aota@wdc.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: zoned: mark relocation as writing
Date:   Thu, 10 Feb 2022 14:59:05 +0900
Message-Id: <dd8886a3948042b8c1f0ddd839dab18a5872808d.1644469146.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644469146.git.naohiro.aota@wdc.com>
References: <cover.1644469146.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a hung_task issue with running generic/068 on an SMR
device. The hang occurs while a process is trying to thaw the
filesystem. The process is trying to take sb->s_umount to thaw the
FS. The lock is held by fsstress, which calls btrfs_sync_fs() and is
waiting for an ordered extent to finish. However, as the FS is frozen,
the ordered extent never finish.

Having an ordered extent while the FS is frozen is the root cause of
the hang. The ordered extent is initiated from btrfs_relocate_chunk()
which is called from btrfs_reclaim_bgs_work().

This commit add sb_*_write() around btrfs_relocate_chunk() call
site. For the usual "btrfs balance" command, we already call it with
mnt_want_file() in btrfs_ioctl_balance().

Additionally, add an ASSERT in btrfs_relocate_chunk() to check it is
properly called.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
Cc: stable@vger.kernel.org # 5.13+
Link: https://github.com/naota/linux/issues/56
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/block-group.c | 8 +++++++-
 fs/btrfs/volumes.c     | 6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 68feabc83a27..f9ca58a90630 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1513,8 +1513,12 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
 		return;
 
-	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE))
+	sb_start_write(fs_info->sb);
+
+	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE)) {
+		sb_end_write(fs_info->sb);
 		return;
+	}
 
 	/*
 	 * Long running balances can keep us blocked here for eternity, so
@@ -1522,6 +1526,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	 */
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock)) {
 		btrfs_exclop_finish(fs_info);
+		sb_end_write(fs_info->sb);
 		return;
 	}
 
@@ -1596,6 +1601,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+	sb_end_write(fs_info->sb);
 }
 
 void btrfs_reclaim_bgs(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b07d382d53a8..e415fb4a698e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3251,6 +3251,9 @@ int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	u64 length;
 	int ret;
 
+	/* Assert we called sb_start_write(), not to race with FS freezing */
+	sb_assert_write_started(fs_info->sb);
+
 	/*
 	 * Prevent races with automatic removal of unused block groups.
 	 * After we relocate and before we remove the chunk with offset
@@ -8299,10 +8302,12 @@ static int relocating_repair_kthread(void *data)
 	target = cache->start;
 	btrfs_put_block_group(cache);
 
+	sb_start_write(fs_info->sb);
 	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE)) {
 		btrfs_info(fs_info,
 			   "zoned: skip relocating block group %llu to repair: EBUSY",
 			   target);
+		sb_end_write(fs_info->sb);
 		return -EBUSY;
 	}
 
@@ -8330,6 +8335,7 @@ static int relocating_repair_kthread(void *data)
 		btrfs_put_block_group(cache);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+	sb_end_write(fs_info->sb);
 
 	return ret;
 }
-- 
2.35.1

