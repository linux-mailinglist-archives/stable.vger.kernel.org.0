Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39A731EEC
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfFANkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfFANUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:20:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EFD2272F8;
        Sat,  1 Jun 2019 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395244;
        bh=jfPQCmUydba2zcQZEEaw0J1fCLxruIlh+oTFwfSiTCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjTyuBURbFG5ea/RBKZkZgrfSfq9u0VO88O8pZWDetwPVs0YNo7g6evSdtc2bfTx4
         GqsHo2JzaWjeXPhmmtO8UA1R8lZ5J9/VqnC12rWBAHAZ2VOJM3kEUtoNu67tmGiRpR
         rnSTQM70lTxilhfMyEteOGhbkbcxWbJQ4gOttMNs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiada Wang <jiada_wang@mentor.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 022/173] thermal: rcar_gen3_thermal: disable interrupt in .remove
Date:   Sat,  1 Jun 2019 09:16:54 -0400
Message-Id: <20190601131934.25053-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

[ Upstream commit 63f55fcea50c25ae5ad45af92d08dae3b84534c2 ]

Currently IRQ remains enabled after .remove, later if device is probed,
IRQ is requested before .thermal_init, this may cause IRQ function be
called before device is initialized.

this patch disables interrupt in .remove, to ensure irq function
only be called after device is fully initialized.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 75786cc8e2f91..0a0562551611b 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -330,6 +330,9 @@ MODULE_DEVICE_TABLE(of, rcar_gen3_thermal_dt_ids);
 static int rcar_gen3_thermal_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct rcar_gen3_thermal_priv *priv = dev_get_drvdata(dev);
+
+	rcar_thermal_irq_set(priv, false);
 
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
-- 
2.20.1

