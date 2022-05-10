Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083E3521832
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiEJNdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243906AbiEJNcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2B5185CB2;
        Tue, 10 May 2022 06:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7F56170D;
        Tue, 10 May 2022 13:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D18C385A6;
        Tue, 10 May 2022 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189014;
        bh=CUTSx5JHhvxG1hKiMMw+aI6eeyYNQfNKn7NxFpMc3VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7HVWPptZlq+pZjm8TWq7HGgJ3bcLDcvpaGGKHHrPKutSPGNwM2X0i+1B41Qhey6f
         V6Q5+wIDcEg2mGRFYHNUz+IdqByxT+At4r0Hdtm0K+SRRiJSI6MaeeY3WQpyh9/oxW
         BW2HLz1zSHIGGqfB4au0nfqkdzCvh5MnSAClEJjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/52] NFSv4: Dont invalidate inode attributes on delegation return
Date:   Tue, 10 May 2022 15:08:04 +0200
Message-Id: <20220510130730.880284603@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 00c94ebec5925593c0377b941289224469e72ac7 ]

There is no need to declare attributes such as the ctime, mtime and
block size invalid when we're just returning a delegation, so it is
inappropriate to call nfs_post_op_update_inode_force_wcc().
Instead, just call nfs_refresh_inode() after faking up the change
attribute. We know that the GETATTR op occurs before the DELEGRETURN, so
we are safe when doing this.

Fixes: 0bc2c9b4dca9 ("NFSv4: Don't discard the attributes returned by asynchronous DELEGRETURN")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 76baf7b441f3..cf3b00751ff6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -359,6 +359,14 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
 	kunmap_atomic(start);
 }
 
+static void nfs4_fattr_set_prechange(struct nfs_fattr *fattr, u64 version)
+{
+	if (!(fattr->valid & NFS_ATTR_FATTR_PRECHANGE)) {
+		fattr->pre_change_attr = version;
+		fattr->valid |= NFS_ATTR_FATTR_PRECHANGE;
+	}
+}
+
 static void nfs4_test_and_free_stateid(struct nfs_server *server,
 		nfs4_stateid *stateid,
 		const struct cred *cred)
@@ -6307,7 +6315,9 @@ static void nfs4_delegreturn_release(void *calldata)
 		pnfs_roc_release(&data->lr.arg, &data->lr.res,
 				 data->res.lr_ret);
 	if (inode) {
-		nfs_post_op_update_inode_force_wcc(inode, &data->fattr);
+		nfs4_fattr_set_prechange(&data->fattr,
+					 inode_peek_iversion_raw(inode));
+		nfs_refresh_inode(inode, &data->fattr);
 		nfs_iput_and_deactive(inode);
 	}
 	kfree(calldata);
-- 
2.35.1



