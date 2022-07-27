Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45443582CF0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiG0QwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiG0Qvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234ED54670;
        Wed, 27 Jul 2022 09:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 514CE61A24;
        Wed, 27 Jul 2022 16:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3FEC433C1;
        Wed, 27 Jul 2022 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939609;
        bh=LMFLkaARFUSM+NsSDl+g6LE9sF4zJ1l9KvkUVRUo8Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gri+OL2yS+BOo/vdT1wOpsnMWNRJ8KE7RrG36WZ46BnSRJkOt6TqBBwZIWZP6LT1s
         4/Q+uC/FsQYjrpMphsFnVtQCrWixk32vYweJIgx4P3G3eL++feivaFOx0Q3AuT5LmK
         9SoCU9jzB4vtkdcs4KXV8mVtWpw8DfTWaguhAwYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/105] net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow
Date:   Wed, 27 Jul 2022 18:10:27 +0200
Message-Id: <20220727161013.744754839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit f4c7d8948e866918d61493264dbbd67e45ef2bda ]

Current stmmac driver will prepare/enable ptp_ref clock in
stmmac_init_tstamp_counter().

The stmmac_pltfr_noirq_suspend will disable it once in suspend flow.

But in resume flow,
	stmmac_pltfr_noirq_resume --> stmmac_init_tstamp_counter
	stmmac_resume --> stmmac_hw_setup --> stmmac_init_ptp --> stmmac_init_tstamp_counter
ptp_ref clock reference counter increases twice, which leads to unbalance
ptp clock when resume back.

Move ptp_ref clock prepare/enable out of stmmac_init_tstamp_counter to fix it.

Fixes: 0735e639f129d ("net: stmmac: skip only stmmac_ptp_register when resume from suspend")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++++++++---------
 .../ethernet/stmicro/stmmac/stmmac_platform.c   |  8 +++++++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e9aa9a5eba6b..27b7bb64a028 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -738,19 +738,10 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	struct timespec64 now;
 	u32 sec_inc = 0;
 	u64 temp = 0;
-	int ret;
 
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
-	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-	if (ret < 0) {
-		netdev_warn(priv->dev,
-			    "failed to enable PTP reference clock: %pe\n",
-			    ERR_PTR(ret));
-		return ret;
-	}
-
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
@@ -2755,6 +2746,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	stmmac_mmc_setup(priv);
 
+	if (ptp_register) {
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0)
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+	}
+
 	ret = stmmac_init_ptp(priv);
 	if (ret == -EOPNOTSUPP)
 		netdev_warn(priv->dev, "PTP not supported by HW\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index b40b962055fa..f70d8d1ce329 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -814,7 +814,13 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 		if (ret)
 			return ret;
 
-		stmmac_init_tstamp_counter(priv, priv->systime_flags);
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0) {
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+			return ret;
+		}
 	}
 
 	return 0;
-- 
2.35.1



