Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A01498ADA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344356AbiAXTH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346233AbiAXTFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369ADC0613E9;
        Mon, 24 Jan 2022 11:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA64360B86;
        Mon, 24 Jan 2022 19:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6034C340E5;
        Mon, 24 Jan 2022 19:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050823;
        bh=WGNVpAlelXoXa7YIBX5GGnhU0Tj3kAZDb3k7l8hJze8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrKAnwMhA+5cIEKFRFKnLWYLEo94uFaARbe1AnRt2feexqxeq3jLUOvl6i7CxnOgS
         AAGx4WIPXt5wgLnTFOa1XWvtN4es0v/jI2RGRARTZE0z1hcujB0u/HjKVvf67ZlGDP
         rhlN/4kiRrCwNudzoqBaCS7SGvKF8ff2WiDUuUTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>, stable@kernel.org
Subject: [PATCH 4.9 124/157] ext4: dont use the orphan list when migrating an inode
Date:   Mon, 24 Jan 2022 19:43:34 +0100
Message-Id: <20220124183936.708241634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 6eeaf88fd586f05aaf1d48cb3a139d2a5c6eb055 upstream.

We probably want to remove the indirect block to extents migration
feature after a deprecation window, but until then, let's fix a
potential data loss problem caused by the fact that we put the
tmp_inode on the orphan list.  In the unlikely case where we crash and
do a journal recovery, the data blocks belonging to the inode being
migrated are also represented in the tmp_inode on the orphan list ---
and so its data blocks will get marked unallocated, and available for
reuse.

Instead, stop putting the tmp_inode on the oprhan list.  So in the
case where we crash while migrating the inode, we'll leak an inode,
which is not a disaster.  It will be easily fixed the next time we run
fsck, and it's better than potentially having blocks getting claimed
by two different files, and losing data as a result.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/migrate.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -462,12 +462,12 @@ int ext4_ext_migrate(struct inode *inode
 	percpu_down_write(&sbi->s_writepages_rwsem);
 
 	/*
-	 * Worst case we can touch the allocation bitmaps, a bgd
-	 * block, and a block to link in the orphan list.  We do need
-	 * need to worry about credits for modifying the quota inode.
+	 * Worst case we can touch the allocation bitmaps and a block
+	 * group descriptor block.  We do need need to worry about
+	 * credits for modifying the quota inode.
 	 */
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE,
-		4 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
+		3 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
 
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
@@ -488,10 +488,6 @@ int ext4_ext_migrate(struct inode *inode
 	 * Use the correct seed for checksum (i.e. the seed from 'inode').  This
 	 * is so that the metadata blocks will have the correct checksum after
 	 * the migration.
-	 *
-	 * Note however that, if a crash occurs during the migration process,
-	 * the recovery process is broken because the tmp_inode checksums will
-	 * be wrong and the orphans cleanup will fail.
 	 */
 	ei = EXT4_I(inode);
 	EXT4_I(tmp_inode)->i_csum_seed = ei->i_csum_seed;
@@ -503,7 +499,6 @@ int ext4_ext_migrate(struct inode *inode
 	clear_nlink(tmp_inode);
 
 	ext4_ext_tree_init(handle, tmp_inode);
-	ext4_orphan_add(handle, tmp_inode);
 	ext4_journal_stop(handle);
 
 	/*
@@ -528,12 +523,6 @@ int ext4_ext_migrate(struct inode *inode
 
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle)) {
-		/*
-		 * It is impossible to update on-disk structures without
-		 * a handle, so just rollback in-core changes and live other
-		 * work to orphan_list_cleanup()
-		 */
-		ext4_orphan_del(NULL, tmp_inode);
 		retval = PTR_ERR(handle);
 		goto out_tmp_inode;
 	}


