Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C32F6214F0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiKHOGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiKHOGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B84686BF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F410AB81ADD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F18C433C1;
        Tue,  8 Nov 2022 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916404;
        bh=EQuXMTHcWueZgn6GduxG7yvcDBp/iLDhrnmM9Be4InU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGa37FVXwqEVVdubhGlBKLqB2boJ9FO378hUmghdCrDWeJcEueSOZbJVm3P9ZfgPs
         PORzP/K+Zarf7PfUkUDSsTeXHFMyPSErri1tu8wsXoj58LEv9P/yj2V0NbulecZf/o
         omNWslZx5nAAkJgUdopBz4fl3u5r7UbLUHYKnMMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 010/197] NFSv4: Fix a potential state reclaim deadlock
Date:   Tue,  8 Nov 2022 14:37:28 +0100
Message-Id: <20221108133355.248780533@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1ba04394e028ea8b45d92685cc0d6ab582cf7647 ]

If the server reboots while we are engaged in a delegation return, and
there is a pNFS layout with return-on-close set, then the current code
can end up deadlocking in pnfs_roc() when nfs_inode_set_delegation()
tries to return the old delegation.
Now that delegreturn actually uses its own copy of the stateid, it
should be safe to just always update the delegation stateid in place.

Fixes: 078000d02d57 ("pNFS: We want return-on-close to complete when evicting the inode")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 5c97cad741a7..ead8a0e06abf 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -228,8 +228,7 @@ static int nfs_delegation_claim_opens(struct inode *inode,
  *
  */
 void nfs_inode_reclaim_delegation(struct inode *inode, const struct cred *cred,
-				  fmode_t type,
-				  const nfs4_stateid *stateid,
+				  fmode_t type, const nfs4_stateid *stateid,
 				  unsigned long pagemod_limit)
 {
 	struct nfs_delegation *delegation;
@@ -239,25 +238,24 @@ void nfs_inode_reclaim_delegation(struct inode *inode, const struct cred *cred,
 	delegation = rcu_dereference(NFS_I(inode)->delegation);
 	if (delegation != NULL) {
 		spin_lock(&delegation->lock);
-		if (nfs4_is_valid_delegation(delegation, 0)) {
-			nfs4_stateid_copy(&delegation->stateid, stateid);
-			delegation->type = type;
-			delegation->pagemod_limit = pagemod_limit;
-			oldcred = delegation->cred;
-			delegation->cred = get_cred(cred);
-			clear_bit(NFS_DELEGATION_NEED_RECLAIM,
-				  &delegation->flags);
-			spin_unlock(&delegation->lock);
-			rcu_read_unlock();
-			put_cred(oldcred);
-			trace_nfs4_reclaim_delegation(inode, type);
-			return;
-		}
-		/* We appear to have raced with a delegation return. */
+		nfs4_stateid_copy(&delegation->stateid, stateid);
+		delegation->type = type;
+		delegation->pagemod_limit = pagemod_limit;
+		oldcred = delegation->cred;
+		delegation->cred = get_cred(cred);
+		clear_bit(NFS_DELEGATION_NEED_RECLAIM, &delegation->flags);
+		if (test_and_clear_bit(NFS_DELEGATION_REVOKED,
+				       &delegation->flags))
+			atomic_long_inc(&nfs_active_delegations);
 		spin_unlock(&delegation->lock);
+		rcu_read_unlock();
+		put_cred(oldcred);
+		trace_nfs4_reclaim_delegation(inode, type);
+	} else {
+		rcu_read_unlock();
+		nfs_inode_set_delegation(inode, cred, type, stateid,
+					 pagemod_limit);
 	}
-	rcu_read_unlock();
-	nfs_inode_set_delegation(inode, cred, type, stateid, pagemod_limit);
 }
 
 static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *delegation, int issync)
-- 
2.35.1



