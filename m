Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF292408D9
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHJPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbgHJPZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505A7208A9;
        Mon, 10 Aug 2020 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073151;
        bh=ktl3ZDLynTSS4IXTv9zGMujR6H6biXQbYY16iEU1EFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaVP0FrYM8hsE3jdZeh1mAdyO0LtH2sVk/xSXCyF/4cPy9cOGEvx9NCJBvDFj2+fs
         Kvo8UduqyZkupCn0VttG61pdXAgtDKctSuVA3LpFLnzkkGqVAZQgf+niuLu0Pp2REW
         8vPeh/TAGthjMdc3sEGEDrI50jEb7Db+sbcOrhrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianfeng Wang <jfwang@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Kevin Yang <yyd@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 75/79] tcp: apply a floor of 1 for RTT samples from TCP timestamps
Date:   Mon, 10 Aug 2020 17:21:34 +0200
Message-Id: <20200810151815.920614101@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianfeng Wang <jfwang@google.com>

[ Upstream commit 730e700e2c19d87e578ff0e7d8cb1d4a02b036d2 ]

For retransmitted packets, TCP needs to resort to using TCP timestamps
for computing RTT samples. In the common case where the data and ACK
fall in the same 1-millisecond interval, TCP senders with millisecond-
granularity TCP timestamps compute a ca_rtt_us of 0. This ca_rtt_us
of 0 propagates to rs->rtt_us.

This value of 0 can cause performance problems for congestion control
modules. For example, in BBR, the zero min_rtt sample can bring the
min_rtt and BDP estimate down to 0, reduce snd_cwnd and result in a
low throughput. It would be hard to mitigate this with filtering in
the congestion control module, because the proper floor to apply would
depend on the method of RTT sampling (using timestamp options or
internally-saved transmission timestamps).

This fix applies a floor of 1 for the RTT sample delta from TCP
timestamps, so that seq_rtt_us, ca_rtt_us, and rs->rtt_us will be at
least 1 * (USEC_PER_SEC / TCP_TS_HZ).

Note that the receiver RTT computation in tcp_rcv_rtt_measure() and
min_rtt computation in tcp_update_rtt_min() both already apply a floor
of 1 timestamp tick, so this commit makes the code more consistent in
avoiding this edge case of a value of 0.

Signed-off-by: Jianfeng Wang <jfwang@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2945,6 +2945,8 @@ static bool tcp_ack_update_rtt(struct so
 		u32 delta = tcp_time_stamp(tp) - tp->rx_opt.rcv_tsecr;
 
 		if (likely(delta < INT_MAX / (USEC_PER_SEC / TCP_TS_HZ))) {
+			if (!delta)
+				delta = 1;
 			seq_rtt_us = delta * (USEC_PER_SEC / TCP_TS_HZ);
 			ca_rtt_us = seq_rtt_us;
 		}


