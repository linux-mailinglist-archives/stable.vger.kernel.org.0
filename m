Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6A9606C8F
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJUAlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJUAlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:41:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1537710325B;
        Thu, 20 Oct 2022 17:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE962B829FC;
        Fri, 21 Oct 2022 00:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647FCC433C1;
        Fri, 21 Oct 2022 00:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666312843;
        bh=ZsdRFRqnP5OGXdTvNw4+JP3l4BNA6aMSRCseQH+PPd8=;
        h=Date:To:From:Subject:From;
        b=Uet8L3DrhW0M/MLKTNow0k8NIlg1zs23gqgUxVGZiB6hk8XHJH/LQlVJ5It3GTfcu
         Ust5eqMUv6nFfpVf1aSH0EPGGGvBzeAM+UNd6dUERlhKplvm0RpOmnEb7+CPdYJWiP
         9VunjhYRy+GSGxG717wrotynpzsTLxizPoWQiRk8=
Date:   Thu, 20 Oct 2022 17:40:42 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        srw@sladewatkins.net, regressions@leemhuis.info,
        mirsad.todorovac@alu.unizg.hr, hsinyi@chromium.org,
        dimitri.ledkov@canonical.com, bagasdotme@gmail.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-buffer-release-race-condition-in-readahead-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20221021004043.647FCC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix buffer release race condition in readahead code
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-buffer-release-race-condition-in-readahead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-buffer-release-race-condition-in-readahead-code.patch

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
Subject: squashfs: fix buffer release race condition in readahead code
Date: Thu, 20 Oct 2022 23:36:16 +0100

Fix a buffer release race condition, where the error value was used after
release.

Link: https://lkml.kernel.org/r/20221020223616.7571-4-phillip@squashfs.org.uk
Fixes: b09a7a036d20 ("squashfs: support reading fragments in readahead call")
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

 fs/squashfs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/squashfs/file.c~squashfs-fix-buffer-release-race-condition-in-readahead-code
+++ a/fs/squashfs/file.c
@@ -506,8 +506,9 @@ static int squashfs_readahead_fragment(s
 		squashfs_i(inode)->fragment_size);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+	int error = buffer->error;
 
-	if (buffer->error)
+	if (error)
 		goto out;
 
 	expected += squashfs_i(inode)->fragment_offset;
@@ -529,7 +530,7 @@ static int squashfs_readahead_fragment(s
 
 out:
 	squashfs_cache_put(buffer);
-	return buffer->error;
+	return error;
 }
 
 static void squashfs_readahead(struct readahead_control *ractl)
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-read-regression-introduced-in-readahead-code.patch
squashfs-fix-extending-readahead-beyond-end-of-file.patch
squashfs-fix-buffer-release-race-condition-in-readahead-code.patch

