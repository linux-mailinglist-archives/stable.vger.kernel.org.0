Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E403CE2B4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhGSPbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347568AbhGSPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61516142B;
        Mon, 19 Jul 2021 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710312;
        bh=Vwc3Tks9Vnnq11HP2Twi3ZLq4f2ZwdlqiFJysSOkQ78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrJ76oer1XjYImMnPv0abgrTgO40hQSWaGbU6NXaQzI5U/dvyMWaXVt3ueVNDRZlQ
         ucw2YlgLHWHYNMDK6mtIq2VB6yu61tzYpgk2oY0A/BtHZySNnXdzvR9UNlRaQfBszH
         rYJTeuxw/AFjqD9LZcqbqK0eUE1ps/PLjT/kKlpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/243] SUNRPC: prevent port reuse on transports which dont request it.
Date:   Mon, 19 Jul 2021 16:53:12 +0200
Message-Id: <20210719144946.160122928@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit bc1c56e9bbe92766d017efb5f0a0c71f80da5570 ]

If an RPC client is created without RPC_CLNT_CREATE_REUSEPORT, it should
not reuse the source port when a TCP connection is re-established.
This is currently implemented by preventing the source port being
recorded after a successful connection (the call to xs_set_srcport()).

However the source port is also recorded after a successful bind in xs_bind().
This may not be needed at all and certainly is not wanted when
RPC_CLNT_CREATE_REUSEPORT wasn't requested.

So avoid that assignment when xprt.reuseport is not set.

With this change, NFSv4.1 and later mounts use a different port number on
each connection.  This is helpful with some firewalls which don't cope
well with port reuse.

Signed-off-by: NeilBrown <neilb@suse.de>
Fixes: e6237b6feb37 ("NFSv4.1: Don't rebind to the same source port when reconnecting to the server")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c56a66cdf4ac..9c0f71e82d97 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1680,7 +1680,8 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 		err = kernel_bind(sock, (struct sockaddr *)&myaddr,
 				transport->xprt.addrlen);
 		if (err == 0) {
-			transport->srcport = port;
+			if (transport->xprt.reuseport)
+				transport->srcport = port;
 			break;
 		}
 		last = port;
-- 
2.30.2



