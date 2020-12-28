Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD542E40AB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439292AbgL1OzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441353AbgL1ORI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AABD2063A;
        Mon, 28 Dec 2020 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164986;
        bh=2INsDK7lqkSg3qazQFdIuHgCD5MgJnrY+vhwyOKpaRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWPw9q7G9eTeThJHjq9mPGv/vYwvFUw2EXcniKB2tAAheAqtEvNMDTiTojBt/94x6
         +mhymKH3Cjo0a/00+lnwr5CgiBdXfjV+/AfdeG+PtZyAN29VSr9HRRPaRi53vziYX3
         F9kwFKOPARPQHfC8otNEy8sKM5G4BWOcZeAvIIiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 369/717] coresight: remove broken __exit annotations
Date:   Mon, 28 Dec 2020 13:46:07 +0100
Message-Id: <20201228125038.686468376@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 45fe7befe0db5e61cd3c846315f0ac48541e8445 ]

Functions that are annotated __exit are discarded for built-in drivers,
but the .remove callback in a device driver must still be kept around
to allow bind/unbind operations.

There is now a linker warning for the discarded symbol references:

`tmc_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-tmc-core.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-tmc-core.o
`tpiu_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-tpiu.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-tpiu.o
`etb_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-etb10.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-etb10.o
`static_funnel_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-funnel.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-funnel.o
`dynamic_funnel_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-funnel.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-funnel.o
`static_replicator_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-replicator.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-replicator.o
`dynamic_replicator_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-replicator.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-replicator.o
`catu_remove' referenced in section `.data' of drivers/hwtracing/coresight/coresight-catu.o: defined in discarded section `.exit.text' of drivers/hwtracing/coresight/coresight-catu.o

Remove all those annotations.

Fixes: 8b0cf82677d1 ("coresight: stm: Allow to build coresight-stm as a module")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201208182651.1597945-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c       | 2 +-
 drivers/hwtracing/coresight/coresight-cti-core.c   | 2 +-
 drivers/hwtracing/coresight/coresight-etb10.c      | 2 +-
 drivers/hwtracing/coresight/coresight-etm3x-core.c | 4 ++--
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 4 ++--
 drivers/hwtracing/coresight/coresight-funnel.c     | 6 +++---
 drivers/hwtracing/coresight/coresight-replicator.c | 6 +++---
 drivers/hwtracing/coresight/coresight-stm.c        | 2 +-
 drivers/hwtracing/coresight/coresight-tmc-core.c   | 2 +-
 drivers/hwtracing/coresight/coresight-tpiu.c       | 2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index 99430f6cf5a5d..a61313f320bda 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -567,7 +567,7 @@ out:
 	return ret;
 }
 
-static int __exit catu_remove(struct amba_device *adev)
+static int catu_remove(struct amba_device *adev)
 {
 	struct catu_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index d28eae93e55c8..61dbc1afd8da5 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -836,7 +836,7 @@ static void cti_device_release(struct device *dev)
 	if (drvdata->csdev_release)
 		drvdata->csdev_release(dev);
 }
-static int __exit cti_remove(struct amba_device *adev)
+static int cti_remove(struct amba_device *adev)
 {
 	struct cti_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
index 1b320ab581caf..0cf6f0b947b6f 100644
--- a/drivers/hwtracing/coresight/coresight-etb10.c
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -803,7 +803,7 @@ err_misc_register:
 	return ret;
 }
 
-static int __exit etb_remove(struct amba_device *adev)
+static int etb_remove(struct amba_device *adev)
 {
 	struct etb_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index 47f610b1c2b18..5bf5a5a4ce6d1 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -902,14 +902,14 @@ static int etm_probe(struct amba_device *adev, const struct amba_id *id)
 	return 0;
 }
 
-static void __exit clear_etmdrvdata(void *info)
+static void clear_etmdrvdata(void *info)
 {
 	int cpu = *(int *)info;
 
 	etmdrvdata[cpu] = NULL;
 }
 
-static int __exit etm_remove(struct amba_device *adev)
+static int etm_remove(struct amba_device *adev)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e516e5b879e3a..95b54b0a36252 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1570,14 +1570,14 @@ static struct amba_cs_uci_id uci_id_etm4[] = {
 	}
 };
 
-static void __exit clear_etmdrvdata(void *info)
+static void clear_etmdrvdata(void *info)
 {
 	int cpu = *(int *)info;
 
 	etmdrvdata[cpu] = NULL;
 }
 
-static int __exit etm4_remove(struct amba_device *adev)
+static int etm4_remove(struct amba_device *adev)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
index af40814ce5603..3fc6c678b51d8 100644
--- a/drivers/hwtracing/coresight/coresight-funnel.c
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -274,7 +274,7 @@ out_disable_clk:
 	return ret;
 }
 
-static int __exit funnel_remove(struct device *dev)
+static int funnel_remove(struct device *dev)
 {
 	struct funnel_drvdata *drvdata = dev_get_drvdata(dev);
 
@@ -328,7 +328,7 @@ static int static_funnel_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit static_funnel_remove(struct platform_device *pdev)
+static int static_funnel_remove(struct platform_device *pdev)
 {
 	funnel_remove(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -370,7 +370,7 @@ static int dynamic_funnel_probe(struct amba_device *adev,
 	return funnel_probe(&adev->dev, &adev->res);
 }
 
-static int __exit dynamic_funnel_remove(struct amba_device *adev)
+static int dynamic_funnel_remove(struct amba_device *adev)
 {
 	return funnel_remove(&adev->dev);
 }
diff --git a/drivers/hwtracing/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
index 62afdde0e5eab..38008aca2c0f4 100644
--- a/drivers/hwtracing/coresight/coresight-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -291,7 +291,7 @@ out_disable_clk:
 	return ret;
 }
 
-static int __exit replicator_remove(struct device *dev)
+static int replicator_remove(struct device *dev)
 {
 	struct replicator_drvdata *drvdata = dev_get_drvdata(dev);
 
@@ -318,7 +318,7 @@ static int static_replicator_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit static_replicator_remove(struct platform_device *pdev)
+static int static_replicator_remove(struct platform_device *pdev)
 {
 	replicator_remove(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -388,7 +388,7 @@ static int dynamic_replicator_probe(struct amba_device *adev,
 	return replicator_probe(&adev->dev, &adev->res);
 }
 
-static int __exit dynamic_replicator_remove(struct amba_device *adev)
+static int dynamic_replicator_remove(struct amba_device *adev)
 {
 	return replicator_remove(&adev->dev);
 }
diff --git a/drivers/hwtracing/coresight/coresight-stm.c b/drivers/hwtracing/coresight/coresight-stm.c
index b0ad912651a99..587c1d7f25208 100644
--- a/drivers/hwtracing/coresight/coresight-stm.c
+++ b/drivers/hwtracing/coresight/coresight-stm.c
@@ -951,7 +951,7 @@ stm_unregister:
 	return ret;
 }
 
-static int __exit stm_remove(struct amba_device *adev)
+static int stm_remove(struct amba_device *adev)
 {
 	struct stm_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-tmc-core.c b/drivers/hwtracing/coresight/coresight-tmc-core.c
index 5653e0945c74b..8169dff5a9f6a 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-core.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-core.c
@@ -559,7 +559,7 @@ out:
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 }
 
-static int __exit tmc_remove(struct amba_device *adev)
+static int tmc_remove(struct amba_device *adev)
 {
 	struct tmc_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
diff --git a/drivers/hwtracing/coresight/coresight-tpiu.c b/drivers/hwtracing/coresight/coresight-tpiu.c
index 566c57e035961..5b35029461a0c 100644
--- a/drivers/hwtracing/coresight/coresight-tpiu.c
+++ b/drivers/hwtracing/coresight/coresight-tpiu.c
@@ -173,7 +173,7 @@ static int tpiu_probe(struct amba_device *adev, const struct amba_id *id)
 	return PTR_ERR(drvdata->csdev);
 }
 
-static int __exit tpiu_remove(struct amba_device *adev)
+static int tpiu_remove(struct amba_device *adev)
 {
 	struct tpiu_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
-- 
2.27.0



