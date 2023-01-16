Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5824E66C4D6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjAPP6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjAPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC813A5F5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75425B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BA5C433D2;
        Mon, 16 Jan 2023 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884720;
        bh=kutnvLjlyoyL9F+iEZ7deFk7ovuwvvlLlKBcwzRcvRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw8QkhhCFxHPR6FFrnJB541h2zR22KQvmsDsX8D7BvH5oKuaFZ8bSaWRIWmI8xDOP
         mEDZ6U7kod9b6PepcMln3Xeak6n8v5O1zj9ytEJLbjugEkY5U0R3sohcGPbT42quP4
         9k6+Ot65KzP2ShZJZehJnMpDSufGXxZv1/BptXkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, NeilBrown <neilb@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/183] NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"
Date:   Mon, 16 Jan 2023 16:50:37 +0100
Message-Id: <20230116154808.207728963@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dcf3f80965ca787c70def402cdf1553c93c75529 ]

This reverts commit 5e138c4a750dc140d881dab4a8804b094bbc08d2.

That commit attempted to make files available to other users as soon
as all NFSv4 clients were done with them, rather than waiting until
the filecache LRU had garbage collected them.

It gets the reference counting wrong, for one thing.

But it also misses that DELEGRETURN should release a file in the
same fashion. In fact, any nfsd_file_put() on an file held open
by an NFSv4 client needs potentially to release the file
immediately...

Clear the way for implementing that idea.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Stable-dep-of: 0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 18 ------------------
 fs/nfsd/filecache.h |  1 -
 fs/nfsd/nfs4state.c |  4 ++--
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ec3fceb92236..babea79d3f6f 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -444,24 +444,6 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_put_noref(nf);
 }
 
-/**
- * nfsd_file_close - Close an nfsd_file
- * @nf: nfsd_file to close
- *
- * If this is the final reference for @nf, free it immediately.
- * This reflects an on-the-wire CLOSE or DELEGRETURN into the
- * VFS and exported filesystem.
- */
-void nfsd_file_close(struct nfsd_file *nf)
-{
-	nfsd_file_put(nf);
-	if (refcount_dec_if_one(&nf->nf_ref)) {
-		nfsd_file_unhash(nf);
-		nfsd_file_lru_remove(nf);
-		nfsd_file_free(nf);
-	}
-}
-
 struct nfsd_file *
 nfsd_file_get(struct nfsd_file *nf)
 {
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 357832bac736..6b012ea4bd9d 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -52,7 +52,6 @@ void nfsd_file_cache_shutdown(void);
 int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
-void nfsd_file_close(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 52b5552d0d70..16c3e991ddcc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -842,9 +842,9 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 			swap(f2, fp->fi_fds[O_RDWR]);
 		spin_unlock(&fp->fi_lock);
 		if (f1)
-			nfsd_file_close(f1);
+			nfsd_file_put(f1);
 		if (f2)
-			nfsd_file_close(f2);
+			nfsd_file_put(f2);
 	}
 }
 
-- 
2.35.1



