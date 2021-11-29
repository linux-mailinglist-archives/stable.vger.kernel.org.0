Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA34622A6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhK2VBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhK2U7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 15:59:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCAFC11FA14;
        Mon, 29 Nov 2021 10:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90448B815DB;
        Mon, 29 Nov 2021 18:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5340C53FC7;
        Mon, 29 Nov 2021 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210383;
        bh=lKnBWlzlJHg3J3LFCLsJGw2d3jbRSDn238LUGLcrIa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaGWHjmlKLx3FodQ/1QGsGMBfWBJbg1y/xphSlkVSGlCcdFlstIuhkFY6SraFMUDz
         hC9eW8yMxoexFuIr91sAFyifMhPItEXYGdtFXRU+7NrUqBDEjHfWSFJWtUGmu2ZFbi
         Pzje8FnnheO00ShyDFieBf46QoIjrziDNK6QnqM0=
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
Subject: [PATCH 5.4 67/92] tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows
Date:   Mon, 29 Nov 2021 19:18:36 +0100
Message-Id: <20211129181709.649602267@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index ee6c38a73325d..44be7a5a13911 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -341,8 +341,6 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		return;
 
 	if (tcp_in_slow_start(tp)) {
-		if (hystart && after(ack, ca->end_seq))
-			bictcp_hystart_reset(sk);
 		acked = tcp_slow_start(tp, acked);
 		if (!acked)
 			return;
@@ -384,6 +382,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 	if (ca->found & hystart_detect)
 		return;
 
+	if (after(tp->snd_una, ca->end_seq))
+		bictcp_hystart_reset(sk);
+
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock();
 
-- 
2.33.0



