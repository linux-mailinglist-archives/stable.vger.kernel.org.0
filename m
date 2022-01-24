Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141AB49897E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343935AbiAXS4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:56:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51876 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343997AbiAXSxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:53:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 387FAB8121C;
        Mon, 24 Jan 2022 18:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8EC36AE9;
        Mon, 24 Jan 2022 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050380;
        bh=sTTgpgmbUcfDJ3e7vQshhsXsvJ02IkzeYILauBlTR2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTZmIJ5Bm0gP/comaZwtf0CJ/rjU5liQSdl8lSJAEcI0usiv4IdGMQAxfDFLwK4DL
         MZy2y5Qn2WIWSI4URkSK3b0VTFgSpB/z8Px2BRRD5wNjDgeaS2Vf96HstL/Cb2ZKTZ
         80K3I9b6s2mfFvD/1oETTe9TPrEnO+OVeYfdD8+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>, stable@kernel.org
Subject: [PATCH 4.4 100/114] ext4: dont use the orphan list when migrating an inode
Date:   Mon, 24 Jan 2022 19:43:15 +0100
Message-Id: <20220124183930.198387689@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
@@ -459,12 +459,12 @@ int ext4_ext_migrate(struct inode *inode
 		return retval;
 
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
@@ -485,10 +485,6 @@ int ext4_ext_migrate(struct inode *inode
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
@@ -500,7 +496,6 @@ int ext4_ext_migrate(struct inode *inode
 	clear_nlink(tmp_inode);
 
 	ext4_ext_tree_init(handle, tmp_inode);
-	ext4_orphan_add(handle, tmp_inode);
 	ext4_journal_stop(handle);
 
 	/*
@@ -525,12 +520,6 @@ int ext4_ext_migrate(struct inode *inode
 
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle)) {
-		/*
-		 * It is impossible to update on-disk structures without
-		 * a handle, so just rollback in-core changes and live other
-		 * work to orphan_list_cleanup()
-		 */
-		ext4_orphan_del(NULL, tmp_inode);
 		retval = PTR_ERR(handle);
 		goto out;
 	}


