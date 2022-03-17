Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5614DD0F0
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 23:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiCQW5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 18:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiCQW5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 18:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753422B4A70;
        Thu, 17 Mar 2022 15:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 029C960C08;
        Thu, 17 Mar 2022 22:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55856C340E9;
        Thu, 17 Mar 2022 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647557779;
        bh=5qbAqkwx9UEn2LB8qMMC6EQFl20SvwMOK3Tdj+788TQ=;
        h=Date:To:From:Subject:From;
        b=Ld5Pvr3ALOTSC01fpdcvjb5hlaC+B6s++TKxLZZtLBt0Rq1CGGgv7K31w2Q+gXRLG
         pnoRKMbVL+KK3S0aWkafXElE8+FVo4ee3x6pF7wgHcyEO344jEJFRudCpq3C5URTV8
         TFqQ6jjjZAjH1W+rM33jJGuoPKk8B1Jl4xJOCj8U=
Date:   Thu, 17 Mar 2022 15:56:18 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        joseph.qi@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch removed from -mm tree
Message-Id: <20220317225619.55856C340E9@smtp.kernel.org>
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
     Subject: ocfs2: fix crash when initialize filecheck kobj fails
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-crash-when-initialize-filecheck-kobj-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix crash when initialize filecheck kobj fails

Once s_root is set, genric_shutdown_super() will be called if fill_super()
fails.  That means, we will call ocfs2_dismount_volume() twice in such
case, which can lead to kernel crash.  Fix this issue by initializing
filecheck kobj before setting s_root.

Link: https://lkml.kernel.org/r/20220310081930.86305-1-joseph.qi@linux.alibaba.com
Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-crash-when-initialize-filecheck-kobj-fails
+++ a/fs/ocfs2/super.c
@@ -1105,17 +1105,6 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
-	root = d_make_root(inode);
-	if (!root) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root;
-
-	ocfs2_complete_mount_recovery(osb);
-
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
 	if (!osb->osb_dev_kset) {
@@ -1133,6 +1122,17 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
+	root = d_make_root(inode);
+	if (!root) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
+	sb->s_root = root;
+
+	ocfs2_complete_mount_recovery(osb);
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cleanup-some-return-variables.patch

