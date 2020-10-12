Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75C828B843
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbgJLNun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731875AbgJLNsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688752080D;
        Mon, 12 Oct 2020 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510445;
        bh=zMPTSppgLzmbbQLiE/k+1g2l4o5RSNonPo1tZQMtE1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3cRZt998Ybb7qODHww5fBqpGWwHdzT9FAgW/Hi29QhKBb41feWHNtg5YqfGpDw3F
         RAMbZlXDOYocXNmPgpEvZqYWOL/3hmPh7urnreHO3R7YKssLNzO8nOqVFCHFLzACWD
         ySFLTaE9VyBxtm59IZn2FMkPh5pVLHijuTSKJvQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 102/124] rxrpc: The server keyring isnt network-namespaced
Date:   Mon, 12 Oct 2020 15:31:46 +0200
Message-Id: <20201012133151.799831398@linuxfoundation.org>
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

[ Upstream commit fea99111244bae44e7d82a973744d27ea1567814 ]

The keyring containing the server's tokens isn't network-namespaced, so it
shouldn't be looked up with a network namespace.  It is expected to be
owned specifically by the server, so namespacing is unnecessary.

Fixes: a58946c158a0 ("keys: Pass the network namespace into request_key mechanism")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 32f46edcf7c67..64cbbd2f16944 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -941,7 +941,7 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, char __user *optval,
 	if (IS_ERR(description))
 		return PTR_ERR(description);
 
-	key = request_key_net(&key_type_keyring, description, sock_net(&rx->sk), NULL);
+	key = request_key(&key_type_keyring, description, NULL);
 	if (IS_ERR(key)) {
 		kfree(description);
 		_leave(" = %ld", PTR_ERR(key));
-- 
2.25.1



