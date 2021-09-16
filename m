Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8ED40E5EF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbhIPRQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350545AbhIPRN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BD62619F7;
        Thu, 16 Sep 2021 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810350;
        bh=kDUuPOfXsWSJHGRpIB1p9brj1swMW//9eNzdQHy8r0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbMxxRk9BPJ49IdQVpyW9t+ajU5gu63HlJF/Bxlhz+CyY8BUjrQzYnv8LnPLqTR0J
         ozmEsz5URbnpKpYgFEg/3GYpCxUTNBQ7CTzRAAhBYn93a8I6YFnRopatbEZAJHLJF5
         3RKhC3sIecAfKSE6ye3CgcMJ2MaHJJsvbLjNSYdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 109/432] sunrpc: Fix return value of get_srcport()
Date:   Thu, 16 Sep 2021 17:57:38 +0200
Message-Id: <20210916155814.466355096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 5d46dd04cb68771f77ba66dbf6fd323a4a2ce00d ]

Since bc1c56e9bbe9 transport->srcport may by unset, causing
get_srcport() to return 0 when called. Fix this by querying the port
from the underlying socket instead of the transport.

Fixes: bc1c56e9bbe9 (SUNRPC: prevent port reuse on transports which don't request it)
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e573dcecdd66..02b071dbdd22 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1656,7 +1656,7 @@ static int xs_get_srcport(struct sock_xprt *transport)
 unsigned short get_srcport(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
-	return sock->srcport;
+	return xs_sock_getport(sock->sock);
 }
 EXPORT_SYMBOL(get_srcport);
 
-- 
2.30.2



