Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1E611C27
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJ1VHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJ1VHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:07:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489011DE3D3;
        Fri, 28 Oct 2022 14:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD5DB82CA3;
        Fri, 28 Oct 2022 21:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849C1C433C1;
        Fri, 28 Oct 2022 21:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991222;
        bh=M5943/C/0CCuo2646kfYMqniMl1r5KhlhuWdYL91h0g=;
        h=Date:To:From:Subject:From;
        b=QZS9QE41lHCd68o6XhXhJN6+eNN9TMJjOZ0cpm/p7QFcslyq8CvOqzjbSdMjtAulX
         UDgXlgUrclkSm6mq957vfPowGmHSwD1Y++ooB8lGCWh5fuivq1Z/Md1z0LvZFV/uTV
         hMVxwQJMBCqmLcCnYONsN/B4K4X8WUib5roPZ5tM=
Date:   Fri, 28 Oct 2022 14:07:01 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        srw@sladewatkins.net, regressions@leemhuis.info,
        mirsad.todorovac@alu.unizg.hr, marcmiltenberger@gmail.com,
        hsinyi@chromium.org, dimitri.ledkov@canonical.com,
        bagasdotme@gmail.com, phillip@squashfs.org.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-fix-extending-readahead-beyond-end-of-file.patch removed from -mm tree
Message-Id: <20221028210702.849C1C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix extending readahead beyond end of file
has been removed from the -mm tree.  Its filename was
     squashfs-fix-extending-readahead-beyond-end-of-file.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix extending readahead beyond end of file
Date: Thu, 20 Oct 2022 23:36:15 +0100

The readahead code will try to extend readahead to the entire size of the
Squashfs data block.

But, it didn't take into account that the last block at the end of the
file may not be a whole block.  In this case, the code would extend
readahead to beyond the end of the file, leaving trailing pages.

Fix this by only requesting the expected number of pages.

Link: https://lkml.kernel.org/r/20221020223616.7571-3-phillip@squashfs.org.uk
Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Marc Miltenberger <marcmiltenberger@gmail.com>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Slade Watkins <srw@sladewatkins.net>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/squashfs/file.c~squashfs-fix-extending-readahead-beyond-end-of-file
+++ a/fs/squashfs/file.c
@@ -559,6 +559,12 @@ static void squashfs_readahead(struct re
 		unsigned int expected;
 		struct page *last_page;
 
+		expected = start >> msblk->block_log == file_end ?
+			   (i_size_read(inode) & (msblk->block_size - 1)) :
+			    msblk->block_size;
+
+		max_pages = (expected + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
 		nr_pages = __readahead_batch(ractl, pages, max_pages);
 		if (!nr_pages)
 			break;
@@ -567,13 +573,10 @@ static void squashfs_readahead(struct re
 			goto skip_pages;
 
 		index = pages[0]->index >> shift;
+
 		if ((pages[nr_pages - 1]->index >> shift) != index)
 			goto skip_pages;
 
-		expected = index == file_end ?
-			   (i_size_read(inode) & (msblk->block_size - 1)) :
-			    msblk->block_size;
-
 		if (index == file_end && squashfs_i(inode)->fragment_block !=
 						SQUASHFS_INVALID_BLK) {
 			res = squashfs_readahead_fragment(pages, nr_pages,
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


