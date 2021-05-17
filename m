Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB4383538
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243958AbhEQPQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243092AbhEQPNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B95061C43;
        Mon, 17 May 2021 14:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261905;
        bh=OLHoGQNVrRWFGL2YrKjFirFf+zH5qpj+7c5HghmxiIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGfwmR9LssY0UX6sDybhoExYU2FhpeW9B/zU1AeOCFn82o05Pu0HmCAAeJg8yf+C9
         JTJFHgNm3Xc9lCMisVt7iBHZI8IKFKh4xx6dKTK4b9Uzu3sLlOue9Gyx9IGqyIzI3F
         Zzd5hAaXUnInsTYSJwE+ZQeyEZl86+OsgJyU+xlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 170/329] xprtrdma: rpcrdma_mr_pop() already does list_del_init()
Date:   Mon, 17 May 2021 16:01:21 +0200
Message-Id: <20210517140307.878795182@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index e8b25f9290ab..0104430e4c8e 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -582,7 +582,6 @@ void frwr_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		mr = container_of(frwr, struct rpcrdma_mr, frwr);
 		bad_wr = bad_wr->next;
 
-		list_del_init(&mr->mr_list);
 		frwr_mr_recycle(mr);
 	}
 }
-- 
2.30.2



