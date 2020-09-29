Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12027CD21
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbgI2Mlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgI2LMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB87208FE;
        Tue, 29 Sep 2020 11:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377957;
        bh=hl8T1jotUU+9LpglCkqsLoI+MqPeKWFSs4d+2d7x9Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEc55MtTh7zL9/ccElH5q/R0XEUjjYRzjUpw67kU6aoQq2KI09uIkY4oro3RAATM2
         7eZanw/NUO9VE+2NJls45rQxpoyLHs6k1Z2phqwv5VhPJzfRPJe9hDiGfSEyIb+nbH
         XivUBvaxcuJVXJ4OdhS+bD/6EBpt1ha2sjQ2zxME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 012/166] bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.
Date:   Tue, 29 Sep 2020 12:58:44 +0200
Message-Id: <20200929105935.800678951@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a53906908148d64423398a62c4435efb0d09652c ]

All changes related to bp->link_info require the protection of the
link_lock mutex.  It's not sufficient to rely just on RTNL.

Fixes: 163e9ef63641 ("bnxt_en: Fix race when modifying pause settings.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   31 ++++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1264,9 +1264,12 @@ static int bnxt_set_pauseparam(struct ne
 	if (!BNXT_SINGLE_PF(bp))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&bp->link_lock);
 	if (epause->autoneg) {
-		if (!(link_info->autoneg & BNXT_AUTONEG_SPEED))
-			return -EINVAL;
+		if (!(link_info->autoneg & BNXT_AUTONEG_SPEED)) {
+			rc = -EINVAL;
+			goto pause_exit;
+		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
 		if (bp->hwrm_spec_code >= 0x10201)
@@ -1287,11 +1290,11 @@ static int bnxt_set_pauseparam(struct ne
 	if (epause->tx_pause)
 		link_info->req_flow_ctrl |= BNXT_LINK_PAUSE_TX;
 
-	if (netif_running(dev)) {
-		mutex_lock(&bp->link_lock);
+	if (netif_running(dev))
 		rc = bnxt_hwrm_set_pause(bp);
-		mutex_unlock(&bp->link_lock);
-	}
+
+pause_exit:
+	mutex_unlock(&bp->link_lock);
 	return rc;
 }
 
@@ -1977,8 +1980,7 @@ static int bnxt_set_eee(struct net_devic
 	struct bnxt *bp = netdev_priv(dev);
 	struct ethtool_eee *eee = &bp->eee;
 	struct bnxt_link_info *link_info = &bp->link_info;
-	u32 advertising =
-		 _bnxt_fw_to_ethtool_adv_spds(link_info->advertising, 0);
+	u32 advertising;
 	int rc = 0;
 
 	if (!BNXT_SINGLE_PF(bp))
@@ -1987,19 +1989,23 @@ static int bnxt_set_eee(struct net_devic
 	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&bp->link_lock);
+	advertising = _bnxt_fw_to_ethtool_adv_spds(link_info->advertising, 0);
 	if (!edata->eee_enabled)
 		goto eee_ok;
 
 	if (!(link_info->autoneg & BNXT_AUTONEG_SPEED)) {
 		netdev_warn(dev, "EEE requires autoneg\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto eee_exit;
 	}
 	if (edata->tx_lpi_enabled) {
 		if (bp->lpi_tmr_hi && (edata->tx_lpi_timer > bp->lpi_tmr_hi ||
 				       edata->tx_lpi_timer < bp->lpi_tmr_lo)) {
 			netdev_warn(dev, "Valid LPI timer range is %d and %d microsecs\n",
 				    bp->lpi_tmr_lo, bp->lpi_tmr_hi);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto eee_exit;
 		} else if (!bp->lpi_tmr_hi) {
 			edata->tx_lpi_timer = eee->tx_lpi_timer;
 		}
@@ -2009,7 +2015,8 @@ static int bnxt_set_eee(struct net_devic
 	} else if (edata->advertised & ~advertising) {
 		netdev_warn(dev, "EEE advertised %x must be a subset of autoneg advertised speeds %x\n",
 			    edata->advertised, advertising);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto eee_exit;
 	}
 
 	eee->advertised = edata->advertised;
@@ -2021,6 +2028,8 @@ eee_ok:
 	if (netif_running(dev))
 		rc = bnxt_hwrm_set_link_setting(bp, false, true);
 
+eee_exit:
+	mutex_unlock(&bp->link_lock);
 	return rc;
 }
 


