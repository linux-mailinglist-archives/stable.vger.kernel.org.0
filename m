Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BC539625A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhEaOzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhEaOxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBA6F61CB0;
        Mon, 31 May 2021 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469527;
        bh=TH/iVztw0bSKWElDHsp7M5gULAbAxyB6k1D4iKkmr1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yO6p8I4YYI6k29d6wF2vDS0ojCL8SMoLzxDqucdv8EpuYuDOI/vXuXb/n47ZkL68j
         n56708/bLXQ1O2G76yGbK9JxzO2w2UvGnDe4epc3PzsnHdWTTuEUFON2ogVqxP4zBv
         oWVnolALo2JOZsGPJXa45MpTzJGSxjhu2J1lvn3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 231/296] net: really orphan skbs tied to closing sk
Date:   Mon, 31 May 2021 15:14:46 +0200
Message-Id: <20210531130711.577587470@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index 8487f58da36d..62e3811e95a7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2225,13 +2225,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
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
index 5ec90f99e102..9c7b143e7a96 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2132,10 +2132,10 @@ void skb_orphan_partial(struct sk_buff *skb)
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



