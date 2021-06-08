Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4623A0180
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhFHSxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235381AbhFHSvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A9E61476;
        Tue,  8 Jun 2021 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177587;
        bh=Y9U2b2BkW9H+Tw7mu4opEI/j+Y7MRAYm8/+eKXlAj2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnczJwvvqSbWajGbwQ6VDp/gDB4ru4kPrJdRdjvmky/pcbnl8UpM/d35zc18PMaiA
         juWPgSg5rONlGuykiYYyrh8qVqan7impzZDakj5tBwA/6CtbPHDck/9CUmBP9KDWnZ
         gZWgEh0bdHah4UTn6d4PE7bPGry5Rv4r+hitdwNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/137] net: sock: fix in-kernel mark setting
Date:   Tue,  8 Jun 2021 20:26:06 +0200
Message-Id: <20210608175943.301631370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit dd9082f4a9f94280fbbece641bf8fc0a25f71f7a ]

This patch fixes the in-kernel mark setting by doing an additional
sk_dst_reset() which was introduced by commit 50254256f382 ("sock: Reset
dst when changing sk_mark via setsockopt"). The code is now shared to
avoid any further suprises when changing the socket mark value.

Fixes: 84d1c617402e ("net: sock: add sock_set_mark")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index dee29f41beaf..7de51ea15cdf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -807,10 +807,18 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+static void __sock_set_mark(struct sock *sk, u32 val)
+{
+	if (val != sk->sk_mark) {
+		sk->sk_mark = val;
+		sk_dst_reset(sk);
+	}
+}
+
 void sock_set_mark(struct sock *sk, u32 val)
 {
 	lock_sock(sk);
-	sk->sk_mark = val;
+	__sock_set_mark(sk, val);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_mark);
@@ -1118,10 +1126,10 @@ set_sndbuf:
 	case SO_MARK:
 		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
-		} else if (val != sk->sk_mark) {
-			sk->sk_mark = val;
-			sk_dst_reset(sk);
+			break;
 		}
+
+		__sock_set_mark(sk, val);
 		break;
 
 	case SO_RXQ_OVFL:
-- 
2.30.2



