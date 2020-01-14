Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84213A690
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgANKMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbgANKMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF29024677;
        Tue, 14 Jan 2020 10:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996735;
        bh=UoeNj3LierfqBK3dFQablLeSko3NlsPKQVgd4DF+MxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa0wulJajRP2mhVKvGnnyKvwJEmJxiEbVmRYCApIBCHjCt6/4EDSw0+iHts/PlyuK
         ckSZrNfOcr3DqVRG4G+ZG4yWXaZiTp2vBKZdRJdHAlGRITwRYftG+SOB16wWA0IE9T
         e6jrNt4r/FLq9Ve2h9oddii9vIAoV0j0rLLSyodc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.9 05/31] tcp: minimize false-positives on TCP/GRO check
Date:   Tue, 14 Jan 2020 11:01:57 +0100
Message-Id: <20200114094340.570688818@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

commit 0b9aefea860063bb39e36bd7fe6c7087fed0ba87 upstream.

Markus Trippelsdorf reported that after commit dcb17d22e1c2 ("tcp: warn
on bogus MSS and try to amend it") the kernel started logging the
warning for a NIC driver that doesn't even support GRO.

It was diagnosed that it was possibly caused on connections that were
using TCP Timestamps but some packets lacked the Timestamps option. As
we reduce rcv_mss when timestamps are used, the lack of them would cause
the packets to be bigger than expected, although this is a valid case.

As this warning is more as a hint, getting a clean-cut on the
threshold is probably not worth the execution time spent on it. This
patch thus alleviates the false-positives with 2 quick checks: by
accounting for the entire TCP option space and also checking against the
interface MTU if it's available.

These changes, specially the MTU one, might mask some real positives,
though if they are really happening, it's possible that sooner or later
it will be triggered anyway.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_input.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -129,7 +129,8 @@ int sysctl_tcp_invalid_ratelimit __read_
 #define REXMIT_LOST	1 /* retransmit packets marked lost */
 #define REXMIT_NEW	2 /* FRTO-style transmit of unsent/new packets */
 
-static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb)
+static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
+			     unsigned int len)
 {
 	static bool __once __read_mostly;
 
@@ -140,8 +141,9 @@ static void tcp_gro_dev_warn(struct sock
 
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
-		pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
-			dev ? dev->name : "Unknown driver");
+		if (!dev || len >= dev->mtu)
+			pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
+				dev ? dev->name : "Unknown driver");
 		rcu_read_unlock();
 	}
 }
@@ -164,8 +166,10 @@ static void tcp_measure_rcv_mss(struct s
 	if (len >= icsk->icsk_ack.rcv_mss) {
 		icsk->icsk_ack.rcv_mss = min_t(unsigned int, len,
 					       tcp_sk(sk)->advmss);
-		if (unlikely(icsk->icsk_ack.rcv_mss != len))
-			tcp_gro_dev_warn(sk, skb);
+		/* Account for possibly-removed options */
+		if (unlikely(len > icsk->icsk_ack.rcv_mss +
+				   MAX_TCP_OPTION_SPACE))
+			tcp_gro_dev_warn(sk, skb, len);
 	} else {
 		/* Otherwise, we make more careful check taking into account,
 		 * that SACKs block is variable.


