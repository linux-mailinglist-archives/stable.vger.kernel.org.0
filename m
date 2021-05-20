Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5F438A0D7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhETJ0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhETJ0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F7761244;
        Thu, 20 May 2021 09:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502693;
        bh=tUlpM3DQBjSnWR7vaADyD1QCt5Vsf2xpNC/talcvKrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYD9IY2aLVVKeXzlxH9Y9JW4jDGD7ki06xfnuivUNFztMuLqL+4d76Cx02Xc+HstF
         tmZhcHFcr4/5pURY9PBH+9r9GZeXFLnEBLsL8PHw+/60EGa22sEcO7ZGKM0f07cGEE
         QxWPd1lY126SLSu/PlBf5plnC/0DmhJDZKYmVs+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 17/45] svcrdma: Dont leak send_ctxt on Send errors
Date:   Thu, 20 May 2021 11:22:05 +0200
Message-Id: <20210520092054.083978290@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 351461f332db5670056a9c6bce6916027f91072f ]

Address a rare send_ctxt leak in the svc_rdma_sendto() error paths.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 52c759a8543e..3669661457c1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -958,7 +958,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	p = xdr_reserve_space(&sctxt->sc_stream,
 			      rpcrdma_fixed_maxsz * sizeof(*p));
 	if (!p)
-		goto err0;
+		goto err1;
 
 	ret = svc_rdma_send_reply_chunk(rdma, rctxt, &rqstp->rq_res);
 	if (ret < 0)
@@ -970,11 +970,11 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	*p = pcl_is_empty(&rctxt->rc_reply_pcl) ? rdma_msg : rdma_nomsg;
 
 	if (svc_rdma_encode_read_list(sctxt) < 0)
-		goto err0;
+		goto err1;
 	if (svc_rdma_encode_write_list(rctxt, sctxt) < 0)
-		goto err0;
+		goto err1;
 	if (svc_rdma_encode_reply_chunk(rctxt, sctxt, ret) < 0)
-		goto err0;
+		goto err1;
 
 	ret = svc_rdma_send_reply_msg(rdma, sctxt, rctxt, rqstp);
 	if (ret < 0)
-- 
2.30.2



