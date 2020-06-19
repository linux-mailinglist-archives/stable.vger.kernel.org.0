Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17F820130E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392661AbgFSPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392621AbgFSPT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D102158C;
        Fri, 19 Jun 2020 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579995;
        bh=KeY6RO9Q9yvF6MpjhhdIDXm5QTdCoMZ8/UAisDVoSoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCXopmnKFzu3IQ3zoau2ToH1ZfXBsOQZvhq1Nk9BhVUbs2Hk34Xw4cDbGdY5EQlMG
         CRnxmqMh7/1UVWibb/M+fvG9bNJpOFf0xQFb1JGdYsoI/W/+PKs3eiIKOY1BsHxahB
         A3l6OLpeDeAyIeVsRtfXejYg8OyR319mEHiUM3qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/376] pmu/smmuv3: Clear IRQ affinity hint on device removal
Date:   Fri, 19 Jun 2020 16:29:31 +0200
Message-Id: <20200619141712.862731714@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 10f6cd2af21bb44faab31a50ec3361d7649e5a39 ]

Currently when trying to remove the SMMUv3 PMU module we get a
WARN_ON_ONCE from free_irq(), because the affinity hint set during probe
hasn't been properly cleared.

[  238.878383] WARNING: CPU: 0 PID: 175 at kernel/irq/manage.c:1744 free_irq+0x324/0x358
...
[  238.897263] Call trace:
[  238.897998]  free_irq+0x324/0x358
[  238.898792]  devm_irq_release+0x18/0x28
[  238.899189]  release_nodes+0x1b0/0x228
[  238.899984]  devres_release_all+0x38/0x60
[  238.900779]  device_release_driver_internal+0x10c/0x1d0
[  238.901574]  driver_detach+0x50/0xe0
[  238.902368]  bus_remove_driver+0x5c/0xd8
[  238.903448]  driver_unregister+0x30/0x60
[  238.903958]  platform_driver_unregister+0x14/0x20
[  238.905075]  arm_smmu_pmu_exit+0x1c/0xecc [arm_smmuv3_pmu]
[  238.905547]  __arm64_sys_delete_module+0x14c/0x260
[  238.906342]  el0_svc_common.constprop.0+0x74/0x178
[  238.907355]  do_el0_svc+0x24/0x90
[  238.907932]  el0_sync_handler+0x11c/0x198
[  238.908979]  el0_sync+0x158/0x180

Just like the other perf drivers, clear the affinity hint before
releasing the device.

Fixes: 7d839b4b9e00 ("perf/smmuv3: Add arm64 smmuv3 pmu driver")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Link: https://lore.kernel.org/r/20200422084805.237738-1-jean-philippe@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index f01a57e5a5f3..48e28ef93a70 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -814,7 +814,7 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(dev, "Error %d registering hotplug, PMU @%pa\n",
 			err, &res_0->start);
-		return err;
+		goto out_clear_affinity;
 	}
 
 	err = perf_pmu_register(&smmu_pmu->pmu, name, -1);
@@ -833,6 +833,8 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 
 out_unregister:
 	cpuhp_state_remove_instance_nocalls(cpuhp_state_num, &smmu_pmu->node);
+out_clear_affinity:
+	irq_set_affinity_hint(smmu_pmu->irq, NULL);
 	return err;
 }
 
@@ -842,6 +844,7 @@ static int smmu_pmu_remove(struct platform_device *pdev)
 
 	perf_pmu_unregister(&smmu_pmu->pmu);
 	cpuhp_state_remove_instance_nocalls(cpuhp_state_num, &smmu_pmu->node);
+	irq_set_affinity_hint(smmu_pmu->irq, NULL);
 
 	return 0;
 }
-- 
2.25.1



