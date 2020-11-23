Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10422C0BE7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgKWNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgKWM1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742A9221FB;
        Mon, 23 Nov 2020 12:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134437;
        bh=gYKsR1AdBs4fmXQkm2oxjXbtBV5XxagJto6e+ZNOSl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJFn26ecQIsLytu19hBL302giQ6MXTesLSrvO0hjLHsp6Lt0Sga10wF0z5o88oXio
         gPB+1uU11bgobqxCrYty0IhV7QsgXVG9pGeYAzZaHyNBhR28hEXLAMA2V/rFvdLxGR
         RBMrKNqGuh/jEie3OaIShLO/3JP9m5m52LFZzLTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryan Sharpelletti <sharpelletti@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 19/60] tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate
Date:   Mon, 23 Nov 2020 13:22:01 +0100
Message-Id: <20201123121805.948801703@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Sharpelletti <sharpelletti@google.com>

[ Upstream commit 1b9e2a8c99a5c021041bfb2d512dc3ed92a94ffd ]

During loss recovery, retransmitted packets are forced to use TCP
timestamps to calculate the RTT samples, which have a millisecond
granularity. BBR is designed using a microsecond granularity. As a
result, multiple RTT samples could be truncated to the same RTT value
during loss recovery. This is problematic, as BBR will not enter
PROBE_RTT if the RTT sample is <= the current min_rtt sample, meaning
that if there are persistent losses, PROBE_RTT will constantly be
pushed off and potentially never re-entered. This patch makes sure
that BBR enters PROBE_RTT by checking if RTT sample is < the current
min_rtt sample, rather than <=.

The Netflix transport/TCP team discovered this bug in the Linux TCP
BBR code during lab tests.

Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
Signed-off-by: Ryan Sharpelletti <sharpelletti@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Link: https://lore.kernel.org/r/20201116174412.1433277-1-sharpelletti.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bbr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -769,7 +769,7 @@ static void bbr_update_min_rtt(struct so
 	filter_expired = after(tcp_jiffies32,
 			       bbr->min_rtt_stamp + bbr_min_rtt_win_sec * HZ);
 	if (rs->rtt_us >= 0 &&
-	    (rs->rtt_us <= bbr->min_rtt_us || filter_expired)) {
+	    (rs->rtt_us < bbr->min_rtt_us || filter_expired)) {
 		bbr->min_rtt_us = rs->rtt_us;
 		bbr->min_rtt_stamp = tcp_jiffies32;
 	}


