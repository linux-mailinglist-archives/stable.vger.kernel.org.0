Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535155A3FC7
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiH1VDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiH1VDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 17:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F81231237;
        Sun, 28 Aug 2022 14:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 088AE60E98;
        Sun, 28 Aug 2022 21:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC83C433C1;
        Sun, 28 Aug 2022 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720611;
        bh=kl9Qkhx458qe7eNXjn7ZBSd4VQOpDEZgiTu7c9T5dMI=;
        h=Date:To:From:Subject:From;
        b=YrLm2Fc8OP6wQNPZBVBU4NV0juqY1IsdAw5n7fNi/eLsXTWEDJAOeHzM65oSUUQsA
         q46AzPgPu4/zB1PniVLTsTzt39yc2h7FIG6ap0pBNUGyP7T/zSZavuoSrNnPY9ay/t
         huFcGOh4AisUkBXjHLcZTe3EBCrvNBhI89kp1NgM=
Date:   Sun, 28 Aug 2022 14:03:30 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch removed from -mm tree
Message-Id: <20220828210331.5AC83C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
Date: Mon, 15 Aug 2022 16:57:54 +0800

After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
before return error"), any procedure after ocfs2_dlm_init() fails will
trigger crash when calling ocfs2_dlm_shutdown().

ie: On local mount mode, no dlm resource is initialized.  If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling will call
ocfs2_dlm_shutdown(), then does dlm resource cleanup job, which will
trigger kernel crash.

This solution should bypass uninitialized resources in
ocfs2_dlm_shutdown().

Link: https://lkml.kernel.org/r/20220815085754.20417-1-heming.zhao@suse.com
Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/super.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/super.c
@@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are


