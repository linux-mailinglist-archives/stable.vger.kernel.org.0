Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C039E6AEF7D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjCGSXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjCGSXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6E683151
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0ECC614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9C6C433D2;
        Tue,  7 Mar 2023 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213122;
        bh=NWQx7M4PyVwY3RDumDwGbmubuc4FCNF3J7izREiR+nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3ANnx/KWUQ3bZ9BGe4n2u7Hka8b03ijOghTmHhlos5FUXW5/+5LWSlMH+iDxPMaD
         dFFDXS3evIzN467LdMYFxB3Q7NWdYHDcDjDI0NRJK1dijtWriyUx+/vWzImqzrB15E
         pN7lo3enJZPRJV+aQVSZS+4brIKoldkudftBFITs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 376/885] nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
Date:   Tue,  7 Mar 2023 17:55:10 +0100
Message-Id: <20230307170018.664603447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Stable-dep-of: 81e722978ad2 ("NFSD: fix problems with cleanup on errors in nfsd4_copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 32652b5e6eff3..043cef25d3dbd 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1523,7 +1523,6 @@ nfsd4_cleanup_inter_ssc(struct nfsd4_ssc_umount_item *nsui, struct file *filp,
 	long timeout = msecs_to_jiffies(nfsd4_ssc_umount_timeout);
 
 	nfs42_ssc_close(filp);
-	nfsd_file_put(dst);
 	fput(filp);
 
 	spin_lock(&nn->nfsd_ssc_lock);
@@ -1573,13 +1572,6 @@ nfsd4_setup_intra_ssc(struct svc_rqst *rqstp,
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
@@ -1694,12 +1686,18 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 	dst->ss_nsui = src->ss_nsui;
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
@@ -1759,7 +1757,6 @@ static int nfsd4_do_async_copy(void *data)
 	} else {
 		nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, false);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
 do_callback:
@@ -1822,9 +1819,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	} else {
 		status = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, true);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
+	release_copy_files(copy);
 	return status;
 out_err:
 	if (nfsd4_ssc_is_inter(copy)) {
-- 
2.39.2



