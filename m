Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB5E353CF2
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhDEI5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233232AbhDEI5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1CEE61393;
        Mon,  5 Apr 2021 08:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613047;
        bh=Zna8MsVGd8jIF5ImYQKHoirKHkeAX+SNgNmY9pwAG/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgGo990j8xZQb0E8mUMdOz5W9Xr7C7+IPl7cRPp85rWKMu4KS1Hyz+Os4Wb4jox7o
         b1i2QRTF44D/oGmsfgtvN/bMHBgiS1/Nwx2RUbBlD85v+Df4eovYYe84+9RoJUUz4c
         RNQ4ksR3A3PBYXW3Dxn1qZ1xSnptv3ptaihYuqS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/35] rpc: fix NULL dereference on kmalloc failure
Date:   Mon,  5 Apr 2021 10:53:39 +0200
Message-Id: <20210405085019.010467008@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 0ddc942394013f08992fc379ca04cffacbbe3dae ]

I think this is unlikely but possible:

svc_authenticate sets rq_authop and calls svcauth_gss_accept.  The
kmalloc(sizeof(*svcdata), GFP_KERNEL) fails, leaving rq_auth_data NULL,
and returning SVC_DENIED.

This causes svc_process_common to go to err_bad_auth, and eventually
call svc_authorise.  That calls ->release == svcauth_gss_release, which
tries to dereference rq_auth_data.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Link: https://lore.kernel.org/linux-nfs/3F1B347F-B809-478F-A1E9-0BE98E22B0F0@oracle.com/T/#t
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index fd897d900d12..85ad23d9a8a9 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1705,11 +1705,14 @@ static int
 svcauth_gss_release(struct svc_rqst *rqstp)
 {
 	struct gss_svc_data *gsd = (struct gss_svc_data *)rqstp->rq_auth_data;
-	struct rpc_gss_wire_cred *gc = &gsd->clcred;
+	struct rpc_gss_wire_cred *gc;
 	struct xdr_buf *resbuf = &rqstp->rq_res;
 	int stat = -EINVAL;
 	struct sunrpc_net *sn = net_generic(SVC_NET(rqstp), sunrpc_net_id);
 
+	if (!gsd)
+		goto out;
+	gc = &gsd->clcred;
 	if (gc->gc_proc != RPC_GSS_PROC_DATA)
 		goto out;
 	/* Release can be called twice, but we only wrap once. */
@@ -1750,10 +1753,10 @@ out_err:
 	if (rqstp->rq_cred.cr_group_info)
 		put_group_info(rqstp->rq_cred.cr_group_info);
 	rqstp->rq_cred.cr_group_info = NULL;
-	if (gsd->rsci)
+	if (gsd && gsd->rsci) {
 		cache_put(&gsd->rsci->h, sn->rsc_cache);
-	gsd->rsci = NULL;
-
+		gsd->rsci = NULL;
+	}
 	return stat;
 }
 
-- 
2.30.1



