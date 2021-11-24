Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB345C65E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351869AbhKXOHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351582AbhKXOFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:05:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556D76333C;
        Wed, 24 Nov 2021 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759510;
        bh=OV0T2JPS0EtjdRspJ/JuY1a146QKnOp9P0d33wotH0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRSMZPLHxSbwzqQkLDYd1C/ZsUvLfUpsXsfK/FnAQyIGTtbAgUSILrp7QnF13MYgs
         02IJ16AH399Jy2V7KUW8pqM191slZUqTXS6IVF/XpP/BfenFoSgpd61vRjPPuWZ+5o
         H60xJwRiK8H3RtRJu3sJXofqQezygydPxV+5J9m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH 5.15 234/279] net: stmmac: Fix signed/unsigned wreckage
Date:   Wed, 24 Nov 2021 12:58:41 +0100
Message-Id: <20211124115726.825822807@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3751c3d34cd5a750c86d1c8eaf217d8faf7f9325 upstream.

The recent addition of timestamp correction to compensate the CDC error
introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().

The issue is:

    s64 adjust = 0;
    u64 ns;

    adjust += -(2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate));
    ns += adjust;

works by chance on 64bit, but falls apart on 32bit because the compiler
knows that adjust fits into 32bit and then treats the addition as a u64 +
u32 resulting in an off by ~2 seconds failure.

The RX variant uses an u64 for adjust and does the adjustment via

    ns -= adjust;

because consistency is obviously overrated.

Get rid of the pointless zero initialized adjust variable and do:

	ns -= (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;

which is obviously correct and spares the adjust obfuscation. Aside of that
it yields a more accurate result because the multiplication takes place
before the integer divide truncation and not afterwards.

Stick the calculation into an inline so it can't be accidentally
disimproved. Return an u32 from that inline as the result is guaranteed
to fit which lets the compiler optimize the substraction.

Cc: stable@vger.kernel.org
Fixes: 3600be5f58c1 ("net: stmmac: add timestamp correction to rid CDC sync error")
Reported-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Benedikt Spranger <b.spranger@linutronix.de>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de> # Intel EHL
Link: https://lore.kernel.org/r/87mtm578cs.ffs@tglx
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   23 +++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -511,6 +511,14 @@ bool stmmac_eee_init(struct stmmac_priv
 	return true;
 }
 
+static inline u32 stmmac_cdc_adjust(struct stmmac_priv *priv)
+{
+	/* Correct the clk domain crossing(CDC) error */
+	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+		return (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
+	return 0;
+}
+
 /* stmmac_get_tx_hwtstamp - get HW TX timestamps
  * @priv: driver private structure
  * @p : descriptor pointer
@@ -524,7 +532,6 @@ static void stmmac_get_tx_hwtstamp(struc
 {
 	struct skb_shared_hwtstamps shhwtstamp;
 	bool found = false;
-	s64 adjust = 0;
 	u64 ns = 0;
 
 	if (!priv->hwts_tx_en)
@@ -543,12 +550,7 @@ static void stmmac_get_tx_hwtstamp(struc
 	}
 
 	if (found) {
-		/* Correct the clk domain crossing(CDC) error */
-		if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate) {
-			adjust += -(2 * (NSEC_PER_SEC /
-					 priv->plat->clk_ptp_rate));
-			ns += adjust;
-		}
+		ns -= stmmac_cdc_adjust(priv);
 
 		memset(&shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamp.hwtstamp = ns_to_ktime(ns);
@@ -573,7 +575,6 @@ static void stmmac_get_rx_hwtstamp(struc
 {
 	struct skb_shared_hwtstamps *shhwtstamp = NULL;
 	struct dma_desc *desc = p;
-	u64 adjust = 0;
 	u64 ns = 0;
 
 	if (!priv->hwts_rx_en)
@@ -586,11 +587,7 @@ static void stmmac_get_rx_hwtstamp(struc
 	if (stmmac_get_rx_timestamp_status(priv, p, np, priv->adv_ts)) {
 		stmmac_get_timestamp(priv, desc, priv->adv_ts, &ns);
 
-		/* Correct the clk domain crossing(CDC) error */
-		if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate) {
-			adjust += 2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate);
-			ns -= adjust;
-		}
+		ns -= stmmac_cdc_adjust(priv);
 
 		netdev_dbg(priv->dev, "get valid RX hw timestamp %llu\n", ns);
 		shhwtstamp = skb_hwtstamps(skb);


