Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F2247602
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732290AbgHQTcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbgHQPbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1793022CBB;
        Mon, 17 Aug 2020 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678292;
        bh=Uln+deEU/tSr+Yu9jrfHo1h8aju24WYtRq6HtS+xw9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQF39twQaMxN62jfnxRYS0c9L6l/unxoEddEkib6hT8j+J7kPKzBiTNgBeWQpSDhf
         jiWN0OZPlUGJIoUPVJwRG7afkKh1hZF9ou58T0Y0fKRj802q+4kPSjsoCRGIKMJ0lS
         H+hSuPBaLNL+lVD2j6mA6MQ3zeNACO+VLct1YX+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 282/464] PCI: rcar: Fix runtime PM imbalance on error
Date:   Mon, 17 Aug 2020 17:13:55 +0200
Message-Id: <20200817143847.263731460@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a68e06e729b1b06c50ee52917d6b825b43e7d269 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when the call returns an error code. Thus a corresponding decrement is
needed on the error handling path to keep the counter balanced.

Link: https://lore.kernel.org/r/20200709064356.8800-1-dinghao.liu@zju.edu.cn
Fixes: 0df6150e7ceb ("PCI: rcar: Use runtime PM to control controller clock")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index d210a36561be2..060c24f5221e2 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -986,7 +986,7 @@ static int rcar_pcie_probe(struct platform_device *pdev)
 	err = pm_runtime_get_sync(pcie->dev);
 	if (err < 0) {
 		dev_err(pcie->dev, "pm_runtime_get_sync failed\n");
-		goto err_pm_disable;
+		goto err_pm_put;
 	}
 
 	err = rcar_pcie_get_resources(host);
@@ -1057,8 +1057,6 @@ static int rcar_pcie_probe(struct platform_device *pdev)
 
 err_pm_put:
 	pm_runtime_put(dev);
-
-err_pm_disable:
 	pm_runtime_disable(dev);
 	pci_free_resource_list(&host->resources);
 
-- 
2.25.1



