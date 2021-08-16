Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647813ED4B2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhHPNFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236991AbhHPNEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2489632AA;
        Mon, 16 Aug 2021 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119062;
        bh=Rxqm1YAwNPqM3lUQa+7ZC894ANw1ofrWEJYCyh8AmFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEKBYSjxtZmq8YZzBfZ3uOgBa5AMEU7j56zs8ug9fyTJpipvIca9aBqBEwkswkCrn
         LoYgYnKwgRSwFrmzq921wDZ2/3mxDymmmsM6LSi/GRGzP2k//Mp+r4Gl1TD8m+EJHu
         GOsrILnmtq+iGKm5JnPLlb/WJkFNBCyChlClEWXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/62] tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets
Date:   Mon, 16 Aug 2021 15:02:08 +0200
Message-Id: <20210816125429.427530518@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 6de035fec045f8ae5ee5f3a02373a18b939e91fb ]

Currently if BBR congestion control is initialized after more than 2B
packets have been delivered, depending on the phase of the
tp->delivered counter the tracking of BBR round trips can get stuck.

The bug arises because if tp->delivered is between 2^31 and 2^32 at
the time the BBR congestion control module is initialized, then the
initialization of bbr->next_rtt_delivered to 0 will cause the logic to
believe that the end of the round trip is still billions of packets in
the future. More specifically, the following check will fail
repeatedly:

  !before(rs->prior_delivered, bbr->next_rtt_delivered)

and thus the connection will take up to 2B packets delivered before
that check will pass and the connection will set:

  bbr->round_start = 1;

This could cause many mechanisms in BBR to fail to trigger, for
example bbr_check_full_bw_reached() would likely never exit STARTUP.

This bug is 5 years old and has not been observed, and as a practical
matter this would likely rarely trigger, since it would require
transferring at least 2B packets, or likely more than 3 terabytes of
data, before switching congestion control algorithms to BBR.

This patch is a stable candidate for kernels as far back as v4.9,
when tcp_bbr.c was added.

Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Kevin Yang <yyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210811024056.235161-1-ncardwell@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6ea3dc2e4219..6274462b86b4 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1041,7 +1041,7 @@ static void bbr_init(struct sock *sk)
 	bbr->prior_cwnd = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	bbr->rtt_cnt = 0;
-	bbr->next_rtt_delivered = 0;
+	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
 	bbr->packet_conservation = 0;
 
-- 
2.30.2



