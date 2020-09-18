Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65CF26F1E1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgIRCyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbgIRCHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71402395C;
        Fri, 18 Sep 2020 02:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394840;
        bh=sryL45D2Xw7qlPOrIrdtKdTGkdCEVjkzq3LYwn5mTFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGAQZPkKkBnOygwTe6LoOQAc7T00WBemTgQFO+kLjhtBYdzwtGTWgRHG5uWu8z/vC
         vo1tg/RFfyKJunhll8IgeKE3EU8uu88xtcBQDmDtUYm586IhavgeVScXP8AOLAgta/
         MokdSqLY+nFszWkqRSF01uK3slpv0JbF6rjJEdyc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 298/330] PCI: tegra194: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:00:38 -0400
Message-Id: <20200918020110.2063155-298-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

