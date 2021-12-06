Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BEE469A16
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345820AbhLFPF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345915AbhLFPFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E631C0613F8;
        Mon,  6 Dec 2021 07:01:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DBD2612C0;
        Mon,  6 Dec 2021 15:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277AAC341C1;
        Mon,  6 Dec 2021 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802901;
        bh=FecmpWrbuRhJqnJ2bCqZsSN8VoQNom1f020u9gffGQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1DbYJAGjRAWmwI1AZaz/garwrJywTreUgwRc5Air8r4LxIQRcftoHV8gGudtLMa/
         RXuvl3S7vgt0cobX6l+A34VlBSSLiSn5TLDEC4+nY1MvFOXrmOEBq9rVsjNYO9Cs2r
         XbALLJcfhRpU8cP4t0R4o1ZCXvGP73hZYKVzYubc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/62] tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows
Date:   Mon,  6 Dec 2021 15:56:04 +0100
Message-Id: <20211206145549.909079212@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4e1fddc98d2585ddd4792b5e44433dcee7ece001 ]

While testing BIG TCP patch series, I was expecting that TCP_RR workloads
with 80KB requests/answers would send one 80KB TSO packet,
then being received as a single GRO packet.

It turns out this was not happening, and the root cause was that
cubic Hystart ACK train was triggering after a few (2 or 3) rounds of RPC.

Hystart was wrongly setting CWND/SSTHRESH to 30, while my RPC
needed a budget of ~20 segments.

Ideally these TCP_RR flows should not exit slow start.

Cubic Hystart should reset itself at each round, instead of assuming
every TCP flow is a bulk one.

Note that even after this patch, Hystart can still trigger, depending
on scheduling artifacts, but at a higher CWND/SSTHRESH threshold,
keeping optimal TSO packet sizes.

Tested:

ip link set dev eth0 gro_ipv6_max_size 131072 gso_ipv6_max_size 131072
nstat -n; netperf -H ... -t TCP_RR  -l 5  -- -r 80000,80000 -K cubic; nstat|egrep "Ip6InReceives|Hystart|Ip6OutRequests"

Before:

   8605
Ip6InReceives                   87541              0.0
Ip6OutRequests                  129496             0.0
TcpExtTCPHystartTrainDetect     1                  0.0
TcpExtTCPHystartTrainCwnd       30                 0.0

After:

  8760
Ip6InReceives                   88514              0.0
Ip6OutRequests                  87975              0.0

Fixes: ae27e98a5152 ("[TCP] CUBIC v2.3")
Co-developed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Link: https://lore.kernel.org/r/20211123202535.1843771-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cubic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 00397c6add202..d710c519a0357 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -342,8 +342,6 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		return;
 
 	if (tcp_in_slow_start(tp)) {
-		if (hystart && after(ack, ca->end_seq))
-			bictcp_hystart_reset(sk);
 		acked = tcp_slow_start(tp, acked);
 		if (!acked)
 			return;
@@ -394,6 +392,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 	if (ca->found & hystart_detect)
 		return;
 
+	if (after(tp->snd_una, ca->end_seq))
+		bictcp_hystart_reset(sk);
+
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock();
 
-- 
2.33.0



