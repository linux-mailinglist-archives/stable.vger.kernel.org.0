Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5C4582E6D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbiG0RMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiG0RME (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE75D74E20;
        Wed, 27 Jul 2022 09:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421C5B821D6;
        Wed, 27 Jul 2022 16:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44949C433C1;
        Wed, 27 Jul 2022 16:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940104;
        bh=e5SyryGEC220qyDAHi0iMFQrru4rfLU/teuOzDcSVNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG4rJCg0VVxmA0tX9xHOI6200Zf7kDksiPzg8jW3H2RFqGC9hmGGGACbhpi42zxJx
         +hMT5KMn5KNPVTMoKmyRGvaYBB481mD+3J7lhwsx3riuD+uuiupHNxKHgLWml7wYlF
         Ytnnf03DHbB6Jbv3g5TKIU8ryFO9YGFNivCQUTt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/201] net: skb: use kfree_skb_reason() in tcp_v4_rcv()
Date:   Wed, 27 Jul 2022 18:09:39 +0200
Message-Id: <20220727161030.046443697@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 85125597419aec3aa7b8f3b8713e415f997796f2 ]

Replace kfree_skb() with kfree_skb_reason() in tcp_v4_rcv(). Following
drop reasons are added:

SKB_DROP_REASON_NO_SOCKET
SKB_DROP_REASON_PKT_TOO_SMALL
SKB_DROP_REASON_TCP_CSUM
SKB_DROP_REASON_TCP_FILTER

After this patch, 'kfree_skb' event will print message like this:

$           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
$              | |         |   |||||     |         |
          <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCKET

The reason of skb drop is printed too.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/tcp_ipv4.c        | 14 +++++++++++---
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 029bc228bcf9..5305af6cc86f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -312,6 +312,10 @@ struct sk_buff;
  */
 enum skb_drop_reason {
 	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_NO_SOCKET,
+	SKB_DROP_REASON_PKT_TOO_SMALL,
+	SKB_DROP_REASON_TCP_CSUM,
+	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 294c61bbe44b..faa7d068a7bc 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -11,6 +11,10 @@
 
 #define TRACE_SKB_DROP_REASON					\
 	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
+	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
+	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
+	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b9a9f288bfa6..d901858aa440 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1976,8 +1976,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	int drop_reason;
 	int ret;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1989,8 +1991,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr) / 4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff * 4))
 		goto discard_it;
 
@@ -2093,8 +2097,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	nf_reset_ct(skb);
 
-	if (tcp_filter(sk, skb))
+	if (tcp_filter(sk, skb)) {
+		drop_reason = SKB_DROP_REASON_TCP_FILTER;
 		goto discard_and_relse;
+	}
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
@@ -2131,6 +2137,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2138,6 +2145,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2148,7 +2156,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
-- 
2.35.1



