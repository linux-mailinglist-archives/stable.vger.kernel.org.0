Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DD601C7A
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 00:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJQWfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 18:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJQWfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 18:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EACB7C1DC;
        Mon, 17 Oct 2022 15:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF449B81B62;
        Mon, 17 Oct 2022 22:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725C1C433B5;
        Mon, 17 Oct 2022 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666046140;
        bh=zKAPfepYjBKRJxJNoCzKjVy/ysOKgv3HIjn9p3O6IyY=;
        h=Date:To:From:Subject:From;
        b=dQtwJ5ORrN7c5fdCQiDBuBmw2gbMGQuS1N8hSncqo9hGEPPYIKtW0TA2DBlqbvK+w
         Ad856kFaIFo5BFDRUUEXNZmefN2GndSR8pRIimp4ffB01Fok0kTNoKBTwDtcg9Ux4L
         kBqWfVNnVSs+uKL3I3C8Zm/koi6hhOdWgx92AoEU=
Date:   Mon, 17 Oct 2022 15:35:39 -0700
To:     mm-commits@vger.kernel.org, wangyan122@huawei.com,
        stable@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20221017223540.725C1C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG when iput after ocfs2_mknod fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails.patch

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
Subject: ocfs2: fix BUG when iput after ocfs2_mknod fails
Date: Mon, 17 Oct 2022 21:02:26 +0800

Commit b1529a41f777 "ocfs2: should reclaim the inode if
'__ocfs2_mknod_locked' returns an error" tried to reclaim the claimed
inode if __ocfs2_mknod_locked() fails later.  But this introduce a race,
the freed bit may be reused immediately by another thread, which will
update dinode, e.g.  i_generation.  Then iput this inode will lead to BUG:
inode->i_generation != le32_to_cpu(fe->i_generation)

We could make this inode as bad, but we did want to do operations like
wipe in some cases.  Since the claimed inode bit can only affect that an
dinode is missing and will return back after fsck, it seems not a big
problem.  So just leave it as is by revert the reclaim logic.

Link: https://lkml.kernel.org/r/20221017130227.234480-1-joseph.qi@linux.alibaba.com
Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
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

 fs/ocfs2/namei.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails
+++ a/fs/ocfs2/namei.c
@@ -632,18 +632,9 @@ static int ocfs2_mknod_locked(struct ocf
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct user_namespace *mnt_userns,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-bug-when-iput-after-ocfs2_mknod-fails.patch
ocfs2-clear-dinode-links-count-in-case-of-error.patch

