Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2410460053A
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 04:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiJQC3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 22:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJQC3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 22:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97249A442;
        Sun, 16 Oct 2022 19:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A33560E73;
        Mon, 17 Oct 2022 02:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EC4C433D7;
        Mon, 17 Oct 2022 02:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665973770;
        bh=Gs+6B4mhV2N0FYGTP4/RTilwvWQguzb6NNd4ni0JUlk=;
        h=Date:To:From:Subject:From;
        b=IuBVLxtILu7E4Xdb8ThsVA6vRvlvp08qO/8tn1q+Xn9X1gxxGesnqZKEzIL5ngUOh
         LPqlM0A0jZV6u4xTYxk3SN4trz/+87cLFKcZs3vad1xSfshKZaHR71MbOrtlTNAfQ5
         UgaF36WFJNIDIHJ0//K1lszZ8IY/KsPaXM1bs6/M=
Date:   Sun, 16 Oct 2022 19:29:29 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, ghe@suse.com,
        gechangwei@live.cn, wangyan122@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch removed from -mm tree
Message-Id: <20221017022930.72EC4C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: clear links count in ocfs2_mknod() if an error occurs
has been removed from the -mm tree.  Its filename was
     ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: clear links count in ocfs2_mknod() if an error occurs

In this condition, the inode can not be wiped when error happened.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        ->ocfs2_set_links_count() // i_links_count is 2
    -> ... // an error accrue, goto roll_back or leave.
    ->ocfs2_commit_trans()
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                ->ocfs2_refresh_inode()
                  ->set_nlink();    // inode->i_nlink is 2 now.
            /* if wipe is 0, it will goto bail_unlock_inode */
            ->ocfs2_query_inode_wipe()
              ->if (inode->i_nlink) return; // wipe is 0.
            /* inode can not be wiped */
            ->ocfs2_wipe_inode()
So, we need clear links before the transaction committed.

Link: http://lkml.kernel.org/r/d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs
+++ a/fs/ocfs2/namei.c
@@ -454,8 +454,12 @@ roll_back:
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -599,6 +603,8 @@ static int __ocfs2_mknod_locked(struct i
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
+			if (fe)
+				ocfs2_set_links_count(fe, 0);
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
@@ -2028,8 +2034,12 @@ bail:
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && new_fe_bh != NULL)
+			ocfs2_set_links_count((struct ocfs2_dinode *)
+					new_fe_bh->b_data, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
_

Patches currently in -mm which might be from wangyan122@huawei.com are

ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch

