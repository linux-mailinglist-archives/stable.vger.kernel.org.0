Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAAF28BA06
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgJLOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbgJLNfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D00322228;
        Mon, 12 Oct 2020 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509721;
        bh=Qu/D204b/JjExOKDA9rk9cmwpFruwflkqbo/pNv2qZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6njpvxDizBzEYfoUn/zCqI2iZFc1koZrmXMH6fMmBBW+IunV4EH//IJke1U2kKVR
         aJiCc2lBeLRD7hRGNyaa2eHXVSDOJ8b0yub3yu6PpnAdEnRFYL/PZ4JRBSaiQGk0/a
         HhrxdnTSCwSZK5+gu4V7SnzGjGeX6UgusDJjC57c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 49/54] rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
Date:   Mon, 12 Oct 2020 15:27:11 +0200
Message-Id: <20201012132631.838931371@linuxfoundation.org>
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
index fd9260620824e..01d2d40ef21cb 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1104,7 +1104,8 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default: /* we have a ticket we can't encode */
-			BUG();
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
 			continue;
 		}
 
@@ -1225,7 +1226,6 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default:
-			BUG();
 			break;
 		}
 
-- 
2.25.1



