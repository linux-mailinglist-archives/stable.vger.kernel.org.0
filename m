Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12EAB5CB5C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfGBIHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbfGBIHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 991B721479;
        Tue,  2 Jul 2019 08:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054859;
        bh=3KVJGkIrX5Yw69arPwOamrCH2QLo1Lg2uer/BTJA54g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qe0LZmTNK6Snf0TA95WQrQmvnGjnqy6SAu1Rce0RlOjluf3ArTuWH41ze9VHcm2MC
         GdPUl/uTZbRRafnEe/QayRrbwavFLba0+QdgOeByZg24QMBNDr0kxRvqQzSIHX7xEt
         hHn1cp+uMlyLWbf+Osl2wgXumEgA1vF1lhz1MvEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roland Hii <roland.king.guan.hii@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 56/72] net: stmmac: set IC bit when transmitting frames with HW timestamp
Date:   Tue,  2 Jul 2019 10:01:57 +0200
Message-Id: <20190702080127.502451969@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Hii <roland.king.guan.hii@intel.com>

[ Upstream commit d0bb82fd60183868f46c8ccc595a3d61c3334a18 ]

When transmitting certain PTP frames, e.g. SYNC and DELAY_REQ, the
PTP daemon, e.g. ptp4l, is polling the driver for the frame transmit
hardware timestamp. The polling will most likely timeout if the tx
coalesce is enabled due to the Interrupt-on-Completion (IC) bit is
not set in tx descriptor for those frames.

This patch will ignore the tx coalesce parameter and set the IC bit
when transmitting PTP frames which need to report out the frame
transmit hardware timestamp to user space.

Fixes: f748be531d70 ("net: stmmac: Rework coalesce timer and fix multi-queue races")
Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2938,12 +2938,15 @@ static netdev_tx_t stmmac_tso_xmit(struc
 
 	/* Manage tx mitigation */
 	tx_q->tx_count_frames += nfrags + 1;
-	if (priv->tx_coal_frames <= tx_q->tx_count_frames) {
+	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
+	    !(priv->synopsys_id >= DWMAC_CORE_4_00 &&
+	    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    priv->hwts_tx_en)) {
+		stmmac_tx_timer_arm(priv, queue);
+	} else {
+		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-		tx_q->tx_count_frames = 0;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	skb_tx_timestamp(skb);
@@ -3157,12 +3160,15 @@ static netdev_tx_t stmmac_xmit(struct sk
 	 * element in case of no SG.
 	 */
 	tx_q->tx_count_frames += nfrags + 1;
-	if (priv->tx_coal_frames <= tx_q->tx_count_frames) {
+	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
+	    !(priv->synopsys_id >= DWMAC_CORE_4_00 &&
+	    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    priv->hwts_tx_en)) {
+		stmmac_tx_timer_arm(priv, queue);
+	} else {
+		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-		tx_q->tx_count_frames = 0;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	skb_tx_timestamp(skb);


