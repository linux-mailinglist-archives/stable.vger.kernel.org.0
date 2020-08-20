Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D724BB9A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgHTMbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgHTJu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED7B82067C;
        Thu, 20 Aug 2020 09:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917028;
        bh=wgDKKFPKPOLf1Qb3wYtpJbDdGY4QsxLtEopvgmu24PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eni6ptf3sR+H+wJ/CGv2PtFm1GLOb1lVWzrPWTvU1LL05gWOlT7pNcUiNd55jl9Jd
         s4OsL0QlxPumFhUwHdIOzuFBRhB1ENLc8ooH2PZhkog+5UYtWgHy870rZwFLVeYMBB
         Yq4R6do4T53L1WrSUyaVyeeqbKkkYEaNYxgHwrbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>, Timur Tabi <timur@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/152] net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init
Date:   Thu, 20 Aug 2020 11:21:37 +0200
Message-Id: <20200820091600.467284943@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 50caa777a3a24d7027748e96265728ce748b41ef ]

Fix the missing clk_disable_unprepare() before return
from emac_clks_phase1_init() in the error handling case.

Fixes: b9b17debc69d ("net: emac: emac gigabit ethernet controller driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Timur Tabi <timur@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/emac/emac.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index c84ab052ef265..3eee8df359a12 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -485,13 +485,24 @@ static int emac_clks_phase1_init(struct platform_device *pdev,
 
 	ret = clk_prepare_enable(adpt->clk[EMAC_CLK_CFG_AHB]);
 	if (ret)
-		return ret;
+		goto disable_clk_axi;
 
 	ret = clk_set_rate(adpt->clk[EMAC_CLK_HIGH_SPEED], 19200000);
 	if (ret)
-		return ret;
+		goto disable_clk_cfg_ahb;
+
+	ret = clk_prepare_enable(adpt->clk[EMAC_CLK_HIGH_SPEED]);
+	if (ret)
+		goto disable_clk_cfg_ahb;
 
-	return clk_prepare_enable(adpt->clk[EMAC_CLK_HIGH_SPEED]);
+	return 0;
+
+disable_clk_cfg_ahb:
+	clk_disable_unprepare(adpt->clk[EMAC_CLK_CFG_AHB]);
+disable_clk_axi:
+	clk_disable_unprepare(adpt->clk[EMAC_CLK_AXI]);
+
+	return ret;
 }
 
 /* Enable clocks; needs emac_clks_phase1_init to be called before */
-- 
2.25.1



