Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC574076E9
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhIKNNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235972AbhIKNNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337796108B;
        Sat, 11 Sep 2021 13:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365924;
        bh=6n8ZrpCjHK/0owdGbK700/HKwHqdWGyYWY9zC/fI8/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZpNQmPpsIRaAq4/nFQaE/oF5AFcvMW07E2eaWQsHu0b53lt+X8ftgGsfQrc4e6hM
         B3PgMh+q9fruznPRbdCDnHsmh6/q/7IL9yetwQ/e9aQ1vGOqUvTYrTMDmpXjnTpEwP
         Q6OcXJmhy7RbvvyqeAB0vkJRm+7kuwQVS2Biq2WeIV8Li7i+2+H31UnEOBvPGi/iB7
         4Onho+JKkNa3KdA0i0wgN9JW8/sO8KvRMDlxyvEJPFJ+N43cGpyE+s9Y0hi+5BpZpY
         WBviQMSUixWZB5Mqt7RtB9V2zazmxfB+0DDTgcsEf2HVQySuuTDk6PasrtF+RgQQYi
         L5OT1/D8EMqnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/32] PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()
Date:   Sat, 11 Sep 2021 09:11:27 -0400
Message-Id: <20210911131149.284397-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
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

