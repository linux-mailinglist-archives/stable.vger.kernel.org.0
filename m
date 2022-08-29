Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0483B5A4872
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiH2LKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiH2LJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA96555;
        Mon, 29 Aug 2022 04:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20511611EF;
        Mon, 29 Aug 2022 11:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25415C433C1;
        Mon, 29 Aug 2022 11:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771214;
        bh=W0WKaihdrChHJR53YjvyX0zHr0mSLFAyR2lY2p2rf28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sO1btMlBwDY4M/W1JnmXF9Rj4QN8bHIzQNBjpWQNRHX/ByOmQd4FjAKDeptA4Z7+h
         jeg0eB0/AstL8t6q15wr53jcTlH/EeS5MSTVycTUKG408otq13TRCduilpwO1LAHP/
         TwOAZaaUxukWuWuO0opvS76h4T9jGyCGTpPEibB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/136] tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
Date:   Mon, 29 Aug 2022 12:59:07 +0200
Message-Id: <20220829105807.931727133@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 04d8825c30b718781197c8f07b1915a11bfb8685 ]

the tcp_skb_entail() helper is actually skb_entail(), renamed
to provide proper scope.

    The two helper will be used by the next patch.

RFC -> v1:
 - rename skb_entail to tcp_skb_entail (Eric)

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 2 ++
 net/ipv4/tcp.c    | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 76b0d7f2b967f..d3646645cb9ec 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -571,6 +571,8 @@ __u32 cookie_v6_init_sequence(const struct sk_buff *skb, __u16 *mss);
 #endif
 /* tcp_output.c */
 
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb);
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb);
 void __tcp_push_pending_frames(struct sock *sk, unsigned int cur_mss,
 			       int nonagle);
 int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2097eeaf30a67..52f51717f02f3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -644,7 +644,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(tcp_ioctl);
 
-static inline void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_PSH;
 	tp->pushed_seq = tp->write_seq;
@@ -655,7 +655,7 @@ static inline bool forced_push(const struct tcp_sock *tp)
 	return after(tp->write_seq, tp->pushed_seq + (tp->max_window >> 1));
 }
 
-static void skb_entail(struct sock *sk, struct sk_buff *skb)
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
@@ -982,7 +982,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 #ifdef CONFIG_TLS_DEVICE
 		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
 #endif
-		skb_entail(sk, skb);
+		tcp_skb_entail(sk, skb);
 		copy = size_goal;
 	}
 
@@ -1312,7 +1312,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
 
-			skb_entail(sk, skb);
+			tcp_skb_entail(sk, skb);
 			copy = size_goal;
 
 			/* All packets are restored as if they have
-- 
2.35.1



