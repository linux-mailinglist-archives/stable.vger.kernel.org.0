Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D34F2A42
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiDEI2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiDEIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DCD113;
        Tue,  5 Apr 2022 01:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F71760AFB;
        Tue,  5 Apr 2022 08:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C4CC385A0;
        Tue,  5 Apr 2022 08:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146648;
        bh=MSqhLQSb/9SfAZGvAv8ZuYkH9K9StA+EANxqTLmH0Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBn7ZOjF9o1wPY1iJ/w2idxox56ZTKUT8dGfzg5pOfG/j+7wD2u7fw0UPTVyk1d0w
         a4WrENv1dP1Xa/xco2e1HS8H0vgK594VWcyYBW3dsbN6fYkXdNSX5N8Q7gwVcr7Un4
         1363WlgsO6E9cacRYrZXCTTATSJNvdVriSR6om64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Subject: [PATCH 5.17 0799/1126] net: stmmac: dwmac-qcom-ethqos: Enable RGMII functional clock on resume
Date:   Tue,  5 Apr 2022 09:25:46 +0200
Message-Id: <20220405070431.024317620@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit ffba2123e1714a27e9362fda57c42155dda37efc ]

When the Qualcomm ethqos driver is properly described in its associated
GDSC power-domain, the hardware will be powered down and loose its state
between qcom_ethqos_probe() and stmmac_init_dma_engine().

The result of this is that the functional clock from the RGMII IO macro
is no longer provides and the DMA software reset in dwmac4_dma_reset()
will time out, due to lacking clock signal.

Re-enable the functional clock, as part of the Qualcomm specific clock
enablement sequence to avoid this problem.

The final clock configuration will be adjusted by ethqos_fix_mac_speed()
once the link is being brought up.

Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-and-reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Link: https://lore.kernel.org/r/20220323033255.2282930-1-bjorn.andersson@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 2ffa0a11eea5..569683f33804 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -460,6 +460,13 @@ static int ethqos_clks_config(void *priv, bool enabled)
 			dev_err(&ethqos->pdev->dev, "rgmii_clk enable failed\n");
 			return ret;
 		}
+
+		/* Enable functional clock to prevent DMA reset to timeout due
+		 * to lacking PHY clock after the hardware block has been power
+		 * cycled. The actual configuration will be adjusted once
+		 * ethqos_fix_mac_speed() is invoked.
+		 */
+		ethqos_set_func_clk_en(ethqos);
 	} else {
 		clk_disable_unprepare(ethqos->rgmii_clk);
 	}
-- 
2.34.1



