Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6695F5218DE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbiEJNlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245345AbiEJNiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F42C231CB7;
        Tue, 10 May 2022 06:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBCA061811;
        Tue, 10 May 2022 13:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D6DC385A6;
        Tue, 10 May 2022 13:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189347;
        bh=Q1Pw7W5J/DDhkzIuFGZrMlEJ+fbfkmpVgCHXmCffTew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZTLixSgJ9HGlJ+GePN8on4jU8BBrvJAavaRmxnwyQPIdGef2gY5RzcQXahIwrPGF
         /IHZQAsyQk9e8qEyoA4DICJTJE4BZpz8IMNdXkNmPsRSagSwrp1rGj2+mEMKLzDKqV
         lY1VBY5DV88IWH6czK7ECCdU5zvQiiOTdS0L/+3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, Ong@vger.kernel.org
Subject: [PATCH 5.15 021/135] net: stmmac: disable Split Header (SPH) for Intel platforms
Date:   Tue, 10 May 2022 15:06:43 +0200
Message-Id: <20220510130741.006005449@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

commit 47f753c1108e287edb3e27fad8a7511a9d55578e upstream.

Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
This SPH limitation will cause ping failure when the packets size exceed
the MTU size. For example, the issue happens once the basic ping packet
size is larger than the configured MTU size and the data is lost inside
the fragmented packet, replaced by zeros/corrupted values, and leads to
ping fail.

So, disable the Split Header for Intel platforms.

v2: Add fixes tag in commit message.

Fixes: 67afd6d1cfdf("net: stmmac: Add Split Header support and enable it in XGMAC cores")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Ong, Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 include/linux/stmmac.h                            |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -454,6 +454,7 @@ static int intel_mgbe_common_data(struct
 	plat->has_gmac4 = 1;
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
+	plat->sph_disable = 1;
 
 	/* Multiplying factor to the clk_eee_i clock time
 	 * period to make it closer to 100 ns. This value
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7081,7 +7081,7 @@ int stmmac_dvr_probe(struct device *devi
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
-	if (priv->dma_cap.sphen) {
+	if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
 		ndev->hw_features |= NETIF_F_GRO;
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -269,5 +269,6 @@ struct plat_stmmacenet_data {
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
 	bool use_phy_wol;
+	bool sph_disable;
 };
 #endif


