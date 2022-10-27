Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1760FE5B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiJ0REi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiJ0REg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B9634728
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88382610AB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B6EC433C1;
        Thu, 27 Oct 2022 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890275;
        bh=oKj/oXU0MoN0t/0g4U5W9dGK3RaEh2aNrJWANmkqIHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDacHqMfyLJF6gUWYJN6utSF7SHSErspZRkHIqqpZ+IUSXSdj3Df6Rd58PGHEWfK6
         Pse2lz/uUeooMInwqgu8CNHuE2HfZwE0/7SYTq21ZQ6fi1sUFhmKjLpxzw+yAFPDA/
         I9Od8bct8O9Q4TlFZ33idxeXpAxBGSZc35ivciFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Yan Wang <wangyan122@huawei.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 01/79] ocfs2: clear dinode links count in case of error
Date:   Thu, 27 Oct 2022 18:55:11 +0200
Message-Id: <20221027165054.338524140@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 28f4821b1b53e0649706912e810c6c232fc506f9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -231,6 +231,7 @@ static int ocfs2_mknod(struct inode *dir
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -381,6 +382,7 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -453,8 +455,11 @@ roll_back:
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
@@ -2023,8 +2028,11 @@ bail:
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


