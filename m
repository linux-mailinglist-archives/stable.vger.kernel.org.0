Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450AB1F2ADC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgFIAMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbgFHXTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C327B20814;
        Mon,  8 Jun 2020 23:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658379;
        bh=eVIpr8/ofo5takKWsPqMw/Pep/g6XXz7jFfvgEA1vCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXO6zPlrjp4O3jDi/ibgXtprthp4fj9qT5rByDQdbFbe0Jsrdq9MHh5Fw+iBV16pj
         SRKMM1HkgKb8H9uz4F/kzzvprWnrAl1O6cwKWkY3aPBJkoN26AWlHuka/1aOR0gVJc
         tU4tgLYYVGqd22I1vATNYJrqKqEg/LLNBPF0QfUo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 041/175] pmu/smmuv3: Clear IRQ affinity hint on device removal
Date:   Mon,  8 Jun 2020 19:16:34 -0400
Message-Id: <20200608231848.3366970-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2f8787276d9b..3269232ff570 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -815,7 +815,7 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(dev, "Error %d registering hotplug, PMU @%pa\n",
 			err, &res_0->start);
-		return err;
+		goto out_clear_affinity;
 	}
 
 	err = perf_pmu_register(&smmu_pmu->pmu, name, -1);
@@ -834,6 +834,8 @@ static int smmu_pmu_probe(struct platform_device *pdev)
 
 out_unregister:
 	cpuhp_state_remove_instance_nocalls(cpuhp_state_num, &smmu_pmu->node);
+out_clear_affinity:
+	irq_set_affinity_hint(smmu_pmu->irq, NULL);
 	return err;
 }
 
@@ -843,6 +845,7 @@ static int smmu_pmu_remove(struct platform_device *pdev)
 
 	perf_pmu_unregister(&smmu_pmu->pmu);
 	cpuhp_state_remove_instance_nocalls(cpuhp_state_num, &smmu_pmu->node);
+	irq_set_affinity_hint(smmu_pmu->irq, NULL);
 
 	return 0;
 }
-- 
2.25.1

