Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F15582E2D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbiG0RIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiG0RIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9579271736;
        Wed, 27 Jul 2022 09:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F744601CE;
        Wed, 27 Jul 2022 16:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DED9C433C1;
        Wed, 27 Jul 2022 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940031;
        bh=s4VD1Qty460fbquy3y0AEgSCliLKVLMtsxx+mKAyKt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TT+HmD9JyjIC6fISoHn5tizNK9Je5UoFP6IC4lph7xdabebA8DfClfAH92NdMTRmZ
         bt4L5eAo8q/EiMKxNyzRrsIB2TEmDlD6mEYRWb6/TGJqrcMAJ74UIQQeOsMXFi7DMK
         GivTcypcVRulr6KoinqQueP+tw11FEVAsaIPAsyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/201] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
Date:   Wed, 27 Jul 2022 18:09:45 +0200
Message-Id: <20220727161031.089349214@linuxfoundation.org>
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

[ Upstream commit c1f166d1f7eef212096a98b22f5acf92f9af353d ]

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_finish_core(),
following drop reasons are introduced:

SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 14 ++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 514fb8074f78..cbd719e5329a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -327,6 +327,15 @@ enum skb_drop_reason {
 					 * IP header (see
 					 * IPSTATS_MIB_INHDRERRORS)
 					 */
+	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
+					 * see the document for rp_filter
+					 * in ip-sysctl.rst for more
+					 * information
+					 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
+						  * is multicast, but L3 is
+						  * unicast.
+						  */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index f2b1778485f0..485a1d3034a4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -20,6 +20,9 @@
 	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
 	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
 	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
+	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
+	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
+	   UNICAST_IN_L2_MULTICAST)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 7be18de32e16..d5222c0fa87c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	int (*edemux)(struct sk_buff *skb);
+	int err, drop_reason;
 	struct rtable *rt;
-	int err;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (ip_can_use_hint(skb, iph, hint)) {
 		err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
@@ -396,19 +398,23 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 		 * so-called "hole-196" attack) so do it for both.
 		 */
 		if (in_dev &&
-		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST))
+		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST)) {
+			drop_reason = SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST;
 			goto drop;
+		}
 	}
 
 	return NET_RX_SUCCESS;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return NET_RX_DROP;
 
 drop_error:
-	if (err == -EXDEV)
+	if (err == -EXDEV) {
+		drop_reason = SKB_DROP_REASON_IP_RPFILTER;
 		__NET_INC_STATS(net, LINUX_MIB_IPRPFILTER);
+	}
 	goto drop;
 }
 
-- 
2.35.1



