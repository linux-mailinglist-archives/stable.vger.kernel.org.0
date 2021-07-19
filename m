Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB43CE519
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbhGSPrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349743AbhGSPpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6545B61107;
        Mon, 19 Jul 2021 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711960;
        bh=rTMgOv79F/l4TttVrJLYRolvjdl7NqhBa2y7ptEqZvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NOaOdIzrUk4Bs3fcCjYJN/Hkmm0sNzV70uBgpJ/OFWCWTDxpQjGNK99Qlj5OWVmB
         E+er9EeqiU/TZNBOJW5LakNjbzGfkwGPwfGaPCjjkrL2xtArAmR/YkBv+Jy561FL3M
         tZkiuZ5Z/Ai1VVwPLL22YAUqr9kqPglJvrkDJ/50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 197/292] SUNRPC: prevent port reuse on transports which dont request it.
Date:   Mon, 19 Jul 2021 16:54:19 +0200
Message-Id: <20210719144948.970620509@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index e35760f238a4..87cb0e36eade 100644
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



