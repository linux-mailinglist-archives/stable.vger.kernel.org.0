Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C356948D9
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBMOxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjBMOxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6EA17145
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4014B81261
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC50C433EF;
        Mon, 13 Feb 2023 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300018;
        bh=843X6a0S1AGREtOdyWikWFETqQ88Wk6pBu5A/EAcnIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFUG7LI+/Y7SjDnj28rawg+PDJfvqDKMqSSpeAZ4+VxoKwnK5xbbgGiOXIER+OWl6
         y100FBpCR9UkEpH1Zb4No8FtEVr6NdJYzejfhltvNH26IXANQ+2erquTUF0DkCUHGl
         zMcHo/flaMX+w9BbUC3x+Ixq9Ey3oFC3w/X5/jPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Michal Simek <michal.simek@amd.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/114] net: macb: Perform zynqmp dynamic configuration only for SGMII interface
Date:   Mon, 13 Feb 2023 15:47:42 +0100
Message-Id: <20230213144743.547561425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit c9011b028e956c3b6baa6f131d9eec43e4e52020 ]

In zynqmp platforms where firmware supports dynamic SGMII configuration
but has other non-SGMII ethernet devices, it fails them with no packets
received at the RX interface.

To fix this behaviour perform SGMII dynamic configuration only
for the SGMII phy interface.

Fixes: 32cee7818111 ("net: macb: Add zynqmp SGMII dynamic configuration support")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reported-by: Michal Simek <michal.simek@amd.com>
Tested-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 31 ++++++++++++------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 300f47ca42e3e..e255780f3867c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4614,25 +4614,26 @@ static int init_reset_optional(struct platform_device *pdev)
 		if (ret)
 			return dev_err_probe(&pdev->dev, ret,
 					     "failed to init SGMII PHY\n");
-	}
 
-	ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
-	if (!ret) {
-		u32 pm_info[2];
+		ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
+		if (!ret) {
+			u32 pm_info[2];
+
+			ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
+							 pm_info, ARRAY_SIZE(pm_info));
+			if (ret) {
+				dev_err(&pdev->dev, "Failed to read power management information\n");
+				goto err_out_phy_exit;
+			}
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+			if (ret)
+				goto err_out_phy_exit;
 
-		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
-						 pm_info, ARRAY_SIZE(pm_info));
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to read power management information\n");
-			goto err_out_phy_exit;
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+			if (ret)
+				goto err_out_phy_exit;
 		}
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
-		if (ret)
-			goto err_out_phy_exit;
 
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
-		if (ret)
-			goto err_out_phy_exit;
 	}
 
 	/* Fully reset controller at hardware level if mapped in device tree */
-- 
2.39.0



