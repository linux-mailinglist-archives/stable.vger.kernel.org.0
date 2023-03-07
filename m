Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FA46AEF7E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjCGSXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbjCGSXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE8994A55
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAD8B614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D8C433D2;
        Tue,  7 Mar 2023 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213125;
        bh=TL+JNL8xsk+N6ySbtKAOX/IKeylXUbUSe3qTe11K6ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok4/jFGCRgImTaopxNqQ0LbHSybbwE8czn0UCo+aUeh3oS5+CeBWolniEWcbnbE1f
         IYJoOhQjlJeGTqlUPT5z621WjD/4PzgdgQEmH81r/bopzb0qc4QOlemR36Nz3ISqnX
         FcxP84MJI54w1b2o7f3GkQUycbdBHExS8IiZhWYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dai Ngo <dai.ngo@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/885] NFSD: fix problems with cleanup on errors in nfsd4_copy
Date:   Tue,  7 Mar 2023 17:55:11 +0100
Message-Id: <20230307170018.703804232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 81e722978ad21072470b73d8f6a50ad62c7d5b7d ]

When nfsd4_copy fails to allocate memory for async_copy->cp_src, or
nfs4_init_copy_state fails, it calls cleanup_async_copy to do the
cleanup for the async_copy which causes page fault since async_copy
is not yet initialized.

This patche rearranges the order of initializing the fields in
async_copy and adds checks in cleanup_async_copy to skip un-initialized
fields.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Fixes: 87689df69491 ("NFSD: Shrink size of struct nfsd4_copy")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  | 12 ++++++++----
 fs/nfsd/nfs4state.c |  5 +++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 043cef25d3dbd..53113976e6424 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1698,9 +1698,12 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 {
 	nfs4_free_copy_state(copy);
 	release_copy_files(copy);
-	spin_lock(&copy->cp_clp->async_lock);
-	list_del(&copy->copies);
-	spin_unlock(&copy->cp_clp->async_lock);
+	if (copy->cp_clp) {
+		spin_lock(&copy->cp_clp->async_lock);
+		if (!list_empty(&copy->copies))
+			list_del_init(&copy->copies);
+		spin_unlock(&copy->cp_clp->async_lock);
+	}
 	nfs4_put_copy(copy);
 }
 
@@ -1797,12 +1800,13 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
 			goto out_err;
+		INIT_LIST_HEAD(&async_copy->copies);
+		refcount_set(&async_copy->refcount, 1);
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
-		refcount_set(&async_copy->refcount, 1);
 		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(copy->cp_res.cb_stateid));
 		dup_copy_fields(copy, async_copy);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2247d107da90b..7c1b1247dc407 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -991,7 +991,6 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 
 	stid->cs_stid.si_opaque.so_clid.cl_boot = (u32)nn->boot_time;
 	stid->cs_stid.si_opaque.so_clid.cl_id = nn->s2s_cp_cl_id;
-	stid->cs_type = cs_type;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->s2s_cp_lock);
@@ -1002,6 +1001,7 @@ static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
 	idr_preload_end();
 	if (new_id < 0)
 		return 0;
+	stid->cs_type = cs_type;
 	return 1;
 }
 
@@ -1035,7 +1035,8 @@ void nfs4_free_copy_state(struct nfsd4_copy *copy)
 {
 	struct nfsd_net *nn;
 
-	WARN_ON_ONCE(copy->cp_stateid.cs_type != NFS4_COPY_STID);
+	if (copy->cp_stateid.cs_type != NFS4_COPY_STID)
+		return;
 	nn = net_generic(copy->cp_clp->net, nfsd_net_id);
 	spin_lock(&nn->s2s_cp_lock);
 	idr_remove(&nn->s2s_cp_stateids,
-- 
2.39.2



