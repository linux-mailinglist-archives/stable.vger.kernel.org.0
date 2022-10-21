Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79D3606C8D
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJUAlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJUAlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704494361E;
        Thu, 20 Oct 2022 17:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4CD608C1;
        Fri, 21 Oct 2022 00:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43196C433D6;
        Fri, 21 Oct 2022 00:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666312841;
        bh=GBeN1oBD5bc+Msx8UlG3FBeBC85zLmPYoHe+HNkJRAs=;
        h=Date:To:From:Subject:From;
        b=aqYCT5PKj1CLfvfscPcrCH0E0J64Vcu8NNLDfC/4aqr/P9HyOWsYGhuyfEvyzwuc1
         H8s9mpCGomr26D1O0mtdANnxgRHI6WHhy70/RILlqydGBhxaNSjUG87/JCAgS+rP0/
         Wzhlciy6tos5NAx8rXpVPFnc3FnfJdPmh7eEN2a8=
Date:   Thu, 20 Oct 2022 17:40:40 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        srw@sladewatkins.net, regressions@leemhuis.info,
        mirsad.todorovac@alu.unizg.hr, hsinyi@chromium.org,
        dimitri.ledkov@canonical.com, bagasdotme@gmail.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-extending-readahead-beyond-end-of-file.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021004041.43196C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix extending readahead beyond end of file
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-extending-readahead-beyond-end-of-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-extending-readahead-beyond-end-of-file.patch

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
Cc: <stable@vger.kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Slade Watkins <srw@sladewatkins.net>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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

squashfs-fix-read-regression-introduced-in-readahead-code.patch
squashfs-fix-extending-readahead-beyond-end-of-file.patch
squashfs-fix-buffer-release-race-condition-in-readahead-code.patch

