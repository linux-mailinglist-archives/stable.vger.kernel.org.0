Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8755056EB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiDRNmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbiDRNlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D502230556;
        Mon, 18 Apr 2022 05:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C031612CF;
        Mon, 18 Apr 2022 12:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36906C385A1;
        Mon, 18 Apr 2022 12:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286762;
        bh=ZznB77Rf8mTsa+HBtYpUVjfeNmJ/y3bHOoA1U9mHq8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph3AP/T2ve9+mPBrX8YtnnUqwezZ7WQaqh+G/Jaq3jO3EinBxHnnQ5NZe+mSziGWf
         dteTUPaF9Th/2CIu7cLFTyzJGSO2nxRLOBWI0NQNRFsYNtrZd7a+gy+2f2cV2DARc3
         /xkNbe9yNV+oUDh3kiWAq54DuSpV/rXOl2ODlPxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 237/284] net: add missing SOF_TIMESTAMPING_OPT_ID support
Date:   Mon, 18 Apr 2022 14:13:38 +0200
Message-Id: <20220418121218.452483717@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f72753391acc..f729ccfe756a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2311,22 +2311,39 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
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
index 2a987a6ea6d7..bda2113a8529 100644
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
index 9c4b2c0dc68a..19a6ec2adc6c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -390,7 +390,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index f0d8b7e9a685..e8926ebfe74c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -659,7 +659,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 92394595920c..b0dd17d1992e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2017,7 +2017,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
@@ -2539,7 +2539,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->dev = dev;
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
-	sock_tx_timestamp(&po->sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
@@ -3002,7 +3002,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (!vnet_hdr.gso_type && (len > dev->mtu + reserve + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
-- 
2.35.1



