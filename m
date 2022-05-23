Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A1530725
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 03:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbiEWBcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 May 2022 21:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiEWBcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 May 2022 21:32:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3F38BF6
        for <stable@vger.kernel.org>; Sun, 22 May 2022 18:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653269529; x=1684805529;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dcJ4rc5BhpJ3pZTK16nKts4F0SHmRNBv7wihSNYHR00=;
  b=a7ISEqWUFBft8JIfbDSVnB50OczpSvjfRzeNOkWbe0weGzulWUB4PN/i
   56MTfqqIdxU8DgYZpZo1mnZ0Nh3OYawDwze8PCHdrIzbZ6yJWp5kYM0vF
   Dh+MH7mZUvp8GI1xouAaB3ZntM3w19lGLekd1f9zMrFUl7WuPuMpBEgmF
   9QdJRBL+sUDJDnJ7bf3OGyis2gffunCmKW+q79fNyMOvHFiSevsewr/Jq
   4rOLNpjqLnEz9Ix/N0hpvx7NpdslF0SfDv9f+vIFt7Wn/NAXuS7mvmJTx
   6P8Usnzd6MKvJ3DvOnIg14Yj8kNY7ec0tJVlAEYzvpHh/gacAxZuFe8pf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="270639901"
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="270639901"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 18:32:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="675612571"
Received: from p12hl01tmin.png.intel.com ([10.158.65.175])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2022 18:32:08 -0700
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH] net: stmmac: disable Split Header (SPH) for Intel platforms
Date:   Mon, 23 May 2022 09:39:10 +0800
Message-Id: <20220523013910.3147844-1-tee.min.tan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # 5.4.x
Suggested-by: Ong, Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  | 1 +
 include/linux/stmmac.h                            | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9cbc0179d24e..9931724c4727 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4531,7 +4531,7 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
-	if (priv->dma_cap.sphen) {
+	if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
 		ndev->hw_features |= NETIF_F_GRO;
 		priv->sph = true;
 		dev_info(priv->device, "SPH feature enabled\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 292045f4581f..d46e3795899f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -119,6 +119,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->has_gmac4 = 1;
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
+	plat->sph_disable = 1;
 
 	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index dc60d03c4b60..0b35747c9837 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -179,5 +179,6 @@ struct plat_stmmacenet_data {
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
 	int has_xgmac;
+	bool sph_disable;
 };
 #endif
-- 
2.25.1

