Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D89D3CE36A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244007AbhGSPhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347894AbhGSPfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD1B96135C;
        Mon, 19 Jul 2021 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711180;
        bh=CncNaedxXnOwbQJ0q50kQWZlFBc8IKmSql04qBmdFMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxmIVcZJNi8q8NWm2V21aLO0MwkT7sK7hw86dGVow0BbrNqDmHNB08v1WfBzyeMWU
         Qlz+Gg9EBcfmuelbcaXoAIFVlXosmSkuDmeM5ZlGfJzX+fQWi5k3Op03CTcph2L9Ne
         NyURrkall1XJRhPgJSZwHQyREWLzfeJRWwxaoIu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 257/351] nfsd: move fsnotify on client creation outside spinlock
Date:   Mon, 19 Jul 2021 16:53:23 +0200
Message-Id: <20210719144953.452061668@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 934bd07fae7e55232845f909f78873ab8678ca74 ]

This was causing a "sleeping function called from invalid context"
warning.

I don't think we need the set_and_test_bit() here; clients move from
unconfirmed to confirmed only once, under the client_lock.

The (conf == unconf) is a way to check whether we're in that confirming
case, hopefully that's not too obscure.

Fixes: 472d155a0631 "nfsd: report client confirmation status in "info" file"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 67ebb040bc5f..90e81f6491ff 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2819,11 +2819,8 @@ move_to_confirmed(struct nfs4_client *clp)
 	list_move(&clp->cl_idhash, &nn->conf_id_hashtbl[idhashval]);
 	rb_erase(&clp->cl_namenode, &nn->unconf_name_tree);
 	add_clp_to_name_tree(clp, &nn->conf_name_tree);
-	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags)) {
-		trace_nfsd_clid_confirmed(&clp->cl_clientid);
-		if (clp->cl_nfsd_dentry && clp->cl_nfsd_info_dentry)
-			fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
-	}
+	set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags);
+	trace_nfsd_clid_confirmed(&clp->cl_clientid);
 	renew_client_locked(clp);
 }
 
@@ -3471,6 +3468,8 @@ nfsd4_create_session(struct svc_rqst *rqstp,
 	/* cache solo and embedded create sessions under the client_lock */
 	nfsd4_cache_create_session(cr_ses, cs_slot, status);
 	spin_unlock(&nn->client_lock);
+	if (conf == unconf)
+		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);
 	/* init connection and backchannel */
 	nfsd4_init_conn(rqstp, conn, new);
 	nfsd4_put_session(new);
@@ -4071,6 +4070,8 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 	}
 	get_client_locked(conf);
 	spin_unlock(&nn->client_lock);
+	if (conf == unconf)
+		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);
 	nfsd4_probe_callback(conf);
 	spin_lock(&nn->client_lock);
 	put_client_renew_locked(conf);
-- 
2.30.2



