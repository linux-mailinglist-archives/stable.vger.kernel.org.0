Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE46A90A1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 06:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCCFzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 00:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCCFzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 00:55:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85C538B46;
        Thu,  2 Mar 2023 21:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53D27B81643;
        Fri,  3 Mar 2023 05:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E265EC433EF;
        Fri,  3 Mar 2023 05:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822904;
        bh=dIca24aYRQSsXX5y5ijaP01752qQCSAmIqNwIRIXgQM=;
        h=Date:To:From:Subject:From;
        b=S+8hQ+6N6A2iKPTlGp7hf/ZhQ6JKb1RboGV56iLcGZNvlXfeAzIX7MADkzePibWJA
         GWZn9kEzP5wh7sYeUwQxu08LVCUNni7dyoxZCZuZI4xTrfLyknnKSUv+5R6t83VsRR
         xRQzs8+UisDZo7WH17617QeTJVpOr3Ht98k4mHAc=
Date:   Thu, 02 Mar 2023 21:55:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+8ce7f8308d91e6b8bbe2@syzkaller.appspotmail.com,
        stable@vger.kernel.org, nico@fluxnic.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-cramfs-inodec-initialize-file_ra_state.patch removed from -mm tree
Message-Id: <20230303055503.E265EC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: fs/cramfs/inode.c: initialize file_ra_state
has been removed from the -mm tree.  Its filename was
     fs-cramfs-inodec-initialize-file_ra_state.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
+++ a/fs/cramfs/inode.c
@@ -183,7 +183,7 @@ static void *cramfs_blkdev_read(struct s
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

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

