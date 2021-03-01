Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF7328A69
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhCASRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239099AbhCASJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 009C0651F9;
        Mon,  1 Mar 2021 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619213;
        bh=w9zisUQUAS9w/SiuNx6MHff6SU7ALi5/FRiFoGc3Rf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiU8olbPd7D21mWuH6L/+nSvbYeCm8UZWtMT8Pa+8cfM30bAsAavw9AQz3dgyfDBF
         2SyLXkycm0jAZAxbaXXsBHjEo8DiRhqXThw1fEGHZWq4fRA2I/sz6Ki7EHZjglKqsw
         5orKUv5ck8d67K+F/WdEMEQvY9U4ac6fSFEaVRxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/663] svcrdma: Hold private mutex while invoking rdma_accept()
Date:   Mon,  1 Mar 2021 17:10:22 +0100
Message-Id: <20210301161200.356835363@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0ac24c320c4d89a9de6ec802591398b8675c7b3c ]

RDMA core mutex locking was restructured by commit d114c6feedfe
("RDMA/cma: Add missing locking to rdma_accept()") [Aug 2020]. When
lock debugging is enabled, the RPC/RDMA server trips over the new
lockdep assertion in rdma_accept() because it doesn't call
rdma_accept() from its CM event handler.

As a temporary fix, have svc_rdma_accept() take the handler_mutex
explicitly. In the meantime, let's consider how to restructure the
RPC/RDMA transport to invoke rdma_accept() from the proper context.

Calls to svc_rdma_accept() are serialized with calls to
svc_rdma_free() by the generic RPC server layer.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-rdma/20210209154014.GO4247@nvidia.com/
Fixes: d114c6feedfe ("RDMA/cma: Add missing locking to rdma_accept()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index fb044792b571c..5f7e3d12523fe 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -475,9 +475,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	if (!svc_rdma_post_recvs(newxprt))
 		goto errout;
 
-	/* Swap out the handler */
-	newxprt->sc_cm_id->event_handler = svc_rdma_cma_handler;
-
 	/* Construct RDMA-CM private message */
 	pmsg.cp_magic = rpcrdma_cmp_magic;
 	pmsg.cp_version = RPCRDMA_CMP_VERSION;
@@ -498,7 +495,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	}
 	conn_param.private_data = &pmsg;
 	conn_param.private_data_len = sizeof(pmsg);
+	rdma_lock_handler(newxprt->sc_cm_id);
+	newxprt->sc_cm_id->event_handler = svc_rdma_cma_handler;
 	ret = rdma_accept(newxprt->sc_cm_id, &conn_param);
+	rdma_unlock_handler(newxprt->sc_cm_id);
 	if (ret) {
 		trace_svcrdma_accept_err(newxprt, ret);
 		goto errout;
-- 
2.27.0



