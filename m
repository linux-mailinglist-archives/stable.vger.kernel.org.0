Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39D472A0A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbhLMK3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344689AbhLMK1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:27:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A4C01DF1C;
        Mon, 13 Dec 2021 02:01:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4B96CE0E69;
        Mon, 13 Dec 2021 10:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A66C34604;
        Mon, 13 Dec 2021 10:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389690;
        bh=vxz0y/+UF10FMsWkCs6YvhigHuhFml/sB4T8Uv3Dczo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWwC/nrH76y5DvN8ew9lvdQYhCuTFlzfCPHUiawcUsD7nFtZk1piz+7UmzzWuV4/E
         D+BIov5Icoe96Lc21//YeZj6tNJ3b+w4hbO7z+1TJn4pb1txtTxPv4slNbF3hkajpP
         PavJi7wVFaPcgM/Nga7xN+mfPvtTW78QBH3gFVbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 132/171] net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
Date:   Mon, 13 Dec 2021 10:30:47 +0100
Message-Id: <20211213092949.491729640@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -377,6 +377,9 @@ struct bufdesc_ex {
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
@@ -1480,7 +1480,7 @@ fec_enet_rx_queue(struct net_device *nde
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF_GET(queue_id), fep->hwp + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;


