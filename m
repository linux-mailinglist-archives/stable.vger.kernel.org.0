Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF27247710B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 12:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhLPLsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 06:48:02 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:45636 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhLPLr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 06:47:59 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 133A821125;
        Thu, 16 Dec 2021 11:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639655278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsBX4wutKe9mRVpZaMba57dO9duB2x/I0X75JghO1iU=;
        b=C08JTmmfiLylxazC5rkkJEvd5rJIbML2Ew7Xogc+hAXJIKk0oH3RiHQLdQfm90URxB6L2B
        K+HQyTAAM71HkAaapVNt7FfcGjCSm8lM6aeNLu6m9msF+Kv2YBXWjalC2owMGpzvZB8Noa
        qEF84JpykTDbvsVTMwdIoU9XP7oDmh4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12BD413B4B;
        Thu, 16 Dec 2021 11:47:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2KBaMWwnu2FvQwAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 16 Dec 2021 11:47:56 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs is mounted read-only
Date:   Thu, 16 Dec 2021 19:47:35 +0800
Message-Id: <20211216114736.69757-2-wqu@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216114736.69757-1-wqu@suse.com>
References: <20211216114736.69757-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

That patch is deifnitely not the cause, it just makes enough noise for
us developer.

[CAUSE]
We will start transaction for the following call chain during scrub:

  scrub_enumerate_chunks()
  |- btrfs_inc_block_group_ro()
     |- btrfs_join_transaction()

However for RO mount, there is no running transaction at all, thus
btrfs_join_transaction() will start a new transaction.

Furthermore, since it's read-only mount, btrfs_sync_fs() will not call
btrfs_commit_super() to commit the new but empty transaction.

And lead to the ASSERT() being triggered.

The bug should be there for a long time. Only the new ASSERT() makes it
noisy enough to be noticed.

[FIX]
For read-only scrub on read-only mount, there is no need to start a
transaction nor to allocate new chunks in btrfs_inc_block_group_ro().

Just do extra read-only mount check in btrfs_inc_block_group_ro(), and
if it's read-only, skip all chunk allocation and go inc_block_group_ro()
directly.

Since we're here, also add extra debug message at unmount for
btrfs_fs_info::trans_list.
Sometimes just knowing that there is no dirty metadata bytes for a
uncommitted transaction can tell us a lot of things.

Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 1db24e6d6d90..702219361b12 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	int ret;
 	bool dirty_bg_running;
 
+	/*
+	 * This can only happen when we are doing read-only scrub on read-only
+	 * mount.
+	 * In that case we should not start a new transaction on read-only fs.
+	 * Thus here we skip all chunk allocation.
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
-- 
2.34.1

