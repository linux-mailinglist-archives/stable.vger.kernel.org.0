Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8164C586A89
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiHAMSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiHAMRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC157E308;
        Mon,  1 Aug 2022 04:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C60B81170;
        Mon,  1 Aug 2022 11:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC9C433C1;
        Mon,  1 Aug 2022 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355140;
        bh=MXZi7ngGCR1PaGjCZ9fo8g4JjUSp+/AUMi04FkgXCUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEn/FA7iiyurhxl3W0qV9L3s4Ou5GQAtxXPcxCj3MP6flUm5ZP9FjXEDkXVGSi6bf
         pTY7xaV76RoFWzp0yehAH/tzCJTRZZRqHZbiNFK7G5O2JS52hPR/OS37ZHED81U1T/
         uLPOKcFhcMk+OZ66/+6z3n+I3A6CSs57n5twhTH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 78/88] stmmac: dwmac-mediatek: fix resource leak in probe
Date:   Mon,  1 Aug 2022 13:47:32 +0200
Message-Id: <20220801114141.583663229@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4d3d3a1b244fd54629a6b7047f39a7bbc8d11910 ]

If mediatek_dwmac_clks_config() fails, then call stmmac_remove_config_dt()
before returning.  Otherwise it is a resource leak.

Fixes: fa4b3ca60e80 ("stmmac: dwmac-mediatek: fix clock issue")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YuJ4aZyMUlG6yGGa@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index ca8ab290013c..d42e1afb6521 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -688,18 +688,19 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 
 	ret = mediatek_dwmac_clks_config(priv_plat, true);
 	if (ret)
-		return ret;
+		goto err_remove_config_dt;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-	if (ret) {
-		stmmac_remove_config_dt(pdev, plat_dat);
+	if (ret)
 		goto err_drv_probe;
-	}
 
 	return 0;
 
 err_drv_probe:
 	mediatek_dwmac_clks_config(priv_plat, false);
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
 	return ret;
 }
 
-- 
2.35.1



