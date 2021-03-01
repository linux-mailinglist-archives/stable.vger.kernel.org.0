Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8980E328F41
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbhCATsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241744AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83236521B;
        Mon,  1 Mar 2021 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619358;
        bh=QsTUp8bQsQpd8ulOBfV2MbPHQmo7AQ+qGIkRfCUfRSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Thk4ZAVgzVlqU0af9SQSqqDpwDgv3/U32PH7sR1ay+s+DFi2OgMziee+JyrDEDxPA
         4RD1/zC33R9NI0nN0cGTM4wPY8JZByDahvnV2VrXUaNBs45KopMDBgyEje5QGbuN9K
         ymTc2f5Upu26N1KVz13O35puKAYSIbKpKfawVHL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        Douglas Anderson <dianders@chromium.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/663] phy: rockchip-emmc: emmc_phy_init() always return 0
Date:   Mon,  1 Mar 2021 17:10:43 +0100
Message-Id: <20210301161201.409530225@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Ruehl <chris.ruehl@gtsys.com.hk>

[ Upstream commit 39961bd6b70e5a5d7c4b5483ad8e1db6b5765c60 ]

rockchip_emmc_phy_init() return variable is not set with the error value
if clk_get() failed. 'emmcclk' is optional, thus use clk_get_optional()
and if the return value != NULL make error processing and set the
return code accordingly.

Fixes: 52c0624a10cce phy: rockchip-emmc: Set phyctrl_frqsel based on card clock
Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20201210080454.17379-1-chris.ruehl@gtsys.com.hk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-emmc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-emmc.c b/drivers/phy/rockchip/phy-rockchip-emmc.c
index 2dc19ddd120f5..a005fc58bbf02 100644
--- a/drivers/phy/rockchip/phy-rockchip-emmc.c
+++ b/drivers/phy/rockchip/phy-rockchip-emmc.c
@@ -240,15 +240,17 @@ static int rockchip_emmc_phy_init(struct phy *phy)
 	 * - SDHCI driver to get the PHY
 	 * - SDHCI driver to init the PHY
 	 *
-	 * The clock is optional, so upon any error we just set to NULL.
+	 * The clock is optional, using clk_get_optional() to get the clock
+	 * and do error processing if the return value != NULL
 	 *
 	 * NOTE: we don't do anything special for EPROBE_DEFER here.  Given the
 	 * above expected use case, EPROBE_DEFER isn't sensible to expect, so
 	 * it's just like any other error.
 	 */
-	rk_phy->emmcclk = clk_get(&phy->dev, "emmcclk");
+	rk_phy->emmcclk = clk_get_optional(&phy->dev, "emmcclk");
 	if (IS_ERR(rk_phy->emmcclk)) {
-		dev_dbg(&phy->dev, "Error getting emmcclk: %d\n", ret);
+		ret = PTR_ERR(rk_phy->emmcclk);
+		dev_err(&phy->dev, "Error getting emmcclk: %d\n", ret);
 		rk_phy->emmcclk = NULL;
 	}
 
-- 
2.27.0



