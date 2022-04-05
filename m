Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDC14F2EE1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347536AbiDEJ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiDEIu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060816550;
        Tue,  5 Apr 2022 01:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88B561517;
        Tue,  5 Apr 2022 08:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6458C385A1;
        Tue,  5 Apr 2022 08:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147892;
        bh=r14M1DWPwRyo4+jvdjnECycfq43gChG0BjIE5UEYJjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIeo2BWjapJjfgQtITzQLciyGyxtlacO20rxqWjr9Emx9b/Sw5Bng3/WhpWiSwRFs
         8nCMfJ5uBEqojBE16bsKJtuk/oJ2RiyJj0ux/6zOZj1o9nxurkH1sMO9gde/p5/cvA
         6tT57ZfmSjJ7B8oZ5A01Pm9w9TJM/PsXZLdhS6JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Dayvison <sathlerds@gmail.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0111/1017] ocfs2: fix crash when mount with quota enabled
Date:   Tue,  5 Apr 2022 09:17:04 +0200
Message-Id: <20220405070357.491220852@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit de19433423c7bedabbd4f9a25f7dbc62c5e78921 upstream.

There is a reported crash when mounting ocfs2 with quota enabled.

  RIP: 0010:ocfs2_qinfo_lock_res_init+0x44/0x50 [ocfs2]
  Call Trace:
    ocfs2_local_read_info+0xb9/0x6f0 [ocfs2]
    dquot_load_quota_sb+0x216/0x470
    dquot_load_quota_inode+0x85/0x100
    ocfs2_enable_quotas+0xa0/0x1c0 [ocfs2]
    ocfs2_fill_super.cold+0xc8/0x1bf [ocfs2]
    mount_bdev+0x185/0x1b0
    legacy_get_tree+0x27/0x40
    vfs_get_tree+0x25/0xb0
    path_mount+0x465/0xac0
    __x64_sys_mount+0x103/0x140

It is caused by when initializing dqi_gqlock, the corresponding dqi_type
and dqi_sb are not properly initialized.

This issue is introduced by commit 6c85c2c72819, which wants to avoid
accessing uninitialized variables in error cases.  So make global quota
info properly initialized.

Link: https://lkml.kernel.org/r/20220323023644.40084-1-joseph.qi@linux.alibaba.com
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007141
Fixes: 6c85c2c72819 ("ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Dayvison <sathlerds@gmail.com>
Tested-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_global.c |   23 ++++++++++++-----------
 fs/ocfs2/quota_local.c  |    2 --
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
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
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -702,8 +702,6 @@ static int ocfs2_local_read_info(struct
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
-	oinfo->dqi_gqinode = NULL;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;


