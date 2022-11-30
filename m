Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA06A63DD98
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiK3S2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiK3S2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E504927B3C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8271961B7C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E58C433D6;
        Wed, 30 Nov 2022 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832926;
        bh=bzJT0WFc9yKXSXQq5AHikRpsfx4SBA9onIOSQR3H7R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PptY5yNHHtHdrGubg14peMYv8LWpZsb78NC31jSOMTH8GbTn9jSN6KI9dpsIqGwJU
         WGKTWNTV+4rBUCaavlmMgkn2iP66ML8drCxTHS2pVBHzmySLtZTz66h+8YN0VDbbvh
         cc7TRGCI2O6D/E9+T6QcEsAfhWyOZKyTnUZc2uDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/162] net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
Date:   Wed, 30 Nov 2022 19:22:50 +0100
Message-Id: <20221130180530.911190990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 32bf8e1f6fb9f6dc334b2b98dffc2e5dcd51e513 ]

Future work in this driver would like to look at priv->active_offloads &
ENETC_F_QBV to determine whether a tc-taprio qdisc offload was
installed, but this does not produce the intended effect.

All the other flags in priv->active_offloads are managed dynamically,
except ENETC_F_QBV which is set statically based on the probed SI capability.

This change makes priv->active_offloads & ENETC_F_QBV really track the
presence of a tc-taprio schedule on the port.

Some existing users, like the enetc_sched_speed_set() call from
phylink_mac_link_up(), are best kept using the old logic: the tc-taprio
offload does not re-trigger another link mode resolve, so the scheduler
needs to be functional from the get go, as long as Qbv is supported at
all on the port. So to preserve functionality there, look at the static
station interface capability from pf->si->hw_features instead.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 290b5fe096e7 ("net: enetc: preserve TX ring priority across reconfiguration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  | 6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 6904e10dd46b..515db7e6e649 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -748,9 +748,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -996,7 +993,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 62efe1aebf86..b0e278e1f4ad 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -69,6 +69,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		enetc_wr(&priv->si->hw,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
+
+		priv->active_offloads &= ~ENETC_F_QBV;
+
 		return 0;
 	}
 
@@ -135,6 +138,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
 	kfree(gcl_data);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
-- 
2.35.1



