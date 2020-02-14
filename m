Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB67B15DD2D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387963AbgBNP4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387960AbgBNP4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68002187F;
        Fri, 14 Feb 2020 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695803;
        bh=Oq3imaSnvk3qp2sKFwj8TW2fh3DxiGumyaDniiv4fZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkj1vR1x/PYwrmfz2CygT9BuDX5T+Gtijp6QC9cT3/Mow0PeofPGMeVaaRs4n+mJC
         LAHYfKVpmFkjI4eulEtRM/czScXs5Y3N1rMe56v6pQZdiu9YBn9zrKwmxsy8AY/O2z
         PFqeq2VrXPYLQoaboyQgELuEA6vyrUUVk4rDgw1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 363/542] perf/imx_ddr: Fix cpu hotplug state cleanup
Date:   Fri, 14 Feb 2020 10:45:55 -0500
Message-Id: <20200214154854.6746-363-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 9ee68b314e9aa63ed11b98beb8a68810b8234dcf ]

This driver allocates a dynamic cpu hotplug state but never releases it.
If reloaded in a loop it will quickly trigger a WARN message:

	"No more dynamic states available for CPU hotplug"

Fix by calling cpuhp_remove_multi_state on remove like several other
perf pmu drivers.

Also fix the cleanup logic on probe error paths: add the missing
cpuhp_remove_multi_state call and properly check the return value from
cpuhp_state_add_instant_nocalls.

Fixes: 9a66d36cc7ac ("drivers/perf: imx_ddr: Add DDR performance counter support to perf")
Acked-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 55083c67b2bb0..95dca2cb52650 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -633,13 +633,17 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
 	if (ret < 0) {
 		dev_err(&pdev->dev, "cpuhp_setup_state_multi failed\n");
-		goto ddr_perf_err;
+		goto cpuhp_state_err;
 	}
 
 	pmu->cpuhp_state = ret;
 
 	/* Register the pmu instance for cpu hotplug */
-	cpuhp_state_add_instance_nocalls(pmu->cpuhp_state, &pmu->node);
+	ret = cpuhp_state_add_instance_nocalls(pmu->cpuhp_state, &pmu->node);
+	if (ret) {
+		dev_err(&pdev->dev, "Error %d registering hotplug\n", ret);
+		goto cpuhp_instance_err;
+	}
 
 	/* Request irq */
 	irq = of_irq_get(np, 0);
@@ -673,9 +677,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 	return 0;
 
 ddr_perf_err:
-	if (pmu->cpuhp_state)
-		cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
-
+	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
+cpuhp_instance_err:
+	cpuhp_remove_multi_state(pmu->cpuhp_state);
+cpuhp_state_err:
 	ida_simple_remove(&ddr_ida, pmu->id);
 	dev_warn(&pdev->dev, "i.MX8 DDR Perf PMU failed (%d), disabled\n", ret);
 	return ret;
@@ -686,6 +691,7 @@ static int ddr_perf_remove(struct platform_device *pdev)
 	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
 
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
+	cpuhp_remove_multi_state(pmu->cpuhp_state);
 	irq_set_affinity_hint(pmu->irq, NULL);
 
 	perf_pmu_unregister(&pmu->pmu);
-- 
2.20.1

