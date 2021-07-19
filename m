Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436A73CE511
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhGSPrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349457AbhGSPpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70126613F5;
        Mon, 19 Jul 2021 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711901;
        bh=rpGBQzWXzgjo3gtp3C8cS/YdXc34mMtN2eKuObVQxd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEzyDWQPrBp1VY+TwyZrNz+2zxVukSA5rXo9RSFNvBysZT3IFO1Tr+ns520EedKXz
         LwXy5MzcfcabbYC4e0675IgZYNDIaEKBaIuhxmimLu+d4WQ+MGrFPLwNzzuSfi8VY8
         n4uaGM1Vm3PHHN5Sy1bjSsBtuKD/nYQojnHqvahg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wysochanski <dwysocha@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 174/292] NFSD: Fix TP_printk() format specifier in nfsd_clid_class
Date:   Mon, 19 Jul 2021 16:53:56 +0200
Message-Id: <20210719144948.221576903@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a948b1142cae66785521a389cab2cce74069b547 ]

Since commit 9a6944fee68e ("tracing: Add a verifier to check string
pointers for trace events"), which was merged in v5.13-rc1,
TP_printk() no longer tacitly supports the "%.*s" format specifier.

These are low value tracepoints, so just remove them.

Reported-by: David Wysochanski <dwysocha@redhat.com>
Fixes: dd5e3fbc1f47 ("NFSD: Add tracepoints to the NFSD state management code")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  3 ---
 fs/nfsd/trace.h     | 29 -----------------------------
 2 files changed, 32 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 886e50ed07c2..f8f528ce5835 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7150,7 +7150,6 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 	unsigned int strhashval;
 	struct nfs4_client_reclaim *crp;
 
-	trace_nfsd_clid_reclaim(nn, name.len, name.data);
 	crp = alloc_reclaim();
 	if (crp) {
 		strhashval = clientstr_hashval(name);
@@ -7200,8 +7199,6 @@ nfsd4_find_reclaim_client(struct xdr_netobj name, struct nfsd_net *nn)
 	unsigned int strhashval;
 	struct nfs4_client_reclaim *crp = NULL;
 
-	trace_nfsd_clid_find(nn, name.len, name.data);
-
 	strhashval = clientstr_hashval(name);
 	list_for_each_entry(crp, &nn->reclaim_str_hashtbl[strhashval], cr_strhash) {
 		if (compare_blob(&crp->cr_name, &name) == 0) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 92a0973dd671..02a795470229 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -512,35 +512,6 @@ DEFINE_EVENT(nfsd_net_class, nfsd_##name, \
 DEFINE_NET_EVENT(grace_start);
 DEFINE_NET_EVENT(grace_complete);
 
-DECLARE_EVENT_CLASS(nfsd_clid_class,
-	TP_PROTO(const struct nfsd_net *nn,
-		 unsigned int namelen,
-		 const unsigned char *namedata),
-	TP_ARGS(nn, namelen, namedata),
-	TP_STRUCT__entry(
-		__field(unsigned long long, boot_time)
-		__field(unsigned int, namelen)
-		__dynamic_array(unsigned char,  name, namelen)
-	),
-	TP_fast_assign(
-		__entry->boot_time = nn->boot_time;
-		__entry->namelen = namelen;
-		memcpy(__get_dynamic_array(name), namedata, namelen);
-	),
-	TP_printk("boot_time=%16llx nfs4_clientid=%.*s",
-		__entry->boot_time, __entry->namelen, __get_str(name))
-)
-
-#define DEFINE_CLID_EVENT(name) \
-DEFINE_EVENT(nfsd_clid_class, nfsd_clid_##name, \
-	TP_PROTO(const struct nfsd_net *nn, \
-		 unsigned int namelen, \
-		 const unsigned char *namedata), \
-	TP_ARGS(nn, namelen, namedata))
-
-DEFINE_CLID_EVENT(find);
-DEFINE_CLID_EVENT(reclaim);
-
 TRACE_EVENT(nfsd_clid_inuse_err,
 	TP_PROTO(const struct nfs4_client *clp),
 	TP_ARGS(clp),
-- 
2.30.2



