Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16CF27CAD2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgI2MW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbgI2LfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A1F23C84;
        Tue, 29 Sep 2020 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378921;
        bh=casV5YDo5of5191kk54tT26Mx6z9poX2mhDvNHwzyZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD8DYScpbOeXKAqTMP6pOJZQRuVgVPPOMQDETV0FAknp6ZFgXKdb7PL3f+MJVrANH
         SaX3QbtpR3MAitjyPQE003EFgh0iZerU/0pSGZfYmc9gJL6A/i5Ds3pHm9jMCnqaE4
         akVj9Gy+OXg0fQOjrzKeFoCo6SOapxK0mEMibHEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/245] PCI: tegra: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:39 +0200
Message-Id: <20200929105956.124803857@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



