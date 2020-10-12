Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF34428B99D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbgJLOCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbgJLNiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A424622268;
        Mon, 12 Oct 2020 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509868;
        bh=g9eZMOySVwoeHzqMnMxXsSUskHfz637tZ/TK/8hEtgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWy/z2jXvaMe4Z3+uOZhhWE1B47ufqujbUDpI5/fJ+kscbyk7/hNpu/2Ndcask3n3
         U2gIdWNCasBroVgR9uJY9DM0NKH+memnjQ4fZ3glM+643KZjXE8kiTnER/E0ckt692
         xy0cXgmfIFosFsdDQuNF4+kHqShCUkH/cWog9eKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 64/70] rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
Date:   Mon, 12 Oct 2020 15:27:20 +0200
Message-Id: <20201012132633.284230434@linuxfoundation.org>
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

[ Upstream commit 9a059cd5ca7d9c5c4ca5a6e755cf72f230176b6a ]

If rxrpc_read() (which allows KEYCTL_READ to read a key), sees a token of a
type it doesn't recognise, it can BUG in a couple of places, which is
unnecessary as it can easily get back to userspace.

Fix this to print an error message instead.

Fixes: 99455153d067 ("RxRPC: Parse security index 5 keys (Kerberos 5)")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/key.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index fead67b42a993..1fe203c56faf0 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1110,7 +1110,8 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default: /* we have a ticket we can't encode */
-			BUG();
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
 			continue;
 		}
 
@@ -1226,7 +1227,6 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default:
-			BUG();
 			break;
 		}
 
-- 
2.25.1



