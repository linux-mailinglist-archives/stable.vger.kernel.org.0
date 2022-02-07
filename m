Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7954ABC71
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiBGLfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384528AbiBGL2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2113AC03BFC3;
        Mon,  7 Feb 2022 03:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73B3AB80EBD;
        Mon,  7 Feb 2022 11:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1FAC004E1;
        Mon,  7 Feb 2022 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233187;
        bh=56Msqycmh59KyAGegnD4FMQN8txHpwKB3hsT4iWHGGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYNCr68Ck49EQc22LUHHELtSKmh1Y0RPm7/jQqp5GxoYOiHTrcQ9OpvRfKAP2fZAv
         HaK7KCK0xJT3lYvIPO3f/U04QIzsNz+PigT1fHkRFjwkRq1yLLYZhcKXso/kZ8o1Ir
         jWHyYsIhBsyLPBczv/hbdJVIcdw83Du97m972gJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 017/110] btrfs: dont start transaction for scrub if the fs is mounted read-only
Date:   Mon,  7 Feb 2022 12:05:50 +0100
Message-Id: <20220207103802.844874622@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2511,6 +2511,19 @@ int btrfs_inc_block_group_ro(struct btrf
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
 		trans = btrfs_join_transaction(fs_info->extent_root);
 		if (IS_ERR(trans))


