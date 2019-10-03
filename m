Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA5CA932
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391594AbfJCQiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbfJCQiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B607E20830;
        Thu,  3 Oct 2019 16:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120729;
        bh=QewyYujb4UdrSEcgi+mYAT8PK5n643YgE674FQS0/Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4UXgk48AUCCwVo50F19OugBMKozRgNftvLA1rHnaXGDoL3egYDphKFwFAXsOa92p
         r1s9LERPFv64yVXnlSktzMMDsdCF7hmHDWaddldwPMSFCqnkWRUTPVVZP2IyXQ7KG9
         Q6SvTjxvmXFYgEC6GVtJyjx2wp14/ykVdYoT8LfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kevin(Yudong) Yang" <yyd@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 017/344] tcp_bbr: fix quantization code to not raise cwnd if not probing bandwidth
Date:   Thu,  3 Oct 2019 17:49:42 +0200
Message-Id: <20191003154541.776910558@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kevin(Yudong) Yang" <yyd@google.com>

[ Upstream commit 6b3656a60f2067738d1a423328199720806f0c44 ]

There was a bug in the previous logic that attempted to ensure gain cycling
gets inflight above BDP even for small BDPs. This code correctly raised and
lowered target inflight values during the gain cycle. And this code
correctly ensured that cwnd was raised when probing bandwidth. However, it
did not correspondingly ensure that cwnd was *not* raised in this way when
*not* probing for bandwidth. The result was that small-BDP flows that were
always cwnd-bound could go for many cycles with a fixed cwnd, and not probe
or yield bandwidth at all. This meant that multiple small-BDP flows could
fail to converge in their bandwidth allocations.

Fixes: 3c346b233c68 ("tcp_bbr: fix bw probing to raise in-flight data for very small BDPs")
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bbr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -386,7 +386,7 @@ static u32 bbr_bdp(struct sock *sk, u32
  * which allows 2 outstanding 2-packet sequences, to try to keep pipe
  * full even with ACK-every-other-packet delayed ACKs.
  */
-static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd, int gain)
+static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd)
 {
 	struct bbr *bbr = inet_csk_ca(sk);
 
@@ -397,7 +397,7 @@ static u32 bbr_quantization_budget(struc
 	cwnd = (cwnd + 1) & ~1U;
 
 	/* Ensure gain cycling gets inflight above BDP even for small BDPs. */
-	if (bbr->mode == BBR_PROBE_BW && gain > BBR_UNIT)
+	if (bbr->mode == BBR_PROBE_BW && bbr->cycle_idx == 0)
 		cwnd += 2;
 
 	return cwnd;
@@ -409,7 +409,7 @@ static u32 bbr_inflight(struct sock *sk,
 	u32 inflight;
 
 	inflight = bbr_bdp(sk, bw, gain);
-	inflight = bbr_quantization_budget(sk, inflight, gain);
+	inflight = bbr_quantization_budget(sk, inflight);
 
 	return inflight;
 }
@@ -529,7 +529,7 @@ static void bbr_set_cwnd(struct sock *sk
 	 * due to aggregation (of data and/or ACKs) visible in the ACK stream.
 	 */
 	target_cwnd += bbr_ack_aggregation_cwnd(sk);
-	target_cwnd = bbr_quantization_budget(sk, target_cwnd, gain);
+	target_cwnd = bbr_quantization_budget(sk, target_cwnd);
 
 	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
 	if (bbr_full_bw_reached(sk))  /* only cut cwnd if we filled the pipe */


