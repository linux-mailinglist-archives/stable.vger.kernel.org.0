Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0F41CAB4A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgEHMmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgEHMmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18CF21835;
        Fri,  8 May 2020 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941731;
        bh=Esc86zY99rb4tSwkuVMshuFgUhwa3CRmyeRGvkVGdrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnjCCbuQUoPKNYZFzoqi+N+kWQ+6bHE8IuQO9IsriumVYXe36X/1Ub4zWJYQ+cfPF
         Dcn5xopk1zYUfw/fKEXHT14kYUkJdlgsfMbyDvw+ZVmXxHN3USFnAUQIRKk6QUwUvC
         Nz/Uyk5Q4yTPYZl9Ljpcxwv658SaXmClybqzlEDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 111/312] tcp: do not set rtt_min to 1
Date:   Fri,  8 May 2020 14:31:42 +0200
Message-Id: <20200508123132.294652218@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 372022830b06d9980c7e8b41fa0a4081cff883b0 upstream.

There are some cases where rtt_us derives from deltas of jiffies,
instead of using usec timestamps.

Since we want to track minimal rtt, better to assume a delta of 0 jiffie
might be in fact be very close to 1 jiffie.

It is kind of sad jiffies_to_usecs(1) calls a function instead of simply
using a constant.

Fixes: f672258391b42 ("tcp: track min RTT using windowed min-filter")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2926,7 +2926,10 @@ static void tcp_update_rtt_min(struct so
 {
 	const u32 now = tcp_time_stamp, wlen = sysctl_tcp_min_rtt_wlen * HZ;
 	struct rtt_meas *m = tcp_sk(sk)->rtt_min;
-	struct rtt_meas rttm = { .rtt = (rtt_us ? : 1), .ts = now };
+	struct rtt_meas rttm = {
+		.rtt = likely(rtt_us) ? rtt_us : jiffies_to_usecs(1),
+		.ts = now,
+	};
 	u32 elapsed;
 
 	/* Check if the new measurement updates the 1st, 2nd, or 3rd choices */


