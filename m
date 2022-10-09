Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87F5F8E78
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiJIU61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiJIU5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7F03204F;
        Sun,  9 Oct 2022 13:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E8E560C79;
        Sun,  9 Oct 2022 20:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F19C433B5;
        Sun,  9 Oct 2022 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348828;
        bh=eEkKhel/dkvqZLvCArQ7RAj4NcXEexhoiqLhszBxwz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEgA51Y7dKfBzesThHoXmPoCWVtrr41xFA+2qpfEjFVeQ3OXcHBKn0IeNClmYiPC8
         6pUXdnwHsjz9wYQvbv9ueMUBr2mFzY1I0Xyo+ggTwpyM/F504sO6GOf4rBuSVifc7a
         UVwnB8c/iIOsRzY6IKihP3CyYheZ+/3yD/u5KbrlBbVsjDg9xG/z2DKH4PdUNAqp5N
         4bYdPziNV5u0s5YZOifcZ5xzFYsZdeL4ujZ4V6Ro/WFRjyoyrkyP+wigw5mKNCie9B
         2neIxjl3PQnGn1ZfZPAcZuMA8WVegYmLSi9Osh42Ptwhaii7MVyox2LwIVw2BzkgyI
         gbBhv3wrsTkjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dai Ngo <dai.ngo@oracle.com>, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/15] NFSD: fix use-after-free on source server when doing inter-server copy
Date:   Sun,  9 Oct 2022 16:53:08 -0400
Message-Id: <20221009205308.1202627-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205308.1202627-1-sashal@kernel.org>
References: <20221009205308.1202627-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 019805fea91599b22dfa62ffb29c022f35abeb06 ]

Use-after-free occurred when the laundromat tried to free expired
cpntf_state entry on the s2s_cp_stateids list after inter-server
copy completed. The sc_cp_list that the expired copy state was
inserted on was already freed.

When COPY completes, the Linux client normally sends LOCKU(lock_state x),
FREE_STATEID(lock_state x) and CLOSE(open_state y) to the source server.
The nfs4_put_stid call from nfsd4_free_stateid cleans up the copy state
from the s2s_cp_stateids list before freeing the lock state's stid.

However, sometimes the CLOSE was sent before the FREE_STATEID request.
When this happens, the nfsd4_close_open_stateid call from nfsd4_close
frees all lock states on its st_locks list without cleaning up the copy
state on the sc_cp_list list. When the time the FREE_STATEID arrives the
server returns BAD_STATEID since the lock state was freed. This causes
the use-after-free error to occur when the laundromat tries to free
the expired cpntf_state.

This patch adds a call to nfs4_free_cpntf_statelist in
nfsd4_close_open_stateid to clean up the copy state before calling
free_ol_stateid_reaplist to free the lock state's stid on the reaplist.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f9e2fa9cfbec..7b763f146b62 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -961,6 +961,7 @@ static struct nfs4_ol_stateid * nfs4_alloc_open_stateid(struct nfs4_client *clp)
 
 static void nfs4_free_deleg(struct nfs4_stid *stid)
 {
+	WARN_ON(!list_empty(&stid->sc_cp_list));
 	kmem_cache_free(deleg_slab, stid);
 	atomic_long_dec(&num_delegations);
 }
@@ -1374,6 +1375,7 @@ static void nfs4_free_ol_stateid(struct nfs4_stid *stid)
 	release_all_access(stp);
 	if (stp->st_stateowner)
 		nfs4_put_stateowner(stp->st_stateowner);
+	WARN_ON(!list_empty(&stid->sc_cp_list));
 	kmem_cache_free(stateid_slab, stid);
 }
 
@@ -6389,6 +6391,7 @@ static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 	struct nfs4_client *clp = s->st_stid.sc_client;
 	bool unhashed;
 	LIST_HEAD(reaplist);
+	struct nfs4_ol_stateid *stp;
 
 	spin_lock(&clp->cl_lock);
 	unhashed = unhash_open_stateid(s, &reaplist);
@@ -6397,6 +6400,8 @@ static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 		if (unhashed)
 			put_ol_stateid_locked(s, &reaplist);
 		spin_unlock(&clp->cl_lock);
+		list_for_each_entry(stp, &reaplist, st_locks)
+			nfs4_free_cpntf_statelist(clp->net, &stp->st_stid);
 		free_ol_stateid_reaplist(&reaplist);
 	} else {
 		spin_unlock(&clp->cl_lock);
-- 
2.35.1

