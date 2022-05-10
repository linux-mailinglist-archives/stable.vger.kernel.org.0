Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4D5218BD
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbiEJNjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244927AbiEJNiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20B1737B1;
        Tue, 10 May 2022 06:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D4F6170D;
        Tue, 10 May 2022 13:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA80C385CB;
        Tue, 10 May 2022 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189199;
        bh=D8r2jFoTEUVlsyCv66uIxzQz4KMltHDjNuYGVD5H6EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gld/VLoWvEY26mu/aoeFOsiyl4oTLHHRN4/zwHm1H6N2dTP93fCMavxUq6s0fcKPy
         vw2NXWkUv+x2TuO+oqr10es0AY5cc9owj4mjjy58nwJuIBBllZ4dBt/Qq1Y3sovNi8
         H94O1C+4qWaoqGJ7QUC0DNbUlXIfnSfIteHMgBCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 44/70] NFSv4: Dont invalidate inode attributes on delegation return
Date:   Tue, 10 May 2022 15:08:03 +0200
Message-Id: <20220510130734.150568877@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
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

commit 00c94ebec5925593c0377b941289224469e72ac7 upstream.

There is no need to declare attributes such as the ctime, mtime and
block size invalid when we're just returning a delegation, so it is
inappropriate to call nfs_post_op_update_inode_force_wcc().
Instead, just call nfs_refresh_inode() after faking up the change
attribute. We know that the GETATTR op occurs before the DELEGRETURN, so
we are safe when doing this.

Fixes: 0bc2c9b4dca9 ("NFSv4: Don't discard the attributes returned by asynchronous DELEGRETURN")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -369,6 +369,14 @@ static void nfs4_setup_readdir(u64 cooki
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
@@ -6464,7 +6472,9 @@ static void nfs4_delegreturn_release(voi
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


