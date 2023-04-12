Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF16DEE15
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjDLIko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjDLIjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287157EE8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98C6A62FEF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875CAC433D2;
        Wed, 12 Apr 2023 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288561;
        bh=X29n4gCYrtrGfJFPq5gqUwdb7FP/EHXGdJZU3HXmQkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9APkka0HOla5Y5ceAif4U/ZusKyg3cEKv8oZ9x4w1ug0OsUiTa1bd/Oj7dDflKxe
         tH4CgZwhf2zC2tj+Smp1Bq76sdAlzWnosTWdZtSYHKmv5Oft0zlDkN25M9xiWRVVOo
         kWhFY4QTnTRHchLR8KHu7Zp2KksoxqyxLSy8U2XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/93] ocfs2: rewrite error handling of ocfs2_fill_super
Date:   Wed, 12 Apr 2023 10:33:10 +0200
Message-Id: <20230412082823.426922432@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

[ Upstream commit f1e75d128b46e3b066e7b2e7cfca10491109d44d ]

Current ocfs2_fill_super() uses one goto label "read_super_error" to
handle all error cases.  And with previous serial patches, the error
handling should fork more branches to handle different error cases.  This
patch rewrite the error handling of ocfs2_fill_super.

Link: https://lkml.kernel.org/r/20220424130952.2436-6-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 017f809e54401..64795f836550f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -980,28 +980,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto out;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0)
+		goto out;
+
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out_super;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1018,7 +1017,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1032,7 +1031,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1050,9 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1068,10 +1065,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
+	if (status < 0)
+		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
@@ -1085,15 +1080,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto out_debugfs;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1101,7 +1095,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1110,14 +1104,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	sb->s_root = root;
@@ -1164,17 +1157,21 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	return status;
 
-read_super_error:
-	brelse(bh);
-
-	if (status)
-		mlog_errno(status);
+out_dismount:
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_dismount_volume(sb, 1);
+	goto out;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+out_debugfs:
+	debugfs_remove_recursive(osb->osb_debug_root);
+out_super:
+	ocfs2_release_system_inodes(osb);
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+out:
+	mlog_errno(status);
 
 	return status;
 }
-- 
2.39.2



