Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3C35EA39C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiIZL3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiIZL2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8139E6B152;
        Mon, 26 Sep 2022 03:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C5860CBA;
        Mon, 26 Sep 2022 10:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C21C433D6;
        Mon, 26 Sep 2022 10:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188522;
        bh=OmVOUH5O5wM/GQn9cqgiVF7A28fs+WYZJ3xrbzQ8s2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWy5UCUaC0ZZJ6kAPeCcc4oeCXAtxXU+rjP44N1hBUThC8smMYOY49XiGBatKLegK
         v8z9FtvqTqzjUL00MMtvqi7SxGEh7pQR6CAIFULaNW3zeYVMjXpgxfE94QruvSdnU9
         xArrlYsXo75wx/n8hFFhptDUxH+Rt+kIXocCg2AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 035/148] btrfs: fix hang during unmount when stopping block group reclaim worker
Date:   Mon, 26 Sep 2022 12:11:09 +0200
Message-Id: <20220926100757.350110440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
@@ -4298,6 +4298,17 @@ void __cold close_ctree(struct btrfs_fs_
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
@@ -4315,12 +4326,6 @@ void __cold close_ctree(struct btrfs_fs_
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
 


