Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1123CE3E9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhGSPlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347725AbhGSPfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4391761353;
        Mon, 19 Jul 2021 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711177;
        bh=WctIa/8B3e9BZTsk+uucXRWcDWIT/L8DyEGyoP3T73c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paye4EqzNvRSe7lQAmNlRrxmoN9kopmkxLoN8kQryeXDDDRVralLsYJ3LXUukTWfx
         jshtuDDjxIgzVlmCPtnaaB64EqB6BBYv0K+BgcIpJC5H5wceVAm+9tsawCqeC486XY
         rHs82P1L0ItiFFWG1bq1i9PsH+4QbJ3FfMvKN79g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 256/351] NFSD: Add nfsd_clid_confirmed tracepoint
Date:   Mon, 19 Jul 2021 16:53:22 +0200
Message-Id: <20210719144953.420379082@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7e3b32ace6094aadfa2e1e54ca4c6bbfd07646af ]

This replaces a dprintk call site in order to get greater visibility
on when client IDs are confirmed or re-used. Simple example:

            nfsd-995   [000]   126.622975: nfsd_compound:        xid=0x3a34e2b1 opcnt=1
            nfsd-995   [000]   126.623005: nfsd_cb_args:         addr=192.168.2.51:45901 client 60958e3b:9213ef0e prog=1073741824 ident=1
            nfsd-995   [000]   126.623007: nfsd_compound_status: op=1/1 OP_SETCLIENTID status=0
            nfsd-996   [001]   126.623142: nfsd_compound:        xid=0x3b34e2b1 opcnt=1
  >>>>      nfsd-996   [001]   126.623146: nfsd_clid_confirmed:  client 60958e3b:9213ef0e
            nfsd-996   [001]   126.623148: nfsd_cb_probe:        addr=192.168.2.51:45901 client 60958e3b:9213ef0e state=UNKNOWN
            nfsd-996   [001]   126.623154: nfsd_compound_status: op=1/1 OP_SETCLIENTID_CONFIRM status=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 +++++-----
 fs/nfsd/trace.h     |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6abe48dee6ed..67ebb040bc5f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2816,14 +2816,14 @@ move_to_confirmed(struct nfs4_client *clp)
 
 	lockdep_assert_held(&nn->client_lock);
 
-	dprintk("NFSD: move_to_confirm nfs4_client %p\n", clp);
 	list_move(&clp->cl_idhash, &nn->conf_id_hashtbl[idhashval]);
 	rb_erase(&clp->cl_namenode, &nn->unconf_name_tree);
 	add_clp_to_name_tree(clp, &nn->conf_name_tree);
-	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags) &&
-	    clp->cl_nfsd_dentry &&
-	    clp->cl_nfsd_info_dentry)
-		fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
+	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags)) {
+		trace_nfsd_clid_confirmed(&clp->cl_clientid);
+		if (clp->cl_nfsd_dentry && clp->cl_nfsd_info_dentry)
+			fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
+	}
 	renew_client_locked(clp);
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 42ad2a02f953..e7a269291a73 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -511,6 +511,7 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 	TP_PROTO(const clientid_t *clid), \
 	TP_ARGS(clid))
 
+DEFINE_CLIENTID_EVENT(confirmed);
 DEFINE_CLIENTID_EVENT(expired);
 DEFINE_CLIENTID_EVENT(purged);
 DEFINE_CLIENTID_EVENT(renew);
-- 
2.30.2



