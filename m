Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC428B65E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389064AbgJLNdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389059AbgJLNdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42717221EB;
        Mon, 12 Oct 2020 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509586;
        bh=0BeFLgFqdU3EcsLD1F/sJ6++72ggvfkwP3dYbDM0IPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrPjHUl8HVbje0v8arv8eMxcWJS1C8vFjY5w1pqcKXcvhQIEpV6SYKomnr2JkcQCM
         goVfnZsUc+wGvGiGYYrNEZRykxsz9A9bTX4iX6xvJfPijZsxQYpCMeX8Mv/6n+NHS/
         PO2sBXWruKkVL5Ys/q020asAo/gsYDtmkH3BfofI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 38/39] rxrpc: Fix server keyring leak
Date:   Mon, 12 Oct 2020 15:27:08 +0200
Message-Id: <20201012132629.911556969@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
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
 net/rxrpc/ar-key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -897,7 +897,7 @@ int rxrpc_request_key(struct rxrpc_sock
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
 		return -EINVAL;
 
 	description = kmalloc(optlen + 1, GFP_KERNEL);


