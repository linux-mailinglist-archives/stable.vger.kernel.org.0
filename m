Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EC027C641
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbgI2LnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbgI2LnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00BD62076A;
        Tue, 29 Sep 2020 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379791;
        bh=sryL45D2Xw7qlPOrIrdtKdTGkdCEVjkzq3LYwn5mTFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYfcNs3+oLMzemubbeUIgqfsep1cKwPpTKqLYahMBhY7DbH6f/KuUnijZVos+F2oy
         73nNlGRLz0/7b2UmpEJ2P0ydijprFB2bJKA8Qll3BTeLD4cXApddf7d5jAyVf0+Q7R
         bdXlTq/Nhb+lyskPKc/I7iy9yBtrBk7UUM3KLucY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/388] PCI: tegra194: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:20 +0200
Message-Id: <20200929110024.452774500@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 1c1dbb2c02623db18a50c61b175f19aead800b4e ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Link: https://lore.kernel.org/r/20200521031355.7022-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Acked-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index f89f5acee72d4..c06b05ab9f787 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1395,7 +1395,7 @@ static int tegra_pcie_config_rp(struct tegra_pcie_dw *pcie)
 	ret = pinctrl_pm_select_default_state(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to configure sideband pins: %d\n", ret);
-		goto fail_pinctrl;
+		goto fail_pm_get_sync;
 	}
 
 	tegra_pcie_init_controller(pcie);
@@ -1422,9 +1422,8 @@ static int tegra_pcie_config_rp(struct tegra_pcie_dw *pcie)
 
 fail_host_init:
 	tegra_pcie_deinit_controller(pcie);
-fail_pinctrl:
-	pm_runtime_put_sync(dev);
 fail_pm_get_sync:
+	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 	return ret;
 }
-- 
2.25.1



