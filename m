Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D17824BCDF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgHTJnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbgHTJmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721AD20724;
        Thu, 20 Aug 2020 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916561;
        bh=x7Q9qCp+MY8vZ7KOdTXouEdvuAm/+Ue87rUmmdF7JZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbPnqmWw2BPIruDJGh5ZsYsAj6ngcK/TzXU2CVYbZUp4y4bex+hx9blZiEz0HRzmo
         tE66S8Ddtr1OO826iRN8hksREjigzylZU6gYsvbeREgEOwENyiZFSSrpliGwLyq3qv
         ouQyoUq2nrPyXINcNc2YWH5XyILPnjiHD2uf5jZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>, Timur Tabi <timur@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 172/204] net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init
Date:   Thu, 20 Aug 2020 11:21:09 +0200
Message-Id: <20200820091614.797571638@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
index 18b0c7a2d6dcb..90e794c79f667 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -473,13 +473,24 @@ static int emac_clks_phase1_init(struct platform_device *pdev,
 
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



