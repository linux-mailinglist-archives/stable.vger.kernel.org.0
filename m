Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8064B594052
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbiHOU4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346917AbiHOU4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555A48E82;
        Mon, 15 Aug 2022 12:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C35B81109;
        Mon, 15 Aug 2022 19:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6B4C433D7;
        Mon, 15 Aug 2022 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590692;
        bh=rG5TxObyUf1LId3LHy8gMxxLmgk02vTuSArN1/uPQjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fCMLLoQL95FIwCZWLkLHmvjxeD1SLbDvpOmle2lt7JttbhF3yGuUJYnrcN8jWlzP
         widQzy8sM9hRuzKAyI4N3tLaqdB0064xv+Ad8S74zmCBFJaH7GJ2eWJ++2A+jdw2Fr
         z60ZOhVAyNDgi/RswppCVrui+JieidCTLk+PMlRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0341/1095] tcp: fix possible freeze in tx path under memory pressure
Date:   Mon, 15 Aug 2022 19:55:40 +0200
Message-Id: <20220815180443.908916463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 849b425cd091e1804af964b771761cfbefbafb43 ]

Blamed commit only dealt with applications issuing small writes.

Issue here is that we allow to force memory schedule for the sk_buff
allocation, but we have no guarantee that sendmsg() is able to
copy some payload in it.

In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.

For example, if we consider tcp_wmem[0] = 4096 (default on x86),
and initial skb->truesize being 1280, tcp_sendmsg() is able to
copy up to 2816 bytes under memory pressure.

Before this patch a sendmsg() sending more than 2816 bytes
would either block forever (if persistent memory pressure),
or return -EAGAIN.

For bigger MTU networks, it is advised to increase tcp_wmem[0]
to avoid sending too small packets.

v2: deal with zero copy paths.

Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 91735d631a28..51116166e3d2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -953,6 +953,23 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static int tcp_wmem_schedule(struct sock *sk, int copy)
+{
+	int left;
+
+	if (likely(sk_wmem_schedule(sk, copy)))
+		return copy;
+
+	/* We could be in trouble if we have nothing queued.
+	 * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
+	 * to guarantee some progress.
+	 */
+	left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
+	if (left > 0)
+		sk_forced_mem_schedule(sk, min(left, copy));
+	return min(copy, sk->sk_forward_alloc);
+}
+
 static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 				      struct page *page, int offset, size_t *size)
 {
@@ -988,7 +1005,11 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
-	if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
+	if (tcp_downgrade_zcopy_pure(sk, skb))
+		return NULL;
+
+	copy = tcp_wmem_schedule(sk, copy);
+	if (!copy)
 		return NULL;
 
 	if (can_coalesce) {
@@ -1337,8 +1358,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			if (tcp_downgrade_zcopy_pure(sk, skb) ||
-			    !sk_wmem_schedule(sk, copy))
+			if (tcp_downgrade_zcopy_pure(sk, skb))
+				goto wait_for_space;
+
+			copy = tcp_wmem_schedule(sk, copy);
+			if (!copy)
 				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
@@ -1365,7 +1389,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
 
 			if (!skb_zcopy_pure(skb)) {
-				if (!sk_wmem_schedule(sk, copy))
+				copy = tcp_wmem_schedule(sk, copy);
+				if (!copy)
 					goto wait_for_space;
 			}
 
-- 
2.35.1



