Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644EC4AA91A
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiBENYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:24:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32880 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiBENYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:24:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92034B80B47
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAD7C340E8;
        Sat,  5 Feb 2022 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644067475;
        bh=pc+6OA3YWZvn/7foPqQSzTRhAu+30HLkLpAn4ysxV1I=;
        h=Subject:To:Cc:From:Date:From;
        b=fIUfEQB27835F4ujyUTJn71+NgZI9KqagAHLo/CLuJ4YxRWxSJTrrWh2adKvo6Vyu
         sXQlGrNQeVbenqaRAx/djGSqsdXfOgT3tpqduEC7mrMRECPjX9vLWQsD+Q7sx+esHW
         JkpO3lzzmVEFU7C6CU7iKVfm9zcjP2GIX7JzHeaI=
Subject: FAILED: patch "[PATCH] btrfs: don't start transaction for scrub if the fs is mounted" failed to apply to 5.4-stable tree
To:     wqu@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 14:24:32 +0100
Message-ID: <16440674724173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Thu, 16 Dec 2021 19:47:35 +0800
Subject: [PATCH] btrfs: don't start transaction for scrub if the fs is mounted
 read-only

[BUG]
The following super simple script would crash btrfs at unmount time, if
CONFIG_BTRFS_ASSERT() is set.

 mkfs.btrfs -f $dev
 mount $dev $mnt
 xfs_io -f -c "pwrite 0 4k" $mnt/file
 umount $mnt
 mount -r ro $dev $mnt
 btrfs scrub start -Br $mnt
 umount $mnt

This will trigger the following ASSERT() introduced by commit
0a31daa4b602 ("btrfs: add assertion for empty list of transactions at
late stage of umount").

That patch is definitely not the cause, it just makes enough noise for
developers.

[CAUSE]
We will start transaction for the following call chain during scrub:

  scrub_enumerate_chunks()
  |- btrfs_inc_block_group_ro()
     |- btrfs_join_transaction()

However for RO mount, there is no running transaction at all, thus
btrfs_join_transaction() will start a new transaction.

Furthermore, since it's read-only mount, btrfs_sync_fs() will not call
btrfs_commit_super() to commit the new but empty transaction.

And leads to the ASSERT().

The bug has been there for a long time. Only the new ASSERT() makes it
noisy enough to be noticed.

[FIX]
For read-only scrub on read-only mount, there is no need to start a
transaction nor to allocate new chunks in btrfs_inc_block_group_ro().

Just do extra read-only mount check in btrfs_inc_block_group_ro(), and
if it's read-only, skip all chunk allocation and go inc_block_group_ro()
directly.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 1db24e6d6d90..68feabc83a27 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	int ret;
 	bool dirty_bg_running;
 
+	/*
+	 * This can only happen when we are doing read-only scrub on read-only
+	 * mount.
+	 * In that case we should not start a new transaction on read-only fs.
+	 * Thus here we skip all chunk allocations.
+	 */
+	if (sb_rdonly(fs_info->sb)) {
+		mutex_lock(&fs_info->ro_block_group_mutex);
+		ret = inc_block_group_ro(cache, 0);
+		mutex_unlock(&fs_info->ro_block_group_mutex);
+		return ret;
+	}
+
 	do {
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))

