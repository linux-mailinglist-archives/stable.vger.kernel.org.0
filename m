Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E371226622
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbgGTQAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732425AbgGTQAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCCE20672;
        Mon, 20 Jul 2020 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260835;
        bh=xn0D/tzDqjhKFWrjKYeEsuhHoeqsIK0mp/IoX8f0R+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdMSe71Y5RZG+pRCKATYzzJsl6CJPNA4PLhCyJX1Mq4R352KMNvE/PKrwijp3+DgZ
         GKU8wirU5tMeKRO6dRQnBmVbMu05AReVpH/v0W2vCDIMPIEZZdUJjDc0mZ8CPiOOnx
         u77aFRO5ruYn0rYFIMAGL4gGnBAUYIC7NhF2vvBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/215] xprtrdma: fix incorrect header size calculations
Date:   Mon, 20 Jul 2020 17:36:36 +0200
Message-Id: <20200720152825.622123745@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 912288442cb2f431bf3c8cb097a5de83bc6dbac1 ]

Currently the header size calculations are using an assignment
operator instead of a += operator when accumulating the header
size leading to incorrect sizes.  Fix this by using the correct
operator.

Addresses-Coverity: ("Unused value")
Fixes: 302d3deb2068 ("xprtrdma: Prevent inline overflow")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c56e6cfc4a623..21970185485fc 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -71,7 +71,7 @@ static unsigned int rpcrdma_max_call_header_size(unsigned int maxsegs)
 	size = RPCRDMA_HDRLEN_MIN;
 
 	/* Maximum Read list size */
-	size = maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
+	size += maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
 
 	/* Minimal Read chunk size */
 	size += sizeof(__be32);	/* segment count */
@@ -96,7 +96,7 @@ static unsigned int rpcrdma_max_reply_header_size(unsigned int maxsegs)
 	size = RPCRDMA_HDRLEN_MIN;
 
 	/* Maximum Write list size */
-	size = sizeof(__be32);		/* segment count */
+	size += sizeof(__be32);		/* segment count */
 	size += maxsegs * rpcrdma_segment_maxsz * sizeof(__be32);
 	size += sizeof(__be32);	/* list discriminator */
 
-- 
2.25.1



