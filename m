Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C358C47AE05
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhLTO5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33390 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbhLTOze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFABAB80EE7;
        Mon, 20 Dec 2021 14:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07931C36AE8;
        Mon, 20 Dec 2021 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012131;
        bh=efZXgrSFvt9MLZMqal5HkYXjXD3jktQps6S3uFI9sdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9qoV6+sqDr6wJPWAemN73zr8fxFB9BGP68gctipd5zfhbq1SBaazdr3y3d88AnhG
         8ZZPDh008quZypGJZjAvroOOuC8kSIUvZf99Xa9xfaQ/pMfmQaI5VdPDQoz/r0TjeL
         LXm5+5OwWQDhbhCZXpeYhGmvDvgqj6K5lD3pMwF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/177] mptcp: clear kern flag from fallback sockets
Date:   Mon, 20 Dec 2021 15:34:01 +0100
Message-Id: <20211220143043.176566096@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d6692b3b97bdc165d150f4c1505751a323a80717 ]

The mptcp ULP extension relies on sk->sk_sock_kern being set correctly:
It prevents setsockopt(fd, IPPROTO_TCP, TCP_ULP, "mptcp", 6); from
working for plain tcp sockets (any userspace-exposed socket).

But in case of fallback, accept() can return a plain tcp sk.
In such case, sk is still tagged as 'kernel' and setsockopt will work.

This will crash the kernel, The subflow extension has a NULL ctx->conn
mptcp socket:

BUG: KASAN: null-ptr-deref in subflow_data_ready+0x181/0x2b0
Call Trace:
 tcp_data_ready+0xf8/0x370
 [..]

Fixes: cf7da0d66cc1 ("mptcp: Create SUBFLOW socket for incoming connections")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 421fa62ce5cdf..fdff811c9a0da 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2901,7 +2901,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		 */
 		if (WARN_ON_ONCE(!new_mptcp_sock)) {
 			tcp_sk(newsk)->is_mptcp = 0;
-			return newsk;
+			goto out;
 		}
 
 		/* acquire the 2nd reference for the owning socket */
@@ -2913,6 +2913,8 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	}
 
+out:
+	newsk->sk_kern_sock = kern;
 	return newsk;
 }
 
-- 
2.33.0



