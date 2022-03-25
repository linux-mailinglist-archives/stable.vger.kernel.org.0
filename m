Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A565B4E7BDC
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiCYVv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 17:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiCYVv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 17:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E143ECB;
        Fri, 25 Mar 2022 14:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21FC46104F;
        Fri, 25 Mar 2022 21:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79664C2BBE4;
        Fri, 25 Mar 2022 21:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648244991;
        bh=befP00TAyiEqfK47sz/4og2i/ze5u6nkmRIjj7lJxMI=;
        h=Date:To:From:Subject:From;
        b=f+/sI/T4l5oDOJyrrjRAN3wlohU9Qoms+udccG8r+HMFLbPnk4SgFe/c3I7UAvMB6
         VMoLQpbDFYHYFIBzpF5UKpZvwGjBfqDB1+8eu0r8r+yKOUpV4UL5vS/tcxbcjoXgyR
         wr4HV+d2UOkVnnRYyuyx1aBsB/wRcKaiGX7/LEZQ=
Date:   Fri, 25 Mar 2022 14:49:50 -0700
To:     mm-commits@vger.kernel.org, vvidic@valentin-vidic.from.hr,
        stable@vger.kernel.org, sathlerds@gmail.com,
        joseph.qi@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-crash-when-mount-with-quota-enabled.patch added to -mm tree
Message-Id: <20220325214951.79664C2BBE4@smtp.kernel.org>
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
     Subject: ocfs2: fix crash when mount with quota enabled
has been added to the -mm tree.  Its filename is
     ocfs2-fix-crash-when-mount-with-quota-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-crash-when-mount-with-quota-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-crash-when-mount-with-quota-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix crash when mount with quota enabled

There is a reported crash when mounting ocfs2 with quota enabled.

RIP: 0010:ocfs2_qinfo_lock_res_init+0x44/0x50 [ocfs2]
Call Trace:
<TASK>
ocfs2_local_read_info+0xb9/0x6f0 [ocfs2]
? ocfs2_local_check_quota_file+0x197/0x390 [ocfs2]
dquot_load_quota_sb+0x216/0x470
? preempt_count_add+0x68/0xa0
dquot_load_quota_inode+0x85/0x100
ocfs2_enable_quotas+0xa0/0x1c0 [ocfs2]
ocfs2_fill_super.cold+0xc8/0x1bf [ocfs2]
mount_bdev+0x185/0x1b0
? ocfs2_initialize_super.isra.0+0xf40/0xf40 [ocfs2]
legacy_get_tree+0x27/0x40
vfs_get_tree+0x25/0xb0
path_mount+0x465/0xac0
__x64_sys_mount+0x103/0x140
do_syscall_64+0x3b/0xc0
entry_SYSCALL_64_after_hwframe+0x44/0xae
</TASK>

It is caused by when initializing dqi_gqlock, the corresponding dqi_type
and dqi_sb are not properly initialized.  This issue is introduced by
commit 6c85c2c72819, which wants to avoid accessing uninitialized
variables in error cases.  So make global quota info properly initialized.

Link: https://lkml.kernel.org/r/20220323023644.40084-1-joseph.qi@linux.alibaba.com
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007141
Fixes: 6c85c2c72819 ("ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Dayvison <sathlerds@gmail.com>
Tested-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   23 ++++++++++++-----------
 fs/ocfs2/quota_local.c  |    2 --
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-crash-when-mount-with-quota-enabled
+++ a/fs/ocfs2/quota_global.c
@@ -337,7 +337,6 @@ void ocfs2_unlock_global_qf(struct ocfs2
 /* Read information header from global quota file */
 int ocfs2_global_read_info(struct super_block *sb, int type)
 {
-	struct inode *gqinode = NULL;
 	unsigned int ino[OCFS2_MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
 					      GROUP_QUOTA_SYSTEM_INODE };
 	struct ocfs2_global_disk_dqinfo dinfo;
@@ -346,29 +345,31 @@ int ocfs2_global_read_info(struct super_
 	u64 pcount;
 	int status;
 
+	oinfo->dqi_gi.dqi_sb = sb;
+	oinfo->dqi_gi.dqi_type = type;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
+	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
+	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
+	oinfo->dqi_gqi_bh = NULL;
+	oinfo->dqi_gqi_count = 0;
+
 	/* Read global header */
-	gqinode = ocfs2_get_system_file_inode(OCFS2_SB(sb), ino[type],
+	oinfo->dqi_gqinode = ocfs2_get_system_file_inode(OCFS2_SB(sb), ino[type],
 			OCFS2_INVALID_SLOT);
-	if (!gqinode) {
+	if (!oinfo->dqi_gqinode) {
 		mlog(ML_ERROR, "failed to get global quota inode (type=%d)\n",
 			type);
 		status = -EINVAL;
 		goto out_err;
 	}
-	oinfo->dqi_gi.dqi_sb = sb;
-	oinfo->dqi_gi.dqi_type = type;
-	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
-	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
-	oinfo->dqi_gqi_bh = NULL;
-	oinfo->dqi_gqi_count = 0;
-	oinfo->dqi_gqinode = gqinode;
+
 	status = ocfs2_lock_global_qf(oinfo, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_err;
 	}
 
-	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
+	status = ocfs2_extent_map_get_blocks(oinfo->dqi_gqinode, 0, &oinfo->dqi_giblk,
 					     &pcount, NULL);
 	if (status < 0)
 		goto out_unlock;
--- a/fs/ocfs2/quota_local.c~ocfs2-fix-crash-when-mount-with-quota-enabled
+++ a/fs/ocfs2/quota_local.c
@@ -702,8 +702,6 @@ static int ocfs2_local_read_info(struct
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
-	oinfo->dqi_gqinode = NULL;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-crash-when-mount-with-quota-enabled.patch

