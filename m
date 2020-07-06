Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A23215B9E
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgGFQOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:14:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:10083 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbgGFQOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:14:01 -0400
IronPort-SDR: Wdu7eipMWV7oDG9Jje/YzHbmk0YUenmcvpXmSdh4EeCK6B8pVkc8EYVyFh91fVmaQqkGQbnQag
 XwUYvg7dIBTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="146520699"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="146520699"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 09:14:00 -0700
IronPort-SDR: Gi2DSiWSBprNalKK8D8dvN91O3X8x7pqiJcnPXfUIMauFhkmGjSkTOZaGBU6uXf9fhpgvjP4XC
 dD1airDlK0KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="283084224"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 09:13:58 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>, stable@vger.kernel.org
Subject: [PATCH 4/4] intel_th: Fix a NULL dereference when hub driver is not loaded
Date:   Mon,  6 Jul 2020 19:13:39 +0300
Message-Id: <20200706161339.55468-5-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706161339.55468-1-alexander.shishkin@linux.intel.com>
References: <20200706161339.55468-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Connecting master to an output port when GTH driver module is not loaded
triggers a NULL dereference:

> RIP: 0010:intel_th_set_output+0x35/0x70 [intel_th]
> Call Trace:
>  ? sth_stm_link+0x12/0x20 [intel_th_sth]
>  stm_source_link_store+0x164/0x270 [stm_core]
>  dev_attr_store+0x17/0x30
>  sysfs_kf_write+0x3e/0x50
>  kernfs_fop_write+0xda/0x1b0
>  __vfs_write+0x1b/0x40
>  vfs_write+0xb9/0x1a0
>  ksys_write+0x67/0xe0
>  __x64_sys_write+0x1a/0x20
>  do_syscall_64+0x57/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Make sure the module in question is loaded and return an error if not.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 39f4034693b7c ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable@vger.kernel.org # v4.4
---
 drivers/hwtracing/intel_th/core.c | 21 ++++++++++++++++++---
 drivers/hwtracing/intel_th/sth.c  |  4 +---
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
index ca232ec565e8..c9ac3dc65113 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -1021,15 +1021,30 @@ int intel_th_set_output(struct intel_th_device *thdev,
 {
 	struct intel_th_device *hub = to_intel_th_hub(thdev);
 	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+	int ret;
 
 	/* In host mode, this is up to the external debugger, do nothing. */
 	if (hub->host_mode)
 		return 0;
 
-	if (!hubdrv->set_output)
-		return -ENOTSUPP;
+	/*
+	 * hub is instantiated together with the source device that
+	 * calls here, so guaranteed to be present.
+	 */
+	hubdrv = to_intel_th_driver(hub->dev.driver);
+	if (!hubdrv || !try_module_get(hubdrv->driver.owner))
+		return -EINVAL;
+
+	if (!hubdrv->set_output) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	ret = hubdrv->set_output(hub, master);
 
-	return hubdrv->set_output(hub, master);
+out:
+	module_put(hubdrv->driver.owner);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(intel_th_set_output);
 
diff --git a/drivers/hwtracing/intel_th/sth.c b/drivers/hwtracing/intel_th/sth.c
index 3a1f4e650378..a1529f571491 100644
--- a/drivers/hwtracing/intel_th/sth.c
+++ b/drivers/hwtracing/intel_th/sth.c
@@ -161,9 +161,7 @@ static int sth_stm_link(struct stm_data *stm_data, unsigned int master,
 {
 	struct sth_device *sth = container_of(stm_data, struct sth_device, stm);
 
-	intel_th_set_output(to_intel_th_device(sth->dev), master);
-
-	return 0;
+	return intel_th_set_output(to_intel_th_device(sth->dev), master);
 }
 
 static int intel_th_sw_init(struct sth_device *sth)
-- 
2.27.0

