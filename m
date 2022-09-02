Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17835AB8DD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 21:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiIBT0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 15:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIBT0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 15:26:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859F4FB284;
        Fri,  2 Sep 2022 12:26:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B76608CD;
        Fri,  2 Sep 2022 19:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79235C433D6;
        Fri,  2 Sep 2022 19:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662146794;
        bh=AexgeAdsFhSAVfIJLFjvTuCgd3PmbuZfA2HEKBKnbcM=;
        h=Date:To:From:Subject:From;
        b=hs8eKQiRI1DrSNihgr8GbOuU+TDPJiu7cs2CJPBNd1pL9We7pzqPx4+9LeU5kFQqA
         xw2uSTM/U8oCAZ3BAtsarRyW849h6fbHNLZknJGTfngk2IZr4za0m2IzDnSDMf4ApM
         HgMI2mAIvoMUYL4YQYULcmNkcM5OL9YpFfkF4L3s=
Date:   Fri, 02 Sep 2022 12:26:33 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-fix-memory-leak-when-using.patch added to mm-hotfixes-unstable branch
Message-Id: <20220902192634.79235C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: fix memory leak when using
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-dbgfs-fix-memory-leak-when-using.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-fix-memory-leak-when-using.patch

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
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm/damon/dbgfs: fix memory leak when using
Date: Fri, 2 Sep 2022 19:11:49 +0000

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  Fix this up by properly calling
dput().

Link: https://lkml.kernel.org/r/20220902191149.112434-1-sj@kernel.org
Fixes: 75c1c2b53c78b ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-fix-memory-leak-when-using
+++ a/mm/damon/dbgfs.c
@@ -884,6 +884,7 @@ static int dbgfs_rm_context(char *name)
 	struct dentry *root, *dir, **new_dirs;
 	struct damon_ctx **new_ctxs;
 	int i, j;
+	int ret = 0;
 
 	if (damon_nr_running_ctxs())
 		return -EBUSY;
@@ -898,14 +899,16 @@ static int dbgfs_rm_context(char *name)
 
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
-	if (!new_dirs)
-		return -ENOMEM;
+	if (!new_dirs) {
+		ret = -ENOMEM;
+		goto out_dput;
+	}
 
 	new_ctxs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_ctxs),
 			GFP_KERNEL);
 	if (!new_ctxs) {
-		kfree(new_dirs);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_new_dirs;
 	}
 
 	for (i = 0, j = 0; i < dbgfs_nr_ctxs; i++) {
@@ -925,7 +928,13 @@ static int dbgfs_rm_context(char *name)
 	dbgfs_ctxs = new_ctxs;
 	dbgfs_nr_ctxs--;
 
-	return 0;
+	goto out_dput;
+
+out_new_dirs:
+	kfree(new_dirs);
+out_dput:
+	dput(dir);
+	return ret;
 }
 
 static ssize_t dbgfs_rm_context_write(struct file *file,
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

mm-damon-dbgfs-fix-memory-leak-when-using.patch

