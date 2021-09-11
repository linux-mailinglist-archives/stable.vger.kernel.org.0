Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D095C4077A3
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbhIKNS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236290AbhIKNQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 410DD6126A;
        Sat, 11 Sep 2021 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366005;
        bh=6n8ZrpCjHK/0owdGbK700/HKwHqdWGyYWY9zC/fI8/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCCFWjDUbYTul1nNoatdMa3AXtZKMYjI3SIBPi5fHdS8o87qQilnD9Y19HDkB+I9+
         AwJs/EDbolc0yR7V90oiGCb432SQXeUjHiUxH0wSR1o6QV8stV75alGPvQ49sjfpAw
         Z19HANu78SJfwnuYekQmXglvMWNQqI/EWd40lysfJB5y772GRR/4JtXDCW5EP/GQVA
         Y0O4THPTH+EXi0H/b7PaBV/sJSjQ3QNmiUYmdTVWjDkzu+jHASHevKur39f8DE9vnF
         pIg5AvoN6+FgoihpIth4h2otKaD6MwesEMNVqAlE4KKzJsLTnStF39P63LLqSXuzqK
         Oq6wItJ9hPk1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/25] PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()
Date:   Sat, 11 Sep 2021 09:12:56 -0400
Message-Id: <20210911131312.285225-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 1e29cd9983eba1b596bc07f94d81d728007f8a25 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Link: https://lore.kernel.org/r/20210408072402.15069-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-ep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-rcar-ep.c b/drivers/pci/controller/pcie-rcar-ep.c
index b4a288e24aaf..c91d85b15129 100644
--- a/drivers/pci/controller/pcie-rcar-ep.c
+++ b/drivers/pci/controller/pcie-rcar-ep.c
@@ -492,9 +492,9 @@ static int rcar_pcie_ep_probe(struct platform_device *pdev)
 	pcie->dev = dev;
 
 	pm_runtime_enable(dev);
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
-		dev_err(dev, "pm_runtime_get_sync failed\n");
+		dev_err(dev, "pm_runtime_resume_and_get failed\n");
 		goto err_pm_disable;
 	}
 
-- 
2.30.2

