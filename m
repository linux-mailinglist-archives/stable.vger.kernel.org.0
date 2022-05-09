Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3151F7F4
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiEIJWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiEIIxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4E31F63A1
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B16B8103B
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E84C385A8;
        Mon,  9 May 2022 08:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652086193;
        bh=mWX4YpwEH6eXekLTkMC9RVtKNn1MaJVvedXmaGl2Q2k=;
        h=Subject:To:Cc:From:Date:From;
        b=oC67vl7556CooLa9dFiFWs962ffuaUTVyqW0/C56FaCfgEBHx6IkZR8y9ifNRfkLl
         EQ93kqXbg7qMi2CyVHNV5N+PYr7gysph1oh5XrTZAQ41+G1ioNwl9mxpW/DrEhvSK9
         lFMumVQlqaBCIwTRkS8hkpv6g/U0uxqHAhg7fd8g=
Subject: FAILED: patch "[PATCH] net: stmmac: disable Split Header (SPH) for Intel platforms" failed to apply to 5.4-stable tree
To:     tee.min.tan@linux.intel.com, boon.leong.ong@intel.com,
        davem@davemloft.net, mohammad.athari.ismail@intel.com,
        stable@vger.kernel.org, vee.khee.wong@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:49:50 +0200
Message-ID: <1652086190123103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47f753c1108e287edb3e27fad8a7511a9d55578e Mon Sep 17 00:00:00 2001
From: Tan Tee Min <tee.min.tan@linux.intel.com>
Date: Fri, 29 Apr 2022 19:58:07 +0800
Subject: [PATCH] net: stmmac: disable Split Header (SPH) for Intel platforms

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

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 63754a9c4ba7..0b0be0898ac5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -454,6 +454,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->has_gmac4 = 1;
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
+	plat->sph_disable = 1;
 
 	/* Multiplying factor to the clk_eee_i clock time
 	 * period to make it closer to 100 ns. This value
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4a4b3651ab3e..2525a80353b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7021,7 +7021,7 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
-	if (priv->dma_cap.sphen) {
+	if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
 		ndev->hw_features |= NETIF_F_GRO;
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 24eea1b05ca2..29917850f079 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -270,5 +270,6 @@ struct plat_stmmacenet_data {
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
 	bool use_phy_wol;
+	bool sph_disable;
 };
 #endif

