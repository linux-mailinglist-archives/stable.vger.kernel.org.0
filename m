Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04197113330
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbfLDSPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbfLDSOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:14:43 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0010E20866;
        Wed,  4 Dec 2019 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483282;
        bh=Ei5tQVIeRmqV5Most0Nt45YuJ+JcLbWOWCdSTlLFX5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/ITI/fIx/DogVGrqv2qWMIW5rsZhbOuJlBypVIWXJvgfDTZbvzJ9mfKjMFfvxYTA
         6ANEZ5rDRU8F9RQiLChhReCig2htDfLsgoUfNRVrTZ3wVkxnyR1nZSoJqIwEQyrloQ
         OJnaupBCdDcDwWVSj4niAdY8foR/z2t6NAq6SmWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 125/125] net: fec: fix clock count mis-match
Date:   Wed,  4 Dec 2019 18:57:10 +0100
Message-Id: <20191204175327.061631078@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit a31eda65ba210741b598044d045480494d0ed52a upstream.

pm_runtime_put_autosuspend in probe will call runtime suspend to
disable clks automatically if CONFIG_PM is defined. (If CONFIG_PM
is not defined, its implementation will be empty, then runtime
suspend will not be called.)

Therefore, we can call pm_runtime_get_sync to runtime resume it
first to enable clks, which matches the runtime suspend. (Only when
CONFIG_PM is defined, otherwise pm_runtime_get_sync will also be
empty, then runtime resume will not be called.)

Then it is fine to disable clks without causing clock count mis-match.

Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/freescale/fec_main.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3530,6 +3530,11 @@ fec_drv_remove(struct platform_device *p
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
@@ -3537,15 +3542,17 @@ fec_drv_remove(struct platform_device *p
 	fec_enet_mii_remove(fep);
 	if (fep->reg_phy)
 		regulator_disable(fep->reg_phy);
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-	clk_disable_unprepare(fep->clk_ahb);
-	clk_disable_unprepare(fep->clk_ipg);
+
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
 	free_netdev(ndev);
 
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 


