Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB24F26EFF6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgIRCjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbgIRCL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 777F623119;
        Fri, 18 Sep 2020 02:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395116;
        bh=casV5YDo5of5191kk54tT26Mx6z9poX2mhDvNHwzyZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKlJHAlsYJayFos9Kgm+Pt57lzGeW252QW8ZEUmT2dvCviGksZKMHHZIiwsFrdeGg
         5cb+nBWDiZgZ/4uus7szDIivY4rjjS4R4RbMoGsqOhqSPwX5PyXqSKCQEuvOi//iPv
         atAiYb3KLzT6+8InUJoH5M1FgltXyXiHfWTBN8lI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 189/206] PCI: tegra: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:07:45 -0400
Message-Id: <20200918020802.2065198-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit fcee90cdf6f3a3a371add04d41528d5ba9c3b411 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Also, call pm_runtime_disable() when pm_runtime_get_sync() returns
an error code.

Link: https://lore.kernel.org/r/20200521024709.2368-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 6f86583605a46..097c02197ec8f 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2400,7 +2400,7 @@ static int tegra_pcie_probe(struct platform_device *pdev)
 	err = pm_runtime_get_sync(pcie->dev);
 	if (err < 0) {
 		dev_err(dev, "fail to enable pcie controller: %d\n", err);
-		goto teardown_msi;
+		goto pm_runtime_put;
 	}
 
 	err = tegra_pcie_request_resources(pcie);
@@ -2440,7 +2440,6 @@ free_resources:
 pm_runtime_put:
 	pm_runtime_put_sync(pcie->dev);
 	pm_runtime_disable(pcie->dev);
-teardown_msi:
 	tegra_pcie_msi_teardown(pcie);
 put_resources:
 	tegra_pcie_put_resources(pcie);
-- 
2.25.1

