Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB8F5B6FC3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiIMOQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiIMOPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:15:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE22606AF;
        Tue, 13 Sep 2022 07:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A95614A3;
        Tue, 13 Sep 2022 14:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC508C433D7;
        Tue, 13 Sep 2022 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078262;
        bh=NC3po0GEBPxVBqgSJiEzOphyj0CROhifvPdUQttqXQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHMY2EL4ZUk9BlDeDMI8cDwPudj7Ote8AGwFIckKhODgzGiTn6gaiN0dXHy0hCXrD
         DPdaU9v59NRKQhAcuqf8YHzkJCbfP4uCGlM4hTKXaFE91RMAW1D3pnmIRZ8jBOfE7O
         wwqCMdA/DCk2v1ZUkWYWQQ/kVj76WdUS6QZ8fyy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 046/192] btrfs: zoned: fix API misuse of zone finish waiting
Date:   Tue, 13 Sep 2022 16:02:32 +0200
Message-Id: <20220913140412.217989464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit d5b81ced74afded85619ffbbe9c32ba9d82c9b1e upstream.

The commit 2ce543f47843 ("btrfs: zoned: wait until zone is finished when
allocation didn't progress") implemented a zone finish waiting mechanism
to the write path of zoned mode. However, using
wait_var_event()/wake_up_all() on fs_info->zone_finish_wait is wrong and
wait_var_event() just hangs because no one ever wakes it up once it goes
into sleep.

Instead, we can simply use wait_on_bit_io() and clear_and_wake_up_bit()
on fs_info->flags with a proper barrier installed.

Fixes: 2ce543f47843 ("btrfs: zoned: wait until zone is finished when allocation didn't progress")
CC: stable@vger.kernel.org # 5.16+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h   |    2 --
 fs/btrfs/disk-io.c |    1 -
 fs/btrfs/inode.c   |    7 +++----
 fs/btrfs/zoned.c   |    3 +--
 4 files changed, 4 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1065,8 +1065,6 @@ struct btrfs_fs_info {
 
 	spinlock_t zone_active_bgs_lock;
 	struct list_head zone_active_bgs;
-	/* Waiters when BTRFS_FS_NEED_ZONE_FINISH is set */
-	wait_queue_head_t zone_finish_wait;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3173,7 +3173,6 @@ void btrfs_init_fs_info(struct btrfs_fs_
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 	init_waitqueue_head(&fs_info->delayed_iputs_wait);
-	init_waitqueue_head(&fs_info->zone_finish_wait);
 
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1643,10 +1643,9 @@ static noinline int run_delalloc_zoned(s
 			done_offset = end;
 
 		if (done_offset == start) {
-			struct btrfs_fs_info *info = inode->root->fs_info;
-
-			wait_var_event(&info->zone_finish_wait,
-				       !test_bit(BTRFS_FS_NEED_ZONE_FINISH, &info->flags));
+			wait_on_bit_io(&inode->root->fs_info->flags,
+				       BTRFS_FS_NEED_ZONE_FINISH,
+				       TASK_UNINTERRUPTIBLE);
 			continue;
 		}
 
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2016,8 +2016,7 @@ static int do_zone_finish(struct btrfs_b
 	/* For active_bg_list */
 	btrfs_put_block_group(block_group);
 
-	clear_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
-	wake_up_all(&fs_info->zone_finish_wait);
+	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
 	return 0;
 }


