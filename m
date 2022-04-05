Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA5B4F3A71
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381412AbiDELpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354643AbiDEKO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670476C1D4;
        Tue,  5 Apr 2022 03:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0449961676;
        Tue,  5 Apr 2022 10:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1498EC385A2;
        Tue,  5 Apr 2022 10:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152924;
        bh=vSw95j1GAoKc3GU1j3gp9FANPdfDZ7j9JLEz9y4X0q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6L1uVb/K2qLFs/TtKaHs/JBowQPlt23PMjdub2sxGeno/uSbda4w91iOjzqnBlFo
         /4Cq16NOIsWgqcSCde4pneZn+nhujae4/V2tJBbrz+hZGX6d1WCMaVbPIilhAuUfT/
         aDu656GS0gebmihCoG9dcvBA7ZtGIL7YHFL8mRp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lina Wang <lina.wang@mediatek.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/599] xfrm: fix tunnel model fragmentation behavior
Date:   Tue,  5 Apr 2022 09:25:01 +0200
Message-Id: <20220405070259.031976190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Lina Wang <lina.wang@mediatek.com>

[ Upstream commit 4ff2980b6bd2aa6b4ded3ce3b7c0ccfab29980af ]

in tunnel mode, if outer interface(ipv4) is less, it is easily to let
inner IPV6 mtu be less than 1280. If so, a Packet Too Big ICMPV6 message
is received. When send again, packets are fragmentized with 1280, they
are still rejected with ICMPV6(Packet Too Big) by xfrmi_xmit2().

According to RFC4213 Section3.2.2:
if (IPv4 path MTU - 20) is less than 1280
	if packet is larger than 1280 bytes
		Send ICMPv6 "packet too big" with MTU=1280
                Drop packet
        else
		Encapsulate but do not set the Don't Fragment
                flag in the IPv4 header.  The resulting IPv4
                packet might be fragmented by the IPv4 layer
                on the encapsulator or by some router along
                the IPv4 path.
	endif
else
	if packet is larger than (IPv4 path MTU - 20)
        	Send ICMPv6 "packet too big" with
                MTU = (IPv4 path MTU - 20).
                Drop packet.
        else
                Encapsulate and set the Don't Fragment flag
                in the IPv4 header.
        endif
endif
Packets should be fragmentized with ipv4 outer interface, so change it.

After it is fragemtized with ipv4, there will be double fragmenation.
No.48 & No.51 are ipv6 fragment packets, No.48 is double fragmentized,
then tunneled with IPv4(No.49& No.50), which obey spec. And received peer
cannot decrypt it rightly.

48              2002::10        2002::11 1296(length) IPv6 fragment (off=0 more=y ident=0xa20da5bc nxt=50)
49   0x0000 (0) 2002::10        2002::11 1304         IPv6 fragment (off=0 more=y ident=0x7448042c nxt=44)
50   0x0000 (0) 2002::10        2002::11 200          ESP (SPI=0x00035000)
51              2002::10        2002::11 180          Echo (ping) request
52   0x56dc     2002::10        2002::11 248          IPv6 fragment (off=1232 more=n ident=0xa20da5bc nxt=50)

xfrm6_noneed_fragment has fixed above issues. Finally, it acted like below:
1   0x6206 192.168.1.138   192.168.1.1 1316 Fragmented IP protocol (proto=Encap Security Payload 50, off=0, ID=6206) [Reassembled in #2]
2   0x6206 2002::10        2002::11    88   IPv6 fragment (off=0 more=y ident=0x1f440778 nxt=50)
3   0x0000 2002::10        2002::11    248  ICMPv6    Echo (ping) request

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_output.c   | 16 ++++++++++++++++
 net/xfrm/xfrm_interface.c |  5 ++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 6abb45a67199..ee349c243878 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -52,6 +52,19 @@ static int __xfrm6_output_finish(struct net *net, struct sock *sk, struct sk_buf
 	return xfrm_output(sk, skb);
 }
 
+static int xfrm6_noneed_fragment(struct sk_buff *skb)
+{
+	struct frag_hdr *fh;
+	u8 prevhdr = ipv6_hdr(skb)->nexthdr;
+
+	if (prevhdr != NEXTHDR_FRAGMENT)
+		return 0;
+	fh = (struct frag_hdr *)(skb->data + sizeof(struct ipv6hdr));
+	if (fh->nexthdr == NEXTHDR_ESP || fh->nexthdr == NEXTHDR_AUTH)
+		return 1;
+	return 0;
+}
+
 static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -80,6 +93,9 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		xfrm6_local_rxpmtu(skb, mtu);
 		kfree_skb(skb);
 		return -EMSGSIZE;
+	} else if (toobig && xfrm6_noneed_fragment(skb)) {
+		skb->ignore_df = 1;
+		goto skip_frag;
 	} else if (!skb->ignore_df && toobig && skb->sk) {
 		xfrm_local_error(skb, mtu);
 		kfree_skb(skb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 4420c8fd318a..da518b4ca84c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -303,7 +303,10 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			if (skb->len > 1280)
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			else
+				goto xmit;
 		} else {
 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
 				goto xmit;
-- 
2.34.1



