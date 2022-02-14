Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7C84B4B45
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347907AbiBNKb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348906AbiBNKbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B1D9DD54;
        Mon, 14 Feb 2022 01:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32FC4B80DCE;
        Mon, 14 Feb 2022 09:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6714AC340E9;
        Mon, 14 Feb 2022 09:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832782;
        bh=kBKRvywjjqjNpuL5Kwxupm6Ld+fvT0fycBmoWsPxpms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1NeO0WwjnmdrcLIglKw4oP43gB1tUvkNyVXHvyJqiD+ct+nMOw5avyocmLrL8fZC
         L60jcwd+3pu35cjICBqLPikFjo4mQAz0L5p7T3yz3+XHvYtxXg32EGbUuFiXLmkvDh
         +ewEPdyjzBtt3GJGctTJA6TpsQQgaXdiZKIgEk+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 123/203] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY) case
Date:   Mon, 14 Feb 2022 10:26:07 +0100
Message-Id: <20220214092514.420537078@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8d9d938514f46c4892aff6bfe32f425e84d81cc ]

syzbot found that mixing sendpage() and sendmsg(MSG_ZEROCOPY)
calls over the same TCP socket would again trigger the
infamous warning in inet_sock_destruct()

	WARN_ON(sk_forward_alloc_get(sk));

While Talal took into account a mix of regular copied data
and MSG_ZEROCOPY one in the same skb, the sendpage() path
has been forgotten.

We want the charging to happen for sendpage(), because
pages could be coming from a pipe. What is missing is the
downgrading of pure zerocopy status to make sure
sk_forward_alloc will stay synced.

Add tcp_downgrade_zcopy_pure() helper so that we can
use it from the two callers.

Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Link: https://lore.kernel.org/r/20220203225547.665114-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 94cbba9fb12b1..28abb0bb1c515 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -936,6 +936,22 @@ void tcp_remove_empty_skb(struct sock *sk)
 	}
 }
 
+/* skb changing from pure zc to mixed, must charge zc */
+static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
+{
+	if (unlikely(skb_zcopy_pure(skb))) {
+		u32 extra = skb->truesize -
+			    SKB_TRUESIZE(skb_end_offset(skb));
+
+		if (!sk_wmem_schedule(sk, extra))
+			return -ENOMEM;
+
+		sk_mem_charge(sk, extra);
+		skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
+	}
+	return 0;
+}
+
 static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 				      struct page *page, int offset, size_t *size)
 {
@@ -971,7 +987,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
-	if (!sk_wmem_schedule(sk, copy))
+	if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
 		return NULL;
 
 	if (can_coalesce) {
@@ -1319,19 +1335,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			/* skb changing from pure zc to mixed, must charge zc */
-			if (unlikely(skb_zcopy_pure(skb))) {
-				u32 extra = skb->truesize -
-					    SKB_TRUESIZE(skb_end_offset(skb));
-
-				if (!sk_wmem_schedule(sk, extra))
-					goto wait_for_space;
-
-				sk_mem_charge(sk, extra);
-				skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
-			}
-
-			if (!sk_wmem_schedule(sk, copy))
+			if (tcp_downgrade_zcopy_pure(sk, skb) ||
+			    !sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
-- 
2.34.1



