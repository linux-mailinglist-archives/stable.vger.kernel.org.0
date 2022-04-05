Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CA44F311E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbiDEJM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244802AbiDEIwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F3622290;
        Tue,  5 Apr 2022 01:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16889B81B18;
        Tue,  5 Apr 2022 08:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69536C385A1;
        Tue,  5 Apr 2022 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147949;
        bh=msW2dI8/ew3KzPd9Z6LM66OajboeTObfOIEWdOuNFlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/hAun63090bidYjLshQxyoCJaxxqiT3loTakpZnUdSvJtC84MEvg9u2zv8ABhWLe
         kErTn6dJCniSFfEuXOonrPwjzF2VBRhEYQxRHzF8ysPau8HuW1698yw0NLJrPb2AeO
         787MWoJdRIeJ8aFfhxdCys6uBtITYeLSNva98cN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0180/1017] btrfs: zoned: mark relocation as writing
Date:   Tue,  5 Apr 2022 09:18:13 +0200
Message-Id: <20220405070359.579413543@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit ca5e4ea0beaec8bc674121838bf8614c089effb9 upstream.

There is a hung_task issue with running generic/068 on an SMR
device. The hang occurs while a process is trying to thaw the
filesystem. The process is trying to take sb->s_umount to thaw the
FS. The lock is held by fsstress, which calls btrfs_sync_fs() and is
waiting for an ordered extent to finish. However, as the FS is frozen,
the ordered extents never finish.

Having an ordered extent while the FS is frozen is the root cause of
the hang. The ordered extent is initiated from btrfs_relocate_chunk()
which is called from btrfs_reclaim_bgs_work().

This commit adds sb_*_write() around btrfs_relocate_chunk() call
site. For the usual "btrfs balance" command, we already call it with
mnt_want_file() in btrfs_ioctl_balance().

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.13+
Link: https://github.com/naota/linux/issues/56
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    8 +++++++-
 fs/btrfs/volumes.c     |    3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1521,8 +1521,12 @@ void btrfs_reclaim_bgs_work(struct work_
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
@@ -1530,6 +1534,7 @@ void btrfs_reclaim_bgs_work(struct work_
 	 */
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock)) {
 		btrfs_exclop_finish(fs_info);
+		sb_end_write(fs_info->sb);
 		return;
 	}
 
@@ -1604,6 +1609,7 @@ next:
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+	sb_end_write(fs_info->sb);
 }
 
 void btrfs_reclaim_bgs(struct btrfs_fs_info *fs_info)
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8263,10 +8263,12 @@ static int relocating_repair_kthread(voi
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
 
@@ -8294,6 +8296,7 @@ out:
 		btrfs_put_block_group(cache);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
+	sb_end_write(fs_info->sb);
 
 	return ret;
 }


