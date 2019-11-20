Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33DC103AB9
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfKTNI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:08:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:58358 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbfKTNI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 08:08:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 05:08:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,221,1571727600"; 
   d="scan'208";a="196848295"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 20 Nov 2019 05:08:25 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 1/3] intel_th: Fix a double put_device() in error path
Date:   Wed, 20 Nov 2019 15:08:04 +0200
Message-Id: <20191120130806.44028-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120130806.44028-1-alexander.shishkin@linux.intel.com>
References: <20191120130806.44028-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
factored out intel_th_subdevice_alloc() from intel_th_populate(), but got
the error path wrong, resulting in two instances of a double put_device()
on a freshly initialized, but not 'added' device.

Fix this by only doing one put_device() in the error path.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
Reported-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14+
---
 drivers/hwtracing/intel_th/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
index d5c1821b31c6..0dfd97bbde9e 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -649,10 +649,8 @@ intel_th_subdevice_alloc(struct intel_th *th,
 	}
 
 	err = intel_th_device_add_resources(thdev, res, subdev->nres);
-	if (err) {
-		put_device(&thdev->dev);
+	if (err)
 		goto fail_put_device;
-	}
 
 	if (subdev->type == INTEL_TH_OUTPUT) {
 		if (subdev->mknode)
@@ -667,10 +665,8 @@ intel_th_subdevice_alloc(struct intel_th *th,
 	}
 
 	err = device_add(&thdev->dev);
-	if (err) {
-		put_device(&thdev->dev);
+	if (err)
 		goto fail_free_res;
-	}
 
 	/* need switch driver to be loaded to enumerate the rest */
 	if (subdev->type == INTEL_TH_SWITCH && !req) {
-- 
2.24.0

