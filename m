Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1677C472547
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbhLMJnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhLMJkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84ABBB80E0C;
        Mon, 13 Dec 2021 09:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE6DC00446;
        Mon, 13 Dec 2021 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388434;
        bh=GswfCT3sRKbWdMNGhI9d3z5dDCY5wL5thjFRdvoUhlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvtLMSMQnZiyuKsax710WCNreNDnE5gsBrQFKL4rXg//V1MyEyQ/4gLenpmNVcuaq
         NCzB4XsRd6E316m0XDotVMZrqpBQ4YEFb1iK4Vk4goggtHDPc3wfwJFR42AwZ9KB9v
         LfqiY26mI9+sh6ph0vcJ0Vn5eie+6zhu83/wA2Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 48/74] net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
Date:   Mon, 13 Dec 2021 10:30:19 +0100
Message-Id: <20211213092932.419093534@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit b5bd95d17102b6719e3531d627875b9690371383 upstream.

Background:
We have a customer is running a Profinet stack on the 8MM which receives and
responds PNIO packets every 4ms and PNIO-CM packets every 40ms. However, from
time to time the received PNIO-CM package is "stock" and is only handled when
receiving a new PNIO-CM or DCERPC-Ping packet (tcpdump shows the PNIO-CM and
the DCERPC-Ping packet at the same time but the PNIO-CM HW timestamp is from
the expected 40 ms and not the 2s delay of the DCERPC-Ping).

After debugging, we noticed PNIO, PNIO-CM and DCERPC-Ping packets would
be handled by different RX queues.

The root cause should be driver ack all queues' interrupt when handle a
specific queue in fec_enet_rx_queue(). The blamed patch is introduced to
receive as much packets as possible once to avoid interrupt flooding.
But it's unreasonable to clear other queues'interrupt when handling one
queue, this patch tries to fix it.

Fixes: ed63f1dcd578 (net: fec: clear receive interrupts before processing a packet)
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Reported-by: Nicolas Diaz <nicolas.diaz@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20211206135457.15946-1-qiangqing.zhang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec.h      |    3 +++
 drivers/net/ethernet/freescale/fec_main.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -373,6 +373,9 @@ struct bufdesc_ex {
 #define FEC_ENET_WAKEUP	((uint)0x00020000)	/* Wakeup request */
 #define FEC_ENET_TXF	(FEC_ENET_TXF_0 | FEC_ENET_TXF_1 | FEC_ENET_TXF_2)
 #define FEC_ENET_RXF	(FEC_ENET_RXF_0 | FEC_ENET_RXF_1 | FEC_ENET_RXF_2)
+#define FEC_ENET_RXF_GET(X)	(((X) == 0) ? FEC_ENET_RXF_0 :	\
+				(((X) == 1) ? FEC_ENET_RXF_1 :	\
+				FEC_ENET_RXF_2))
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1441,7 +1441,7 @@ fec_enet_rx_queue(struct net_device *nde
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF_GET(queue_id), fep->hwp + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;


