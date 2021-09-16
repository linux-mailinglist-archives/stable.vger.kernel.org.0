Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018F240DF5F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhIPQJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234885AbhIPQIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62B4B6126A;
        Thu, 16 Sep 2021 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808406;
        bh=TCbqOC2lMijmDTVUlPZ/0ufFEh+w9K8qNu7szvP34sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO+bWwKcuZ59/ovisIHysARscl7LCu1B8TSajqTyPwAX63MluYX2ZC1JL9DDC0y7K
         KfIq98b3QSbkOCn1ZUETVyXKRni+I4tSQ+Dpq6I3knAYuoNaYwsX7QcoI0NWITLbvL
         Ul3iW6aGgnFi+fD5+DA4uiHqH3Z7A2NaklD49iIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/306] SUNRPC query transports source port
Date:   Thu, 16 Sep 2021 17:57:05 +0200
Message-Id: <20210916155756.781145663@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 9c0f71e82d97..7d7c08af54de 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1639,6 +1639,13 @@ static int xs_get_srcport(struct sock_xprt *transport)
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



