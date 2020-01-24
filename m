Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21DA14837A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbgAXLg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390172AbgAXLg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:28 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C58206D4;
        Fri, 24 Jan 2020 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865787;
        bh=RH+nf+117on/CnBcGBvoiBwFRfJGcmBmZUCP+4CDHbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hetHvYp8XvZjgAEA3medTMOaVYjsmnHLW7t3DSklDy41gsq4jpYI13y3DHwQUiI+I
         LEGTw7Ccy/YxHJ11dJd0LMtMnhrcUKvi7PazMYCCGkVq9EJwDjIx45abMqKPGHObQY
         31UDHkxG/ep7Efu4R6D1ch87/9/Rlm5aqg4x+aYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 620/639] dpaa_eth: perform DMA unmapping before read
Date:   Fri, 24 Jan 2020 10:33:10 +0100
Message-Id: <20200124093207.309348821@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit c70fd3182caef014e6c628b412f81aa57a3ef9e4 ]

DMA unmapping is required before accessing the HW provided timestamping
information.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 462bb8c4f80c9..3cd62a71ddea8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1620,18 +1620,6 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	skbh = (struct sk_buff **)phys_to_virt(addr);
 	skb = *skbh;
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-
-		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
-					  &ns)) {
-			shhwtstamps.hwtstamp = ns_to_ktime(ns);
-			skb_tstamp_tx(skb, &shhwtstamps);
-		} else {
-			dev_warn(dev, "fman_port_get_tstamp failed!\n");
-		}
-	}
-
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
 		dma_unmap_single(dev, addr,
@@ -1654,14 +1642,28 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 			dma_unmap_page(dev, qm_sg_addr(&sgt[i]),
 				       qm_sg_entry_get_len(&sgt[i]), dma_dir);
 		}
-
-		/* Free the page frag that we allocated on Tx */
-		skb_free_frag(phys_to_virt(addr));
 	} else {
 		dma_unmap_single(dev, addr,
 				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
 	}
 
+	/* DMA unmapping is required before accessing the HW provided info */
+	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+
+		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
+					  &ns)) {
+			shhwtstamps.hwtstamp = ns_to_ktime(ns);
+			skb_tstamp_tx(skb, &shhwtstamps);
+		} else {
+			dev_warn(dev, "fman_port_get_tstamp failed!\n");
+		}
+	}
+
+	if (qm_fd_get_format(fd) == qm_fd_sg)
+		/* Free the page frag that we allocated on Tx */
+		skb_free_frag(phys_to_virt(addr));
+
 	return skb;
 }
 
-- 
2.20.1



