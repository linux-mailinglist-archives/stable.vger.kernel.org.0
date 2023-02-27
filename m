Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47D66A37E2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjB0CMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjB0CMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:12:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B45F1C7F6;
        Sun, 26 Feb 2023 18:10:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D464860DB7;
        Mon, 27 Feb 2023 02:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A931C433EF;
        Mon, 27 Feb 2023 02:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463725;
        bh=zmHrb0/X9/YUHikh9eM+PpNBZJ25oqXzRodIxZg1phw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1qFlD/v8p/IPlMdM1kKmSxYW666TvIf3TY2NNlKsqOI03lv/swSeM3TBZTQVe9/g
         Kth5/gjPVsojQQAn7NVAdr1prRJuJUHuHmRgXQ71QW+c8an9WCCkAVwbh1ITA2zdwN
         edTp90rUXB/D/VOOlcchBQbL9kwbzRLFpZ5s2q3TPQ3vNICw3t3dqhIHRVPU1yXOCn
         GKo91OXv1FN842WjiRI5k7MlYkpnq+HyuXT8x+fJZ7h9Q2Am6WzeJTms62Yzg05Xno
         Iqybnt0I9rsN8Xl9DWsaAR3AjWX+t8wGdZv6ojAwtIiCzbM/ZRA2fKjhXaTyI90tcm
         vCxa3AiiGT5zA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 56/58] nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
Date:   Sun, 26 Feb 2023 21:04:54 -0500
Message-Id: <20230227020457.1048737-56-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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
index 13603cb017346..9cc498916aa22 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1530,7 +1530,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 	struct nfsd_net *nn = net_generic(dst->nf_net, nfsd_net_id);
 
 	nfs42_ssc_close(filp);
-	nfsd_file_put(dst);
 	fput(filp);
 
 	if (!nn) {
@@ -1597,13 +1596,6 @@ nfsd4_setup_intra_ssc(struct svc_rqst *rqstp,
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
@@ -1718,12 +1710,18 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
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
@@ -1783,7 +1781,6 @@ static int nfsd4_do_async_copy(void *data)
 	} else {
 		nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, false);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
 do_callback:
@@ -1847,9 +1844,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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

