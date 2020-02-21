Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB093167660
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbgBUIdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732295AbgBUILK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A140920578;
        Fri, 21 Feb 2020 08:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272670;
        bh=+fwgImkEezDVmS4t4jTfRR0PxOi7aPqrYXalgbjRkDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IO5BzaCIvS6RmR0VFFJEX/lJOuxifqXFOTzuJq8FLUn67VdV0Wcv/jJlY0FrnToIs
         nciy/y9v81FkMejQ/n2CUkLjlTddTggLK3WN1kGnVqn+Px3R7DVHOOUVfYYWWzjr/B
         aiBMcC7AkBJdLDlGWf0wOKg7YI9bLVKW8SQKm7Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/344] perf/imx_ddr: Fix cpu hotplug state cleanup
Date:   Fri, 21 Feb 2020 08:40:30 +0100
Message-Id: <20200221072410.239585109@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2a3966d059e70..0e51baa48b149 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -572,13 +572,17 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
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
@@ -612,9 +616,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
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
@@ -625,6 +630,7 @@ static int ddr_perf_remove(struct platform_device *pdev)
 	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
 
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
+	cpuhp_remove_multi_state(pmu->cpuhp_state);
 	irq_set_affinity_hint(pmu->irq, NULL);
 
 	perf_pmu_unregister(&pmu->pmu);
-- 
2.20.1



