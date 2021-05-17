Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85240382FFE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhEQOWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237416AbhEQOUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:20:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D7F76145C;
        Mon, 17 May 2021 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260688;
        bh=V67MZokF6hVXxbAyBiyCldiZnykDDti5nA0ZlYz4M2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ctpvvl3jIrIYYvfZzf81ndqU4f/jBiQyGSIxYHXj8Gxk6kEUmWHp2Iy++in2jhdwF
         N+1EsUcHEzONU+Dgnm2bot1UHG1PMtfELVOuDuKdhnt8AHmuHZz//XjEUXGM7r5zBc
         Mta3X0Wwinn2G5G1WjEvar9URkLPBvE20O/bEEwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 178/363] SUNRPC: fix ternary sign expansion bug in tracing
Date:   Mon, 17 May 2021 16:00:44 +0200
Message-Id: <20210517140308.619608919@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cb579086536f6564f5846f89808ec394ef8b8621 ]

This code is supposed to pass negative "err" values for tracing but it
passes positive values instead.  The problem is that the
trace_svcsock_tcp_send() function takes a long but "err" is an int and
"sent" is a u32.  The negative is first type promoted to u32 so it
becomes a high positive then it is promoted to long and it stays
positive.

Fix this by casting "err" directly to long.

Fixes: 998024dee197 ("SUNRPC: Add more svcsock tracepoints")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 2e2f007dfc9f..7cde41a936a4 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1171,7 +1171,7 @@ static int svc_tcp_sendto(struct svc_rqst *rqstp)
 	tcp_sock_set_cork(svsk->sk_sk, true);
 	err = svc_tcp_sendmsg(svsk->sk_sock, xdr, marker, &sent);
 	xdr_free_bvec(xdr);
-	trace_svcsock_tcp_send(xprt, err < 0 ? err : sent);
+	trace_svcsock_tcp_send(xprt, err < 0 ? (long)err : sent);
 	if (err < 0 || sent != (xdr->len + sizeof(marker)))
 		goto out_close;
 	if (atomic_dec_and_test(&svsk->sk_sendqlen))
-- 
2.30.2



