Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B825EA3D5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiIZLex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238146AbiIZLeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14866E2DE;
        Mon, 26 Sep 2022 03:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 415D060A52;
        Mon, 26 Sep 2022 10:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56196C433C1;
        Mon, 26 Sep 2022 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188998;
        bh=jLm3OD3DQ5HM9meF13VdBawooU2t/bfBfnoqYP3gKJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/zDM+9hdd+EwBtJQKXIOzT2aE0lyhtbKU6gJ6yrkgsL0FeZ2GCUxOon/w/ShJxZj
         SwJeDwwa7gr43EnKExB0fGGLYBAMtBho4ACJE2z2bDF/s+nlh+H8Ek5GYI5mveocLl
         c4G7Lequoi6xKzEcOBBPHliRvMpDuBtYvN4kHo1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 041/207] btrfs: fix hang during unmount when stopping block group reclaim worker
Date:   Mon, 26 Sep 2022 12:10:30 +0200
Message-Id: <20220926100808.459198084@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 8a1f1e3d1eecf9d2359a2709e276743a67e145db upstream.

During early unmount, at close_ctree(), we try to stop the block group
reclaim task with cancel_work_sync(), but that may hang if the block group
reclaim task is currently at btrfs_relocate_block_group() waiting for the
flag BTRFS_FS_UNFINISHED_DROPS to be cleared from fs_info->flags. During
unmount we only clear that flag later, after trying to stop the block
group reclaim task.

Fix that by clearing BTRFS_FS_UNFINISHED_DROPS before trying to stop the
block group reclaim task and after setting BTRFS_FS_CLOSING_START, so that
if the reclaim task is waiting on that bit, it will stop immediately after
being woken, because it sees the filesystem is closing (with a call to
btrfs_fs_closing()), and then returns immediately with -EINTR.

Fixes: 31e70e527806c5 ("btrfs: fix hang during unmount when block group reclaim task is running")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4587,6 +4587,17 @@ void __cold close_ctree(struct btrfs_fs_
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
 
 	/*
+	 * If we had UNFINISHED_DROPS we could still be processing them, so
+	 * clear that bit and wake up relocation so it can stop.
+	 * We must do this before stopping the block group reclaim task, because
+	 * at btrfs_relocate_block_group() we wait for this bit, and after the
+	 * wait we stop with -EINTR if btrfs_fs_closing() returns non-zero - we
+	 * have just set BTRFS_FS_CLOSING_START, so btrfs_fs_closing() will
+	 * return 1.
+	 */
+	btrfs_wake_unfinished_drop(fs_info);
+
+	/*
 	 * We may have the reclaim task running and relocating a data block group,
 	 * in which case it may create delayed iputs. So stop it before we park
 	 * the cleaner kthread otherwise we can get new delayed iputs after
@@ -4604,12 +4615,6 @@ void __cold close_ctree(struct btrfs_fs_
 	 */
 	kthread_park(fs_info->cleaner_kthread);
 
-	/*
-	 * If we had UNFINISHED_DROPS we could still be processing them, so
-	 * clear that bit and wake up relocation so it can stop.
-	 */
-	btrfs_wake_unfinished_drop(fs_info);
-
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 


