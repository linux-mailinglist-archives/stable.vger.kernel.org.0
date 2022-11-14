Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4CA628088
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbiKNNGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbiKNNGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:06:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D132A974
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC686117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80719C433C1;
        Mon, 14 Nov 2022 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431194;
        bh=3/nS9cBNPeZvjK8qdD5rfSxsGVWJQO7Isn6O6l3dF/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqUv3MSRJtGNMFudjY3wUVME2DsDoNFJvMA+3O6f8a9Gz8j4zXg/QOdI2RkpOXcAx
         nY7uFQHs/7aEHNGL4JEbeHjp0ss9+0OEcDbGB+uAC7130+VTBEYp1WJWA0U8iZNtz1
         53s7BHlD20RWEaK0XYMcGTyzDn1RItoh/ooJrfT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 134/190] nilfs2: fix deadlock in nilfs_count_free_blocks()
Date:   Mon, 14 Nov 2022 13:45:58 +0100
Message-Id: <20221114124504.652482817@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 8ac932a4921a96ca52f61935dbba64ea87bbd5dc upstream.

A semaphore deadlock can occur if nilfs_get_block() detects metadata
corruption while locating data blocks and a superblock writeback occurs at
the same time:

task 1                               task 2
------                               ------
* A file operation *
nilfs_truncate()
  nilfs_get_block()
    down_read(rwsem A) <--
    nilfs_bmap_lookup_contig()
      ...                            generic_shutdown_super()
                                       nilfs_put_super()
                                         * Prepare to write superblock *
                                         down_write(rwsem B) <--
                                         nilfs_cleanup_super()
      * Detect b-tree corruption *         nilfs_set_log_cursor()
      nilfs_bmap_convert_error()             nilfs_count_free_blocks()
        __nilfs_error()                        down_read(rwsem A) <--
          nilfs_set_error()
            down_write(rwsem B) <--

                           *** DEADLOCK ***

Here, nilfs_get_block() readlocks rwsem A (= NILFS_MDT(dat_inode)->mi_sem)
and then calls nilfs_bmap_lookup_contig(), but if it fails due to metadata
corruption, __nilfs_error() is called from nilfs_bmap_convert_error()
inside the lock section.

Since __nilfs_error() calls nilfs_set_error() unless the filesystem is
read-only and nilfs_set_error() attempts to writelock rwsem B (=
nilfs->ns_sem) to write back superblock exclusively, hierarchical lock
acquisition occurs in the order rwsem A -> rwsem B.

Now, if another task starts updating the superblock, it may writelock
rwsem B during the lock sequence above, and can deadlock trying to
readlock rwsem A in nilfs_count_free_blocks().

However, there is actually no need to take rwsem A in
nilfs_count_free_blocks() because it, within the lock section, only reads
a single integer data on a shared struct with
nilfs_sufile_get_ncleansegs().  This has been the case after commit
aa474a220180 ("nilfs2: add local variable to cache the number of clean
segments"), that is, even before this bug was introduced.

So, this resolves the deadlock problem by just not taking the semaphore in
nilfs_count_free_blocks().

Link: https://lkml.kernel.org/r/20221029044912.9139-1-konishi.ryusuke@gmail.com
Fixes: e828949e5b42 ("nilfs2: call nilfs_error inside bmap routines")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[2.6.38+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/the_nilfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -690,9 +690,7 @@ int nilfs_count_free_blocks(struct the_n
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }


