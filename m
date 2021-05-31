Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D5E395F73
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhEaOLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhEaOJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1087A6145F;
        Mon, 31 May 2021 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468413;
        bh=SUSzlEVEmHgMiHeLtBCO7zpTUDU7+Muby84fd2VYuMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBOZLmtg77+aGZ8HCA4mDni5wvUBWmotqVff69YCNehnkEEnJyDKfmW+cDxZZ+0HX
         TWg7YEwFUF6DIsYehuoxD6PBctEYnV3+opfWwXHd5QKQMucdg4QtdjKZ90fUuGzRuK
         iTLiba2G93bb3A5R9vKx+OtmZw+SaT8z3E55BT8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/252] net: really orphan skbs tied to closing sk
Date:   Mon, 31 May 2021 15:14:23 +0200
Message-Id: <20210531130704.743041050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 098116e7e640ba677d9e345cbee83d253c13d556 ]

If the owing socket is shutting down - e.g. the sock reference
count already dropped to 0 and only sk_wmem_alloc is keeping
the sock alive, skb_orphan_partial() becomes a no-op.

When forwarding packets over veth with GRO enabled, the above
causes refcount errors.

This change addresses the issue with a plain skb_orphan() call
in the critical scenario.

Fixes: 9adc89af724f ("net: let skb_orphan_partial wake-up waiters.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 4 +++-
 net/core/sock.c    | 8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 261195598df3..f68184b8c0aa 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2197,13 +2197,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
-static inline void skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
+static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
 {
 	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
 		skb_orphan(skb);
 		skb->destructor = sock_efree;
 		skb->sk = sk;
+		return true;
 	}
+	return false;
 }
 
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
diff --git a/net/core/sock.c b/net/core/sock.c
index c75c1e723a84..dee29f41beaf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2099,10 +2099,10 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (can_skb_orphan_partial(skb))
-		skb_set_owner_sk_safe(skb, skb->sk);
-	else
-		skb_orphan(skb);
+	if (can_skb_orphan_partial(skb) && skb_set_owner_sk_safe(skb, skb->sk))
+		return;
+
+	skb_orphan(skb);
 }
 EXPORT_SYMBOL(skb_orphan_partial);
 
-- 
2.30.2



