Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A99628B842
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390085AbgJLNum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731876AbgJLNsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B28F120679;
        Mon, 12 Oct 2020 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510448;
        bh=WNWnkFrg3u7y8D9ZPKPunc+98N2g9XUHgudcluYBRiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiOwtVRM/cuRQJehqUcsrScEC2kgWsYBBX2J03vEM+F9Z8SNc/BFIu55nExzgrrb8
         a30uHmEw3swFu8G1MV4P5XKFSpjU23/ThUT36YUPRfXhZXLugryJU+B2waiTYhQylc
         RxnINO5z7j5Tck9gHwtSmo/JI/nfwO/t0OmBxVh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 103/124] rxrpc: Fix server keyring leak
Date:   Mon, 12 Oct 2020 15:31:47 +0200
Message-Id: <20201012133151.848250785@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
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
index 64cbbd2f16944..85a9ff8cd236a 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -903,7 +903,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, char __user *optval, int optlen)
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
 		return -EINVAL;
 
 	description = memdup_user_nul(optval, optlen);
-- 
2.25.1



