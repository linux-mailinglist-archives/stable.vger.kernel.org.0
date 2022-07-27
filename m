Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE5582E26
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiG0RI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiG0RHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DA04E609;
        Wed, 27 Jul 2022 09:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ACC860D3C;
        Wed, 27 Jul 2022 16:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123F5C433D6;
        Wed, 27 Jul 2022 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940018;
        bh=Xd3Ruhz90sS4nMtEn5T2f4REu/L1TQxJ8JzAp/2+XaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iH1BiLMska++rh+V1huD+UmhUHUXo7OzHNHksomOg+g+5Ve4jYx/3G8QbQgt7Zfck
         sayczo26M7wDcL6jex+mdfO45jU4+f9WZ9KwCyjRzXqRhUVoUnMOnJdqdn5/0r/vgQ
         0B65FmZxRSEbZOl1PCV7Rjo8gBwlgqlIr5CklqbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/201] net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow
Date:   Wed, 27 Jul 2022 18:09:34 +0200
Message-Id: <20220727161029.846082694@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 95e1307cfda2..b4f83c865568 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -844,19 +844,10 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
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
 
@@ -3325,6 +3316,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
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
index 11e1055e8260..9f5cac4000da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -815,7 +815,13 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
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



