Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CCF5975CB
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiHQSdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiHQSdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE552501B0;
        Wed, 17 Aug 2022 11:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6763EB81EB6;
        Wed, 17 Aug 2022 18:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFD8C433C1;
        Wed, 17 Aug 2022 18:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660761191;
        bh=h0aDeNAQk2+6XVbjV+tga/UUib0hGg7WqW+gjSy8Z/M=;
        h=Date:To:From:Subject:From;
        b=ysqkjskV8LDFylJkFkxrQj4bwFJpB2ZoVJI4r2x/kR6MEh8OYMMJvrD3W8pSN8asF
         gXRPrJ2aiN/Jm7FuLuMEooldRyCbk4VygZ7rvIL6RmggaexquQw5J387rVia1O95wW
         GRbPD7kE94p29tpauaNpKSnbiItJv60wYnrZkA7c=
Date:   Wed, 17 Aug 2022 11:33:10 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch added to mm-hotfixes-unstable branch
Message-Id: <20220817183311.1BFD8C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
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

ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

