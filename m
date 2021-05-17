Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2468F3834A1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbhEQPLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241669AbhEQPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF9261C35;
        Mon, 17 May 2021 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261794;
        bh=yrd9r5JwA3yOvNf7FmsslUm1ObnMa9Zr1q/nKRW35Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlK89+BjptzDNSYEJhDO/H/hnqmd838KD7keUfTCq18A2sgbgHiNJ3UXE2IT9ehXW
         HcJMHfOkAqRPFaqdWIEvt3zdaYNknk5ukVZ0JE9Y5IFSDPhvDYEnRWQiFYYHjdTVRA
         QqLovYSPJ94V22xT0NUze6gfiBDEY31BLDIrqtjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 165/329] SUNRPC: fix ternary sign expansion bug in tracing
Date:   Mon, 17 May 2021 16:01:16 +0200
Message-Id: <20210517140307.721541280@linuxfoundation.org>
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
index 5a809c64dc7b..42a400135d41 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1176,7 +1176,7 @@ static int svc_tcp_sendto(struct svc_rqst *rqstp)
 		goto out_notconn;
 	err = svc_tcp_sendmsg(svsk->sk_sock, &msg, xdr, marker, &sent);
 	xdr_free_bvec(xdr);
-	trace_svcsock_tcp_send(xprt, err < 0 ? err : sent);
+	trace_svcsock_tcp_send(xprt, err < 0 ? (long)err : sent);
 	if (err < 0 || sent != (xdr->len + sizeof(marker)))
 		goto out_close;
 	mutex_unlock(&xprt->xpt_mutex);
-- 
2.30.2



