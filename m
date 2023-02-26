Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC616A33FB
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 21:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBZUic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 15:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjBZUia (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 15:38:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B4AD19;
        Sun, 26 Feb 2023 12:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A8D60BDE;
        Sun, 26 Feb 2023 20:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71697C433D2;
        Sun, 26 Feb 2023 20:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677443907;
        bh=HkIOnVEs/UFtcw7OaoA5EAHHOx2whzslf0MlL36OnPQ=;
        h=Date:To:From:Subject:From;
        b=mX9D/bj6VVt9e2AAEoC0m00xEXvrOh6NzpiFxM8kYQE7q9cYYZUWM+KRgTovaUpnn
         hf23jGU1M6AnR8QarrzeqdeTg8Yk/bfql57DR7vkRfFfUz0egOq7htyJddZgqGoUtA
         6Fe7JwsFUvpeXn9+q6qukxYNfGR1J8OZqCAfNqHk=
Date:   Sun, 26 Feb 2023 12:38:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+8ce7f8308d91e6b8bbe2@syzkaller.appspotmail.com,
        stable@vger.kernel.org, nico@fluxnic.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-cramfs-inodec-initialize-file_ra_state.patch added to mm-hotfixes-unstable branch
Message-Id: <20230226203827.71697C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/cramfs/inode.c: initialize file_ra_state
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-cramfs-inodec-initialize-file_ra_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-cramfs-inodec-initialize-file_ra_state.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/cramfs/inode.c: initialize file_ra_state
Date: Sun Feb 26 12:31:11 PM PST 2023

file_ra_state_init() assumes that the file_ra_state has been zeroed out. 
Fixes a KMSAN used-unintialized issue (at least).

Fixes: cf948cbc35e80 ("cramfs: read_mapping_page() is synchronous")
Reported-by: syzbot <syzbot+8ce7f8308d91e6b8bbe2@syzkaller.appspotmail.com>
  Link: https://lkml.kernel.org/r/0000000000008f74e905f56df987@google.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/cramfs/inode.c~fs-cramfs-inodec-initialize-file_ra_state
+++ b/fs/cramfs/inode.c
@@ -183,7 +183,7 @@ static void *cramfs_blkdev_read(struct super_block *sb, unsigned int offset,
 				unsigned int len)
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
-	struct file_ra_state ra;
+	struct file_ra_state ra = {};
 	struct page *pages[BLKS_PER_BUF];
 	unsigned i, blocknr, buffer;
 	unsigned long devsize;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-cramfs-inodec-initialize-file_ra_state.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

