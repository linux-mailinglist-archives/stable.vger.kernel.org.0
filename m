Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED0E40E261
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242899AbhIPQha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242451AbhIPQf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 335F6619A6;
        Thu, 16 Sep 2021 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809287;
        bh=ajjy6T4IfK8uBofyoeCYRqWiaeg9CzcoAga4+dJTkRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1D3dT7pj6byT/hNYMOWwb8oPXxdGZrGABkRychhX41khdd5mE8SwQuuoHuC8ezsF
         SMJ/g3ls/mhs6l2drHYkG4INpkxXUAX3jNbBfKXoDoS4qbeLQoXtreJPbl399NiSt4
         kM8hTJLL3vC1P1a/XstycMj8gZL54sEl0Yum7UJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 099/380] SUNRPC query transports source port
Date:   Thu, 16 Sep 2021 17:57:36 +0200
Message-Id: <20210916155807.393221437@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit a8482488a7d6d320f63a9ee1912dbb5ae5b80a61 ]

Provide ability to query transport's source port.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprtsock.h | 1 +
 net/sunrpc/xprtsock.c           | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 3c1423ee74b4..8c2a712cb242 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -10,6 +10,7 @@
 
 int		init_socket_xprt(void);
 void		cleanup_socket_xprt(void);
+unsigned short	get_srcport(struct rpc_xprt *);
 
 #define RPC_MIN_RESVPORT	(1U)
 #define RPC_MAX_RESVPORT	(65535U)
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 3228b7a1836a..3bbf47046e8a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1648,6 +1648,13 @@ static int xs_get_srcport(struct sock_xprt *transport)
 	return port;
 }
 
+unsigned short get_srcport(struct rpc_xprt *xprt)
+{
+	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
+	return sock->srcport;
+}
+EXPORT_SYMBOL(get_srcport);
+
 static unsigned short xs_next_srcport(struct sock_xprt *transport, unsigned short port)
 {
 	if (transport->srcport != 0)
-- 
2.30.2



