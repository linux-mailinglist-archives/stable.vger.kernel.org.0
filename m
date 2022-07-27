Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D07582E6F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbiG0RMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241474AbiG0RMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E6351420;
        Wed, 27 Jul 2022 09:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20ED2614A3;
        Wed, 27 Jul 2022 16:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31161C433C1;
        Wed, 27 Jul 2022 16:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940107;
        bh=UJGErmSItXRIZuDAwHn2eChFK9M7zB+QgDchWKCYkyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGRGjW55zpe+Nv4aVCtk7nBRZoMQ6o1NfzcYyEVn9EJN3xZqePvDaM05Or5WI+bKh
         1+4PkFr8Mx5lD281n9nwSxfvVWqbWj8xvWrHlpXnSbh2aaplm496JG95cUHHCC7DjD
         RNyw7LjchhRBGUlpBmyWB3xr2jZuH6A5ZNdTRIMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/201] net: skb: use kfree_skb_reason() in __udp4_lib_rcv()
Date:   Wed, 27 Jul 2022 18:09:40 +0200
Message-Id: <20220727161030.093229958@linuxfoundation.org>
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

[ Upstream commit 1c7fab70df085d866a3765955f397ca2b4025b15 ]

Replace kfree_skb() with kfree_skb_reason() in __udp4_lib_rcv.
New drop reason 'SKB_DROP_REASON_UDP_CSUM' is added for udp csum
error.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     |  1 +
 include/trace/events/skb.h |  1 +
 net/ipv4/udp.c             | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5305af6cc86f..66aac2006868 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -316,6 +316,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_TCP_FILTER,
+	SKB_DROP_REASON_UDP_CSUM,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index faa7d068a7bc..3e042ca2cedb 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -15,6 +15,7 @@
 	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
+	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 835b9d6e4e68..4ad4daa16cce 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2411,6 +2411,9 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
 	bool refcounted;
+	int drop_reason;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	/*
 	 *  Validate the packet.
@@ -2466,6 +2469,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
@@ -2473,10 +2477,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 short_packet:
+	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source),
@@ -2489,6 +2494,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * RFC1122: OK.  Discards the bad packet silently (as far as
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
@@ -2496,7 +2502,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 }
 
-- 
2.35.1



