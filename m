Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09274593F9D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbiHOVKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348003AbiHOVHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B378A3C167;
        Mon, 15 Aug 2022 12:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FD4260F68;
        Mon, 15 Aug 2022 19:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCCC433C1;
        Mon, 15 Aug 2022 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591055;
        bh=Oc76SXNrcZOr5dQFk+mWwofFizMrLxKgl+KdoZ72n10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4SlKUwMm5cWZaT5S4L+Trugsk3h3KfzffIwiHcbronnvgejMuYfDCvPck2+VlVnW
         mV71yCb+VtN2ZAfDUpBu85Ed81Au4kpE8t+ajjFTxVxWILvZhMoQhCh64sRuAvfnEJ
         hcH10ZLgcxUssf1yv3X6clXgvpY8/gyj8O8Gs1Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Li <liyonglong@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0457/1095] tcp: make retransmitted SKB fit into the send window
Date:   Mon, 15 Aug 2022 19:57:36 +0200
Message-Id: <20220815180448.512718191@linuxfoundation.org>
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

From: Yonglong Li <liyonglong@chinatelecom.cn>

[ Upstream commit 536a6c8e05f95e3d1118c40ae8b3022ee2d05d52 ]

current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
If receiver has shrunk his window, and skb is out of new window,  it
should retransmit a smaller portion of the payload.

test packetdrill script:
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0

   +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
   +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
 +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
   +0 > . 1:1(0) ack 1

   +0 write(3, ..., 10000) = 10000

   +0 > . 1:2001(2000) ack 1 win 65535
   +0 > . 2001:4001(2000) ack 1 win 65535
   +0 > . 4001:6001(2000) ack 1 win 65535

 +.05 < . 1:1(0) ack 4001 win 1001

and tcpdump show:
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000

when cient retract window to 1001, send window is [4001,5002],
but TLP send 5001-6001 packet which is out of send window.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a7f0a1f0c2a3..e90b99fa79bf 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3140,7 +3140,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int cur_mss;
 	int diff, len, err;
-
+	int avail_wnd;
 
 	/* Inconclusive MTU probe */
 	if (icsk->icsk_mtup.probe_size)
@@ -3162,17 +3162,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
 	cur_mss = tcp_current_mss(sk);
+	avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
 
 	/* If receiver has shrunk his window, and skb is out of
 	 * new window, do not retransmit it. The exception is the
 	 * case, when window is shrunk to zero. In this case
-	 * our retransmit serves as a zero window probe.
+	 * our retransmit of one segment serves as a zero window probe.
 	 */
-	if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
-	    TCP_SKB_CB(skb)->seq != tp->snd_una)
-		return -EAGAIN;
+	if (avail_wnd <= 0) {
+		if (TCP_SKB_CB(skb)->seq != tp->snd_una)
+			return -EAGAIN;
+		avail_wnd = cur_mss;
+	}
 
 	len = cur_mss * segs;
+	if (len > avail_wnd) {
+		len = rounddown(avail_wnd, cur_mss);
+		if (!len)
+			len = avail_wnd;
+	}
 	if (skb->len > len) {
 		if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
 				 cur_mss, GFP_ATOMIC))
@@ -3186,8 +3194,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		diff -= tcp_skb_pcount(skb);
 		if (diff)
 			tcp_adjust_pcount(sk, skb, diff);
-		if (skb->len < cur_mss)
-			tcp_retrans_try_collapse(sk, skb, cur_mss);
+		avail_wnd = min_t(int, avail_wnd, cur_mss);
+		if (skb->len < avail_wnd)
+			tcp_retrans_try_collapse(sk, skb, avail_wnd);
 	}
 
 	/* RFC3168, section 6.1.1.1. ECN fallback */
-- 
2.35.1



