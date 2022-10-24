Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA1060AFB6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiJXP4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiJXPz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353C0106A6D;
        Mon, 24 Oct 2022 07:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26C1B81A03;
        Mon, 24 Oct 2022 12:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12822C4347C;
        Mon, 24 Oct 2022 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615869;
        bh=eEkKhel/dkvqZLvCArQ7RAj4NcXEexhoiqLhszBxwz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+OHLhHHJj4sVDp95v6VJrNq+a71aY+wz8JzFU2l8AJV2prep2C9sLH7HMi9gGbRf
         26Rm+d3/qzXDxQ0rQnAZsvsNXbgfpvqvfftEcY77vhsAo/iEoC666Pzvjr004Jut5v
         iNmK9hiVCoIKpwBRGtDi6Ugvy+g70ObP01uovUQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/530] NFSD: fix use-after-free on source server when doing inter-server copy
Date:   Mon, 24 Oct 2022 13:32:38 +0200
Message-Id: <20221024113103.839919876@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
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



