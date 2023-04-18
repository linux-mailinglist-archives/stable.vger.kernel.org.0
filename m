Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB0C6E61B3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjDRM0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDRM0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:26:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13674AD37
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C909263109
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75FFC433EF;
        Tue, 18 Apr 2023 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820765;
        bh=pF4V/uSzBEDqsjjMXJICL3TlgrroEcdCv9l8XZ54jHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkIL5Nrj/Xc8dmgEcezfLfpp/pOFcgQJHbg2tGGUqiSmTVodBxZyjVbj+mCdl16k9
         z0i4i7LSOxFRQpg/RkSt2TiE0ZMYZIff9a0vPh55edm+/+Irw3AaGyLpu4Wiig5chM
         OisYlliSQcJuaupqHcp0fIxvN2HtwgtLAW1ag6mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/57] NFSv4: Convert struct nfs4_state to use refcount_t
Date:   Tue, 18 Apr 2023 14:21:05 +0200
Message-Id: <20230418120258.913083090@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ace9fad43aa60a88af4b57a8328f0958e3d07bf0 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 6165a16a5ad9 ("NFSv4: Fix hangs when recovering open state after a server reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h   | 2 +-
 fs/nfs/nfs4proc.c  | 8 ++++----
 fs/nfs/nfs4state.c | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 5ac7bf24c507b..2d438318681a5 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -190,7 +190,7 @@ struct nfs4_state {
 	unsigned int n_wronly;		/* Number of write-only references */
 	unsigned int n_rdwr;		/* Number of read/write references */
 	fmode_t state;			/* State on the server (R,W, or RW) */
-	atomic_t count;
+	refcount_t count;
 
 	wait_queue_head_t waitq;
 };
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 250fa88303fad..4f8775d9d0f06 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1792,7 +1792,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 out:
 	return ERR_PTR(ret);
 out_return_state:
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 	return state;
 }
 
@@ -1864,7 +1864,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 update:
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 
 	return state;
 }
@@ -1902,7 +1902,7 @@ nfs4_opendata_find_nfs4_state(struct nfs4_opendata *data)
 		return ERR_CAST(inode);
 	if (data->state != NULL && data->state->inode == inode) {
 		state = data->state;
-		atomic_inc(&state->count);
+		refcount_inc(&state->count);
 	} else
 		state = nfs4_get_open_state(inode, data->owner);
 	iput(inode);
@@ -1975,7 +1975,7 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 	if (opendata == NULL)
 		return ERR_PTR(-ENOMEM);
 	opendata->state = state;
-	atomic_inc(&state->count);
+	refcount_inc(&state->count);
 	return opendata;
 }
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b9fbd01ef4cfe..e5b4c6987c846 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -675,7 +675,7 @@ nfs4_alloc_open_state(void)
 	state = kzalloc(sizeof(*state), GFP_NOFS);
 	if (!state)
 		return NULL;
-	atomic_set(&state->count, 1);
+	refcount_set(&state->count, 1);
 	INIT_LIST_HEAD(&state->lock_states);
 	spin_lock_init(&state->state_lock);
 	seqlock_init(&state->seqlock);
@@ -709,7 +709,7 @@ __nfs4_find_state_byowner(struct inode *inode, struct nfs4_state_owner *owner)
 			continue;
 		if (!nfs4_valid_open_stateid(state))
 			continue;
-		if (atomic_inc_not_zero(&state->count))
+		if (refcount_inc_not_zero(&state->count))
 			return state;
 	}
 	return NULL;
@@ -763,7 +763,7 @@ void nfs4_put_open_state(struct nfs4_state *state)
 	struct inode *inode = state->inode;
 	struct nfs4_state_owner *owner = state->owner;
 
-	if (!atomic_dec_and_lock(&state->count, &owner->so_lock))
+	if (!refcount_dec_and_lock(&state->count, &owner->so_lock))
 		return;
 	spin_lock(&inode->i_lock);
 	list_del(&state->inode_states);
@@ -1596,7 +1596,7 @@ static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs
 			continue;
 		if (state->state == 0)
 			continue;
-		atomic_inc(&state->count);
+		refcount_inc(&state->count);
 		spin_unlock(&sp->so_lock);
 		status = ops->recover_open(sp, state);
 		if (status >= 0) {
-- 
2.39.2



