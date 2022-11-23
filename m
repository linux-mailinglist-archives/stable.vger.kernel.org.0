Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4B63534E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiKWIxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiKWIxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6970EA102
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:53:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57EB3B81EED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2ACC433D7;
        Wed, 23 Nov 2022 08:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193621;
        bh=eJ32gFH4TwdWqMcKFv9GJpYwWwY1GZohYFNEXdow3cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9Xhifoup6Whpy1jLUMYgqYf6RawpYWAUgZ9pcWhBcu0QAq8GnTgELkznhT38WS/5
         xPDiRVBEx4tYqe5XxQJukTAYb6VTPHCmCepLrr91Kzt+K9vBzALZQqB3QZRLnCsEf7
         HrcVgHbu2e0vHm0lKkcjuIf56fh8eAHhv7rQvHgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 18/76] nilfs2: fix deadlock in nilfs_count_free_blocks()
Date:   Wed, 23 Nov 2022 09:50:17 +0100
Message-Id: <20221123084547.323911131@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
@@ -704,9 +704,7 @@ int nilfs_count_free_blocks(struct the_n
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }


