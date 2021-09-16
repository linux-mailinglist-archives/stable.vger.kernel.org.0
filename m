Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77840E257
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241861AbhIPQhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244371AbhIPQfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954C861994;
        Thu, 16 Sep 2021 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809271;
        bh=5BK9XdaeTZ82lpNiUBDQYwONct9Gtl02nQ2vZYZaTXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tWB/CZOqq9mN0FUghJ56FiiM5HPskn/WcNYxQMh60X9BcSwlT2cj4moWP1MpIvjG
         wCZBJklK44mr+7G9CMyk9uIpowM/Wd2LY+vmw2VNLIx7G3YPey45WBfuSuUCxa2rnP
         Rbu0Ep3GIBxg/ng6Hs6vLmIptQJIeC0jG+K4AcUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 093/380] xprtrdma: Put rpcrdma_reps before waking the tear-down completion
Date:   Thu, 16 Sep 2021 17:57:30 +0200
Message-Id: <20210916155807.198677255@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 97480cae13ca3a9c1de3eb6fd66cf9650a60db42 ]

Ensure the tear-down completion is awoken only /after/ we've stopped
fiddling with rpcrdma_rep objects in rpcrdma_post_recvs().

Fixes: 15788d1d1077 ("xprtrdma: Do not refresh Receive Queue while it is draining")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 649c23518ec0..5a11e318a0d9 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1416,11 +1416,6 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 
 	rc = ib_post_recv(ep->re_id->qp, wr,
 			  (const struct ib_recv_wr **)&bad_wr);
-	if (atomic_dec_return(&ep->re_receiving) > 0)
-		complete(&ep->re_done);
-
-out:
-	trace_xprtrdma_post_recvs(r_xprt, count, rc);
 	if (rc) {
 		for (wr = bad_wr; wr;) {
 			struct rpcrdma_rep *rep;
@@ -1431,6 +1426,11 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 			--count;
 		}
 	}
+	if (atomic_dec_return(&ep->re_receiving) > 0)
+		complete(&ep->re_done);
+
+out:
+	trace_xprtrdma_post_recvs(r_xprt, count, rc);
 	ep->re_receive_count += count;
 	return;
 }
-- 
2.30.2



