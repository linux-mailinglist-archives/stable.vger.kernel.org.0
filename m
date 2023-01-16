Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633A866C99C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbjAPQw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbjAPQv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CC624113
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E836661058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1439C433EF;
        Mon, 16 Jan 2023 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887037;
        bh=VUvGvQNX5a6RKrHa73IYYrDOiY0bhqeFvM5KwadAYKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRGSkJIHyfiCLNQd4/KNGAhNyvR9GiVDYY7N5M3csvwKV7NxekJURaSIwp6YuL9ee
         TD+fuzZiuBjVRgRTI/H7L7bZqBVQCediwSRtFowUGQKjDbzZBArKczbVqIBPsKLepf
         YzgLZWYtCtMC0kgrTCUlEZCrrO+rGMLtlEB3KSPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 657/658] ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
Date:   Mon, 16 Jan 2023 16:52:25 +0100
Message-Id: <20230116154939.514200362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heming Zhao <ocfs2-devel@oss.oracle.com>

commit 550842cc60987b269e31b222283ade3e1b6c7fc8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3396,10 +3396,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
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
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1922,8 +1922,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);


