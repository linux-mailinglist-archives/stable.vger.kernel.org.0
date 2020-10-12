Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0BF28BA02
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgJLOFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbgJLNf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04B722203;
        Mon, 12 Oct 2020 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509726;
        bh=/hxe9addzgsfIKyP7sFYqT4K5eZlskGM9ITZGN5/8lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpcXSvlonZA8fQGoKwFpv5UizYZIIGyoM8DXpUagdHk5i3LAcXmvbAZOAzuxJhdaw
         Z6cDKMEHwXXK4bRD9sQGUzUyv6FWPnRmnYPXvHTE3tCyMXCxV+2Vvwn1u/W9lSvJ6y
         Hona8+e49dlcplQESbSsP1OXNp/Sjp+6Xpi/NzFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 51/54] rxrpc: Fix server keyring leak
Date:   Mon, 12 Oct 2020 15:27:13 +0200
Message-Id: <20201012132631.937441267@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 38b1dc47a35ba14c3f4472138ea56d014c2d609b ]

If someone calls setsockopt() twice to set a server key keyring, the first
keyring is leaked.

Fix it to return an error instead if the server key keyring is already set.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 01d2d40ef21cb..fa475b02bdceb 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -899,7 +899,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, char __user *optval, int optlen)
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
 		return -EINVAL;
 
 	description = memdup_user_nul(optval, optlen);
-- 
2.25.1



