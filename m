Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D4407737
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhIKNPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236547AbhIKNON (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA51861247;
        Sat, 11 Sep 2021 13:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365967;
        bh=6n8ZrpCjHK/0owdGbK700/HKwHqdWGyYWY9zC/fI8/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXOsYAudqDfU0ewE/dwkPIPa8RTc7UYgApDuGYFeEmAkMrhHzcqNySKlMY7w2T6wP
         mJt0GMwcDS9Fxye7z29VrgudwbLE0HceH6Vw1GTPnebaTCDZbiX78MUVhbnPlYADj5
         xFQagELZxvoPqFAzOO3bEA2kQMN2CVWGnp0yWujoWXipjWT2ldWYcVHKnjE1jDJCje
         7i+SVdLSDSZLOE2wun+LXcIlFbnkDoKmNHoZ9kFG7cOs09w4rBUKFBdF5bVVT7MGUC
         fmnXAaEfUr74/VNTPgPISUnzugSmQYP8Inpr048VQgIT7yXlhCLZW4KbJugQC2UbJb
         HLdeDWw09Y6Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/29] PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()
Date:   Sat, 11 Sep 2021 09:12:14 -0400
Message-Id: <20210911131233.284800-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
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

