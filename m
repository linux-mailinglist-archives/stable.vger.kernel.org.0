Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6172E540BE2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241913AbiFGScQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351340AbiFGS3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02692AC4C;
        Tue,  7 Jun 2022 10:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63DF9B8236A;
        Tue,  7 Jun 2022 17:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53E1C385A5;
        Tue,  7 Jun 2022 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624529;
        bh=8Bx+drwoGw8Sv4ga49DGRMZoNDgXYPA6eqihr4GbAYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GakebzdIomD03D9oT53kECmCTsOXn7TkfBPR4h6SH+ZnepUcM4R68EvuNBCr6hPRw
         llPg1GX7ntn59w/I7uhF/ALWYmirErPDC3XZfCfCielMRP1Yd3MlC9rqirR4RXeqmn
         IfwYWNg7kvstuJmhJHZetOSSn5SwpC6gLx54AQns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/667] net: macb: Fix PTP one step sync support
Date:   Tue,  7 Jun 2022 19:00:26 +0200
Message-Id: <20220607164945.581504163@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 5cebb40bc9554aafcc492431181f43c6231b0459 ]

PTP one step sync packets cannot have CSUM padding and insertion in
SW since time stamp is inserted on the fly by HW.
In addition, ptp4l version 3.0 and above report an error when skb
timestamps are reported for packets that not processed for TX TS
after transmission.
Add a helper to identify PTP one step sync and fix the above two
errors. Add a common mask for PTP header flag field "twoStepflag".
Also reset ptp OSS bit when one step is not selected.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220518170756.7752-1-harini.katakam@xilinx.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 40 +++++++++++++++++++++---
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++-
 include/linux/ptp_classify.h             |  3 ++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 2fd3dd4b8b81..3ca3f9d0fd9b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -35,6 +35,7 @@
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
 #include <linux/pm_runtime.h>
+#include <linux/ptp_classify.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -1155,6 +1156,36 @@ static void macb_tx_error_task(struct work_struct *work)
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
+static bool ptp_one_step_sync(struct sk_buff *skb)
+{
+	struct ptp_header *hdr;
+	unsigned int ptp_class;
+	u8 msgtype;
+
+	/* No need to parse packet if PTP TS is not involved */
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
+		goto not_oss;
+
+	/* Identify and return whether PTP one step sync is being processed */
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		goto not_oss;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		goto not_oss;
+
+	if (hdr->flag_field[0] & PTP_FLAG_TWOSTEP)
+		goto not_oss;
+
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	if (msgtype == PTP_MSGTYPE_SYNC)
+		return true;
+
+not_oss:
+	return false;
+}
+
 static void macb_tx_interrupt(struct macb_queue *queue)
 {
 	unsigned int tail;
@@ -1199,8 +1230,8 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (unlikely(skb_shinfo(skb)->tx_flags &
-					     SKBTX_HW_TSTAMP) &&
+				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+				    !ptp_one_step_sync(skb) &&
 				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
 					/* skb now belongs to timestamp buffer
 					 * and will be removed later
@@ -2030,7 +2061,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
 			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
-			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
+			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
+			    !ptp_one_step_sync(skb))
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
 			/* Only set MSS/MFS on payload descriptors
@@ -2128,7 +2160,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 
 	if (!(ndev->features & NETIF_F_HW_CSUM) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
-	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
+	    skb_shinfo(*skb)->gso_size || ptp_one_step_sync(*skb))
 		return 0;
 
 	if (padlen <= 0) {
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index c2e1f163bb14..c52ec1cc8a08 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -469,8 +469,10 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 		if (gem_ptp_set_one_step_sync(bp, 1) != 0)
 			return -ERANGE;
-		fallthrough;
+		tx_bd_control = TSTAMP_ALL_FRAMES;
+		break;
 	case HWTSTAMP_TX_ON:
+		gem_ptp_set_one_step_sync(bp, 0);
 		tx_bd_control = TSTAMP_ALL_FRAMES;
 		break;
 	default:
diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index ae04968a3a47..7a526b52bd74 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -42,6 +42,9 @@
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
 #define OFF_PTP_SEQUENCE_ID	30
 
+/* PTP header flag fields */
+#define PTP_FLAG_TWOSTEP	BIT(1)
+
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
 #define UDP_HLEN	8
-- 
2.35.1



