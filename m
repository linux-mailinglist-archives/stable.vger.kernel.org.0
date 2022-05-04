Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6357C51A9B2
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356759AbiEDRS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357552AbiEDRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E535C55201;
        Wed,  4 May 2022 09:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE298B827A5;
        Wed,  4 May 2022 16:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E099C385A5;
        Wed,  4 May 2022 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683495;
        bh=34yqrLUrOLP4CJ6yBqeL5xAplowQx5MqJmelcFAmDbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCGEuWHZCeyqZ/+u1uB3aCdbEFG8+I6oIVxSk7nDqX7+6M3+VmuaEcHcQ5gxjOefJ
         MLKpm6fntya7HFVlbRZEeCOf2rPo6HXeN4fs/GHUnjJNfaRhbBLU2bbIM4R/wsxN/S
         5nf2BgXAwn2xWsxLaN1FIH+QDgjunCdSll3uG4o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 153/225] net: enetc: allow tc-etf offload even with NETIF_F_CSUM_MASK
Date:   Wed,  4 May 2022 18:46:31 +0200
Message-Id: <20220504153123.731449210@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 66a2f5ef68faaf950746747d790a0c95f7ec96d2 ]

The Time-Specified Departure feature is indeed mutually exclusive with
TX IP checksumming in ENETC, but TX checksumming in itself is broken and
was removed from this driver in commit 82728b91f124 ("enetc: Remove Tx
checksumming offload code").

The blamed commit declared NETIF_F_HW_CSUM in dev->features to comply
with software TSO's expectations, and still did the checksumming in
software by calling skb_checksum_help(). So there isn't any restriction
for the Time-Specified Departure feature.

However, enetc_setup_tc_txtime() doesn't understand that, and blindly
looks for NETIF_F_CSUM_MASK.

Instead of checking for things which can literally never happen in the
current code base, just remove the check and let the driver offload
tc-etf qdiscs.

Fixes: acede3c5dad5 ("net: enetc: declare NETIF_F_HW_CSUM and do it in software")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220427203017.1291634-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index d3d7172e0fcc..3b148d4e0f0c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -308,10 +308,6 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	if (tc < 0 || tc >= priv->num_tx_rings)
 		return -EINVAL;
 
-	/* Do not support TXSTART and TX CSUM offload simutaniously */
-	if (ndev->features & NETIF_F_CSUM_MASK)
-		return -EBUSY;
-
 	/* TSD and Qbv are mutually exclusive in hardware */
 	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
 		return -EBUSY;
-- 
2.35.1



