Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E3E420D14
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhJDNLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235797AbhJDNJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8BA61B4A;
        Mon,  4 Oct 2021 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352612;
        bh=Y2LPHQeOAlRpPu6UrmPSDGtATkA8zLCHugewhlxOzFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3e7sd540EvLbd054fLvxy9jtakDugrqnouiIH51yw9KsxZY4kGKCSIWKjqNpqkwR
         SRlcvwSGNKum1XF0zJXgyI5yl73R6zPe0QHUQTe5MnjdV1J4IKPCVMLOuLFYX6jdjk
         nFzF5EilkwoDkY8Ikd6P4L5oPHZUs5UefitYi0TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiumiao Zhang <zhangqiumiao1@huawei.com>
Subject: [PATCH 4.19 52/95] tcp: create a helper to model exponential backoff
Date:   Mon,  4 Oct 2021 14:52:22 +0200
Message-Id: <20211004125035.273941481@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

commit 01a523b071618abbc634d1958229fe3bd2dfa5fa upstream.

Create a helper to model TCP exponential backoff for the next patch.
This is pure refactor w no behavior change.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -160,7 +160,20 @@ static void tcp_mtu_probing(struct inet_
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 }
 
+static unsigned int tcp_model_timeout(struct sock *sk,
+				      unsigned int boundary,
+				      unsigned int rto_base)
+{
+	unsigned int linear_backoff_thresh, timeout;
 
+	linear_backoff_thresh = ilog2(TCP_RTO_MAX / rto_base);
+	if (boundary <= linear_backoff_thresh)
+		timeout = ((2 << boundary) - 1) * rto_base;
+	else
+		timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
+			(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
+	return jiffies_to_msecs(timeout);
+}
 /**
  *  retransmits_timed_out() - returns true if this connection has timed out
  *  @sk:       The current socket
@@ -178,23 +191,15 @@ static bool retransmits_timed_out(struct
 				  unsigned int boundary,
 				  unsigned int timeout)
 {
-	const unsigned int rto_base = TCP_RTO_MIN;
-	unsigned int linear_backoff_thresh, start_ts;
+	unsigned int start_ts;
 
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0)) {
-		linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
+	if (likely(timeout == 0))
+		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
 
-		if (boundary <= linear_backoff_thresh)
-			timeout = ((2 << boundary) - 1) * rto_base;
-		else
-			timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
-				(boundary - linear_backoff_thresh) * TCP_RTO_MAX;
-		timeout = jiffies_to_msecs(timeout);
-	}
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }
 


