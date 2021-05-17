Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647DF383043
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbhEQOZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhEQOXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28EA61454;
        Mon, 17 May 2021 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260739;
        bh=yeoGI1DqCsGV3faMoMtDsCse4dYM4foIpedGVcMUv0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5zROpfHENCXYI3nn7YQLmXkhfvEntkNAumYA8a9Vbs9HELIsWR68EqCwk0VEI8wL
         fqkXh0ZlQxsu2KjEuLxJCJe1R0tFFG/m3zH30EgrBz/153QvXfX2Ifiav3hJxnuRWy
         aWZHgdF/O/WkxWkCOmRiXqQtNMV7mNLMPBGGIJec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 183/363] xprtrdma: rpcrdma_mr_pop() already does list_del_init()
Date:   Mon, 17 May 2021 16:00:49 +0200
Message-Id: <20210517140308.776874141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1363e6388c363d0433f9aa4e2f33efe047572687 ]

The rpcrdma_mr_pop() earlier in the function has already cleared
out mr_list, so it must not be done again in the error path.

Fixes: 847568942f93 ("xprtrdma: Remove fr_state")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 132df9b59ab4..aca2228095db 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -576,7 +576,6 @@ void frwr_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		mr = container_of(frwr, struct rpcrdma_mr, frwr);
 		bad_wr = bad_wr->next;
 
-		list_del_init(&mr->mr_list);
 		frwr_mr_recycle(mr);
 	}
 }
-- 
2.30.2



