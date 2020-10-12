Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEBD28B674
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgJLNd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389034AbgJLNdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7706215A4;
        Mon, 12 Oct 2020 13:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509584;
        bh=VJP6cWDmF70P//hqJEqs4hXISTyeBc5QluYFXdLwK/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQl6B6t2MEteqAhX06nD0PNRd4VXytcPaNzs+VBNNcfQKd+o5PJf9ziwix4nbPpo2
         k64s8gpOAVM8RnhMjxv6Vrywe2l3s1G9j0z0n8/sQcRfNaNyjocPTQikCfOLW6jqmP
         seVTQgjvtuVCTMgy2CBXgwJCZxhbPWYrm94bxgv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 37/39] rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
Date:   Mon, 12 Oct 2020 15:27:07 +0200
Message-Id: <20201012132629.870534627@linuxfoundation.org>
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

[ Upstream commit 9a059cd5ca7d9c5c4ca5a6e755cf72f230176b6a ]

If rxrpc_read() (which allows KEYCTL_READ to read a key), sees a token of a
type it doesn't recognise, it can BUG in a couple of places, which is
unnecessary as it can easily get back to userspace.

Fix this to print an error message instead.

Fixes: 99455153d067 ("RxRPC: Parse security index 5 keys (Kerberos 5)")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-key.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 543d200f4fa14..20549c13eb13d 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -1114,7 +1114,8 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default: /* we have a ticket we can't encode */
-			BUG();
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
 			continue;
 		}
 
@@ -1235,7 +1236,6 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default:
-			BUG();
 			break;
 		}
 
-- 
2.25.1



