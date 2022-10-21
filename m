Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD3606EF2
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 06:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJUEfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 00:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJUEew (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 00:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513F234DDA;
        Thu, 20 Oct 2022 21:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55961B82A38;
        Fri, 21 Oct 2022 04:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA33EC43470;
        Fri, 21 Oct 2022 04:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326887;
        bh=p+HP2bSq7DAV5HIKBpIzq3vG/0va0j04Tlf0mBRSEVo=;
        h=Date:To:From:Subject:From;
        b=wli4wqwkGmbZf6h46ei21EQk89wc6nAFgst3apEnnfq4QpF8SF6xGif4QnkzhbJaF
         3S/t8JlgyJbp7Aov67l973vQgl7KaVDWrG1ZTrFYk00/WGQl8OS2Fp5C4nnhBMPnP8
         bk/mR6rn6morGZUi4x48lrgkCcOSS1e3rsYDZ718=
Date:   Thu, 20 Oct 2022 21:34:46 -0700
To:     mm-commits@vger.kernel.org, wangyan122@huawei.com,
        stable@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-clear-dinode-links-count-in-case-of-error.patch removed from -mm tree
Message-Id: <20221021043446.EA33EC43470@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: clear dinode links count in case of error
has been removed from the -mm tree.  Its filename was
     ocfs2-clear-dinode-links-count-in-case-of-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ocfs2-cluster-use-bitmap-api-instead-of-hand-writing-it.patch
ocfs2-use-bitmap-api-in-fill_node_map.patch
ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it.patch

