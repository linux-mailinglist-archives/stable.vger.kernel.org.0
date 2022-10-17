Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258C6601C7B
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 00:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJQWfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 18:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJQWfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 18:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211857C1FD;
        Mon, 17 Oct 2022 15:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB63B812A7;
        Mon, 17 Oct 2022 22:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF08C433C1;
        Mon, 17 Oct 2022 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666046142;
        bh=oeHCQ3uoyoQ8S+1KDWYCpGdJXoweyo1r66KHWiTYqGg=;
        h=Date:To:From:Subject:From;
        b=YWPEVz9Nr9YhDm0EfOebGchcadNWonNUtyWmRFnbeo4gZOsXqzK4DKvKF15fpzePy
         LRS1S+vZLvLlt+HyWDO5uhOYm3tJPwcn8sKmRJm6AzNGq65hwpdIBMoCy+bjtUGht4
         jAVOWLyvPOhib45ZjUe0oLFzDuG5Xo5j86ZbDCQs=
Date:   Mon, 17 Oct 2022 15:35:41 -0700
To:     mm-commits@vger.kernel.org, wangyan122@huawei.com,
        stable@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-clear-dinode-links-count-in-case-of-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20221017223542.7CF08C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: clear dinode links count in case of error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-clear-dinode-links-count-in-case-of-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-clear-dinode-links-count-in-case-of-error.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: clear dinode links count in case of error
Date: Mon, 17 Oct 2022 21:02:27 +0800

In ocfs2_mknod(), if error occurs after dinode successfully allocated,
ocfs2 i_links_count will not be 0.

So even though we clear inode i_nlink before iput in error handling, it
still won't wipe inode since we'll refresh inode from dinode during inode
lock.  So just like clear inode i_nlink, we clear ocfs2 i_links_count as
well.  Also do the same change for ocfs2_symlink().

Link: https://lkml.kernel.org/r/20221017130227.234480-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Yan Wang <wangyan122@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-clear-dinode-links-count-in-case-of-error
+++ a/fs/ocfs2/namei.c
@@ -232,6 +232,7 @@ static int ocfs2_mknod(struct user_names
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -382,6 +383,7 @@ static int ocfs2_mknod(struct user_names
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -454,8 +456,11 @@ roll_back:
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -2019,8 +2024,11 @@ bail:
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails.patch
ocfs2-clear-dinode-links-count-in-case-of-error.patch

