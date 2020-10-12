Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F41B28B99A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgJLOCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgJLNiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574A22224A;
        Mon, 12 Oct 2020 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509872;
        bh=VG9CSanfmLO4eHxmZo/+noXJhoJKQEcs8kV3iIYycxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mYJyRgyn17n3C+pv6eMQndEvQ0mKwLgJ7CvM0F6dhvckH0I8P+JCPIItqLW+3UtC
         fxu/5CaBfFLTIfN9PlivR2Y1OVsAUyNRy4PQads8V2jyRkkspyYOxkGResOS/5kIxM
         yaus0z/yZBNHk1iTQpN8W1jUtS7KtVplBMtBXA60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 66/70] rxrpc: Fix server keyring leak
Date:   Mon, 12 Oct 2020 15:27:22 +0200
Message-Id: <20201012132633.380426962@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
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
index 1fe203c56faf0..2fe2add62a8ed 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -905,7 +905,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, char __user *optval, int optlen)
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
 		return -EINVAL;
 
 	description = memdup_user_nul(optval, optlen);
-- 
2.25.1



