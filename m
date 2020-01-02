Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC4212EC4C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgABWRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbgABWRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D60B22314;
        Thu,  2 Jan 2020 22:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003425;
        bh=U5OhwoZMXsTMWEiyi7YTEg3+XjubgFHhT59/nUqI7cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=linFcp4POg49N14wNpQVjQpqr0r9S5VfB515oMRJuAAyjKPa31ZEXW+bRsOSD3FNV
         UT/GuOkrOoC/27btqfiKi1wgKXHtswANz6csO/hPOL3TM81L7PdcO/Q3qNKwn9qzKa
         H+Y+l0OoUlG3uH/Mx1diws/Y+5d08MvMRx8T+D7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 156/191] tcp: Fix highest_sack and highest_sack_seq
Date:   Thu,  2 Jan 2020 23:07:18 +0100
Message-Id: <20200102215846.141998616@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit 853697504de043ff0bfd815bd3a64de1dce73dc7 ]

>From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
setting tp->highest_sack to the head of the send queue was removed.
Of course the logic is error prone, but it is logical. Before we
remove the pointer to the highest sack skb and use the seq instead,
we need to set tp->highest_sack to NULL when there is no skb after
the last sack, and then replace NULL with the real skb when new skb
inserted into the rtx queue, because the NULL means the highest sack
seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
the next ACK with sack option will increase tp->reordering unexpectedly.

This patch sets tp->highest_sack to the tail of the rtx queue if
it's NULL and new data is sent. The patch keeps the rule that the
highest_sack can only be maintained by sack processing, except for
this only case.

Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(stru
 	__skb_unlink(skb, &sk->sk_write_queue);
 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
 
+	if (tp->highest_sack == NULL)
+		tp->highest_sack = skb;
+
 	tp->packets_out += tcp_skb_pcount(skb);
 	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
 		tcp_rearm_rto(sk);


