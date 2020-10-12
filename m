Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6CF28B779
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgJLNnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgJLNnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6BF20838;
        Mon, 12 Oct 2020 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510182;
        bh=WNWnkFrg3u7y8D9ZPKPunc+98N2g9XUHgudcluYBRiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbnQrC8SA93iBmGRNSrxheJbHHoEwcqvSaS86+OUu40s0Jw4Ls/Cgudk81f++HPpT
         fhygEoot0KqfJpxVW4ktqq4TUPra0mgK9E4OOJU+98xaGJ4R0PJ2EJqnqx/nFQqOKK
         OfHWxm/kFf/VxJRvcSm6aWDZZHJbcmUX8j7Nan/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 74/85] rxrpc: Fix server keyring leak
Date:   Mon, 12 Oct 2020 15:27:37 +0200
Message-Id: <20201012132636.408385462@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
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



