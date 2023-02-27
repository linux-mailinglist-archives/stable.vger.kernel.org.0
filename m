Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6296A371F
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjB0CHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjB0CGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F2A1B2DC;
        Sun, 26 Feb 2023 18:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55F4FB80CBA;
        Mon, 27 Feb 2023 02:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF25C4339C;
        Mon, 27 Feb 2023 02:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463493;
        bh=QT/obBQ6iSKOozbjpTe4syeI1Ml5nRKZzzd/T9mCMXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxUhiyNVFVrQwlh2hA7IRNY3ey1W6IwXp4e992CYU18KDw6FBHs8uprnLA0llMLX1
         MATUKEXQHJXujEeqeSiRLV+NbjQ1XnbKAkjWKer5mSHd3pWhOcRXglO7DqKVEbNtaS
         5qlQC8szJRsW95qFh6NHib9hHTROzFrLO1i+EraqJFuzcVqVifm4TVOIF1OEs7J//l
         fMNxPmrDIOdd4Z247mDbnoT9pO78ZezdzQT9Vy9NNju5qGBxNNIolvOjO8XH8sSX2r
         wEuFVqxc4bMXX1G7dAyFSmlpFWPQsmcUU8OvJb+6Z7ULeHhxRAVpth7fAzHqi2uysi
         Pa/jHkMgkrVQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 58/60] nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
Date:   Sun, 26 Feb 2023 21:00:43 -0500
Message-Id: <20230227020045.1045105-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6ba434cb1a8d403ea9aad1b667c3ea3ad8b3191f ]

There are two different flavors of the nfsd4_copy struct. One is
embedded in the compound and is used directly in synchronous copies. The
other is dynamically allocated, refcounted and tracked in the client
struture. For the embedded one, the cleanup just involves releasing any
nfsd_files held on its behalf. For the async one, the cleanup is a bit
more involved, and we need to dequeue it from lists, unhash it, etc.

There is at least one potential refcount leak in this code now. If the
kthread_create call fails, then both the src and dst nfsd_files in the
original nfsd4_copy object are leaked.

The cleanup in this codepath is also sort of weird. In the async copy
case, we'll have up to four nfsd_file references (src and dst for both
flavors of copy structure). They are both put at the end of
nfsd4_do_async_copy, even though the ones held on behalf of the embedded
one outlive that structure.

Change it so that we always clean up the nfsd_file refs held by the
embedded copy structure before nfsd4_copy returns. Rework
cleanup_async_copy to handle both inter and intra copies. Eliminate
nfsd4_cleanup_intra_ssc since it now becomes a no-op.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 451403758ea17..0a01e7fb2cf85 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1517,7 +1517,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 	struct nfsd_net *nn = net_generic(dst->nf_net, nfsd_net_id);
 
 	nfs42_ssc_close(filp);
-	nfsd_file_put(dst);
 	fput(filp);
 
 	if (!nn) {
@@ -1584,13 +1583,6 @@ nfsd4_setup_intra_ssc(struct svc_rqst *rqstp,
 				 &copy->nf_dst);
 }
 
-static void
-nfsd4_cleanup_intra_ssc(struct nfsd_file *src, struct nfsd_file *dst)
-{
-	nfsd_file_put(src);
-	nfsd_file_put(dst);
-}
-
 static void nfsd4_cb_offload_release(struct nfsd4_callback *cb)
 {
 	struct nfsd4_cb_offload *cbo =
@@ -1705,12 +1697,18 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 	dst->ss_mnt = src->ss_mnt;
 }
 
+static void release_copy_files(struct nfsd4_copy *copy)
+{
+	if (copy->nf_src)
+		nfsd_file_put(copy->nf_src);
+	if (copy->nf_dst)
+		nfsd_file_put(copy->nf_dst);
+}
+
 static void cleanup_async_copy(struct nfsd4_copy *copy)
 {
 	nfs4_free_copy_state(copy);
-	nfsd_file_put(copy->nf_dst);
-	if (!nfsd4_ssc_is_inter(copy))
-		nfsd_file_put(copy->nf_src);
+	release_copy_files(copy);
 	spin_lock(&copy->cp_clp->async_lock);
 	list_del(&copy->copies);
 	spin_unlock(&copy->cp_clp->async_lock);
@@ -1770,7 +1768,6 @@ static int nfsd4_do_async_copy(void *data)
 	} else {
 		nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, false);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
 do_callback:
@@ -1834,9 +1831,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	} else {
 		status = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, true);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
+	release_copy_files(copy);
 	return status;
 out_err:
 	if (async_copy)
-- 
2.39.0

