Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFE622088
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiKHX6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKHX6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9654B6068C;
        Tue,  8 Nov 2022 15:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3334E617E2;
        Tue,  8 Nov 2022 23:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A56DC433D6;
        Tue,  8 Nov 2022 23:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951891;
        bh=kBieeZP7ebC1ESMLsmykoSU2QtaDOK8PQV+EQT7FxQo=;
        h=Date:To:From:Subject:From;
        b=F0GorJE7er1aLb/WCvIbw4Gz/YP+85sH0Huqm6qJtzr4Oo52G2WuHDHT2ayu1KE3t
         ocoWMWZNLv6KO7yfkmLGhD2uE/2X9PyFRfGdMBPGWF7brh8tB7UDNVjaJtLsSc4086
         u7SXnawRdMamoCf5skKrC2c9Qn84qsB96H9gbjJw=
Date:   Tue, 08 Nov 2022 15:58:11 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-deadlock-in-nilfs_count_free_blocks.patch removed from -mm tree
Message-Id: <20221108235811.8A56DC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix deadlock in nilfs_count_free_blocks()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-deadlock-in-nilfs_count_free_blocks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix deadlock in nilfs_count_free_blocks()
Date: Sat, 29 Oct 2022 13:49:12 +0900

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
---

 fs/nilfs2/the_nilfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-deadlock-in-nilfs_count_free_blocks
+++ a/fs/nilfs2/the_nilfs.c
@@ -690,9 +690,7 @@ int nilfs_count_free_blocks(struct the_n
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-shift-out-of-bounds-overflow-in-nilfs_sb2_bad_offset.patch
nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

