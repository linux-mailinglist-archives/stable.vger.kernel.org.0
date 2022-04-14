Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C3D50113A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiDNNgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344151AbiDNNal (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5BB22F;
        Thu, 14 Apr 2022 06:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 665DB619DA;
        Thu, 14 Apr 2022 13:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76861C385A1;
        Thu, 14 Apr 2022 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942895;
        bh=ziZhs4w4fOyVTrMqEsZJFqB0xAp5wYEYXJ6zPtEua6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9I51YNynTrykyOamzb6nuEajHc/Hoy4qgjyd9tI9IZfUcZjd+8xmffa+ySweQ8NI
         ZMdDeFXi8N0zOh4am9xka85a8H4SAk4NZxN5vDpuSk0MuO+KtpKkTlXLRSbklRkDz7
         MRm7+m6cDy9Gfban/Y01LerFoH3pV39Lzbx0Kumw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 300/338] net: add missing SOF_TIMESTAMPING_OPT_ID support
Date:   Thu, 14 Apr 2022 15:13:23 +0200
Message-Id: <20220414110847.423397855@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8f932f762e7928d250e21006b00ff9b7718b0a64 ]

SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.

Add skb_setup_tx_timestamp that configures both tx_flags and tskey
for these paths that do not need corking or use bytestream keys.

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h     | 25 +++++++++++++++++++++----
 net/can/raw.c          |  2 +-
 net/ipv4/raw.c         |  2 +-
 net/ipv6/raw.c         |  2 +-
 net/packet/af_packet.c |  6 +++---
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2bf8dcf863f2..7d3a4c2eea95 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2400,22 +2400,39 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
 
 /**
- * sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
+ * _sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
  * @sk:		socket sending this packet
  * @tsflags:	timestamping flags to use
  * @tx_flags:	completed with instructions for time stamping
+ * @tskey:      filled in with next sk_tskey (not for TCP, which uses seqno)
  *
  * Note: callers should take care of initial ``*tx_flags`` value (usually 0)
  */
-static inline void sock_tx_timestamp(const struct sock *sk, __u16 tsflags,
-				     __u8 *tx_flags)
+static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				      __u8 *tx_flags, __u32 *tskey)
 {
-	if (unlikely(tsflags))
+	if (unlikely(tsflags)) {
 		__sock_tx_timestamp(tsflags, tx_flags);
+		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
+		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
+			*tskey = sk->sk_tskey++;
+	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
 }
 
+static inline void sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				     __u8 *tx_flags)
+{
+	_sock_tx_timestamp(sk, tsflags, tx_flags, NULL);
+}
+
+static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
+{
+	_sock_tx_timestamp(skb->sk, tsflags, &skb_shinfo(skb)->tx_flags,
+			   &skb_shinfo(skb)->tskey);
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/can/raw.c b/net/can/raw.c
index d0fb5a57c66d..2a6db8752b61 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -814,7 +814,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err < 0)
 		goto free_skb;
 
-	sock_tx_timestamp(sk, sk->sk_tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sk->sk_tsflags);
 
 	skb->dev = dev;
 	skb->sk  = sk;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 8cae691c3c9f..654f586fc0d7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -391,7 +391,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 98c8f98a7660..ad7bd40b6d53 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -660,7 +660,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d65051959f85..b951f411dded 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1978,7 +1978,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->mark = sk->sk_mark;
 	skb->tstamp = sockc.transmit_time;
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
@@ -2501,7 +2501,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
 	skb->tstamp = sockc->transmit_time;
-	sock_tx_timestamp(&po->sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
@@ -2965,7 +2965,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (!vnet_hdr.gso_type && (len > dev->mtu + reserve + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
-- 
2.35.1



