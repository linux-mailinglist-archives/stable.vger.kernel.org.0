Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33595FBF05
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 04:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJLCGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 22:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJLCGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 22:06:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ACD7E82F;
        Tue, 11 Oct 2022 19:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBD54B818CA;
        Wed, 12 Oct 2022 02:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C422C433D7;
        Wed, 12 Oct 2022 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665540366;
        bh=IqRavcZ9DuV0ATv07+MGKBOzKm/aPG2lim3GbVDuOKI=;
        h=Date:To:From:Subject:From;
        b=pj8bu6KeBFfCJUiDrry2EyI2K4ZAkzcGyijKYqOiBPTvkjaCmbLF6UAdWq6ypZ9W3
         br1NAij9KrN4R8/SNLq0u1x7DBAoo3jAoIxF+sKn72VJimr9t4Qe2+B7wq2Qhd8NHe
         dfeHX+jIUAwjWZXWfeR6tICBWMOtA9B0FBg/ezS0=
Date:   Tue, 11 Oct 2022 19:06:05 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch removed from -mm tree
Message-Id: <20221012020606.5C422C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
Date: Sun, 2 Oct 2022 12:08:04 +0900

If the i_mode field in inode of metadata files is corrupted on disk, it
can cause the initialization of bmap structure, which should have been
called from nilfs_read_inode_common(), not to be called.  This causes a
lockdep warning followed by a NULL pointer dereference at
nilfs_bmap_lookup_at_level().

This patch fixes these issues by adding a missing sanitiy check for the
i_mode field of metadata file's inode.

Link: https://lkml.kernel.org/r/20221002030804.29978-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/inode.c~nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level
+++ a/fs/nilfs2/inode.c
@@ -455,6 +455,8 @@ int nilfs_read_inode_common(struct inode
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch

