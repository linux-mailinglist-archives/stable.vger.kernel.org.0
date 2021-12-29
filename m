Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADA480FBA
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 05:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhL2ExX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 23:53:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:26641 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhL2ExW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 23:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640753602; x=1672289602;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LQtzgGcwFSLX6J66H/wYDpBcVLFBuSzw2YxqoiBSMQ8=;
  b=TlmeW9jde8vB7/+gW3FxgLFYS1vp+Xl56/QiJytJvnvbdPUPxFGjHQQ7
   NKtVMWv9I2R8JiI3IMTjsMAxbYTkQX2DYWd3gpYpqhqdyc4rnRLfIvuyZ
   4M462E872tu6m7+rlmjs0hYoSxg7mY5vcgDTUZuY4+w4WoZc2nd5RKYaS
   fpX59eNq2SrsxQVN2miVN4YV3xRb2mIP7U3g69kazhzzYeL1zFudGcjWc
   1+hGBKS3STROtZt1vrs+jElxCc1nrH9LOrG7GvLUh2+EsSnRoRZ2+hFUi
   od9DAFeUvUxkwWg4iCVAuYSuKzGNPmBDfxS3Y5rtsC2X5phAcT+694rzN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="228767834"
X-IronPort-AV: E=Sophos;i="5.88,244,1635231600"; 
   d="scan'208";a="228767834"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 20:53:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,244,1635231600"; 
   d="scan'208";a="666190320"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 28 Dec 2021 20:53:16 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Kay Sievers <kay.sievers@novell.com>,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] driver core: Fix driver_sysfs_remove() order in really_probe()
Date:   Wed, 29 Dec 2021 12:51:59 +0800
Message-Id: <20211229045159.1731943-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver_sysfs_remove() should always be called after successful
driver_sysfs_add(). Otherwise, NULL pointers will be passed to the
sysfs_remove_link(), where it is decoded as searching sysfs root.

Fixes: 1901fb2604fbc ("Driver core: fix "driver" symlink timing")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/base/dd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..9eaaff2f556c 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -577,14 +577,14 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus->dma_configure) {
 		ret = dev->bus->dma_configure(dev);
 		if (ret)
-			goto probe_failed;
+			goto pinctrl_bind_failed;
 	}
 
 	ret = driver_sysfs_add(dev);
 	if (ret) {
 		pr_err("%s: driver_sysfs_add(%s) failed\n",
 		       __func__, dev_name(dev));
-		goto probe_failed;
+		goto sysfs_failed;
 	}
 
 	if (dev->pm_domain && dev->pm_domain->activate) {
@@ -657,6 +657,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	else if (drv->remove)
 		drv->remove(dev);
 probe_failed:
+	driver_sysfs_remove(dev);
+sysfs_failed:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
@@ -666,7 +668,6 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	arch_teardown_dma_ops(dev);
 	kfree(dev->dma_range_map);
 	dev->dma_range_map = NULL;
-	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
 	if (dev->pm_domain && dev->pm_domain->dismiss)
-- 
2.25.1

