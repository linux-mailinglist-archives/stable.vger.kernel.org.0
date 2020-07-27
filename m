Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE722F028
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgG0OWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731863AbgG0OWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0AEE2083E;
        Mon, 27 Jul 2020 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859740;
        bh=N3uvxnTFN3pzdT4wAHLGM8Qz19yO6nAZXWjbSZF/A0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgyVk9T1AXZasFF8HIzb3nTnatAiW0X1aI591e0AE8kYH7+kzl3LLOE5zLauGoa7g
         eXkDqWCi7pklK1SUsl/OXwZv7Xtkcb6l/IQyP93f3L1ZX6NSelgB7lrPAXpXET3l4C
         CipB2lVLi853ZB6ZTMg/VO3CeXV1fWciuPnRxqfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Organov <sorganov@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 056/179] net: fec: fix hardware time stamping by external devices
Date:   Mon, 27 Jul 2020 16:03:51 +0200
Message-Id: <20200727134935.399267347@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com>

[ Upstream commit 340746398b67e3ce5019698748ebaa7adf048114 ]

Fix support for external PTP-aware devices such as DSA or PTP PHY:

Make sure we never time stamp tx packets when hardware time stamping
is disabled.

Check for PTP PHY being in use and then pass ioctls related to time
stamping of Ethernet packets to the PTP PHY rather than handle them
ourselves. In addition, disable our own hardware time stamping in this
case.

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Signed-off-by: Sergey Organov <sorganov@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
 drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index e74dd1f86bbae..828eb8ce6631c 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -597,6 +597,7 @@ struct fec_enet_private {
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
+void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index dc6f8763a5d40..bf73bc9bf35b9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1302,8 +1302,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 			ndev->stats.tx_bytes += skb->len;
 		}
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
-			fep->bufdesc_ex) {
+		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
+		 * are to time stamp the packet, so we still need to check time
+		 * stamping enabled flag.
+		 */
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
+			     fep->hwts_tx_en) &&
+		    fep->bufdesc_ex) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
 
@@ -2731,10 +2736,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 		return -ENODEV;
 
 	if (fep->bufdesc_ex) {
-		if (cmd == SIOCSHWTSTAMP)
-			return fec_ptp_set(ndev, rq);
-		if (cmd == SIOCGHWTSTAMP)
-			return fec_ptp_get(ndev, rq);
+		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
+
+		if (cmd == SIOCSHWTSTAMP) {
+			if (use_fec_hwts)
+				return fec_ptp_set(ndev, rq);
+			fec_ptp_disable_hwts(ndev);
+		} else if (cmd == SIOCGHWTSTAMP) {
+			if (use_fec_hwts)
+				return fec_ptp_get(ndev, rq);
+		}
 	}
 
 	return phy_mii_ioctl(phydev, rq, cmd);
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 945643c026155..f8a592c96beb0 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -452,6 +452,18 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
+/**
+ * fec_ptp_disable_hwts - disable hardware time stamping
+ * @ndev: pointer to net_device
+ */
+void fec_ptp_disable_hwts(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	fep->hwts_tx_en = 0;
+	fep->hwts_rx_en = 0;
+}
+
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-- 
2.25.1



