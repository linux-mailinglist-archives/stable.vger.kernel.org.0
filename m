Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB4920CAFE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 00:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgF1WyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 18:54:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:61998 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgF1WyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 18:54:04 -0400
IronPort-SDR: h9yEsLnJoezpJpSOcc/WdBM4iliYfSXUX/1Kczq5Aq/SrFWNvBedAKzjgy7qUN+Q9vw2MRQHDw
 TY9uh3sPfxbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="143356238"
X-IronPort-AV: E=Sophos;i="5.75,293,1589266800"; 
   d="scan'208";a="143356238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2020 15:54:04 -0700
IronPort-SDR: mS6V3u7YQ1AQpjZlma7PckKh208vE9P5+mPv354T5UwOiDcnwb27KqwNUIUBj0RZ1Xfpo/AXrA
 LrelELEawheA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,293,1589266800"; 
   d="scan'208";a="314635248"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2020 15:54:01 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: bus: don't clean driver pointer
Date:   Mon, 29 Jun 2020 01:53:59 +0300
Message-Id: <20200628225359.2185929-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

It's not needed to set driver to NULL in mei_cl_device_remove()
which is bus_type remove() handler as this is done anyway
in __device_release_driver().

Actually this is causing an endless loop in driver_detach()
on ubuntu patched kernel, while removing (rmmod) the mei_hdcp module.
The reason list_empty(&drv->p->klist_devices.k_list) is always not-empty.
as the check is always true in  __device_release_driver()
	if (dev->driver != drv)
		return;

The non upstream patch is causing this behavior, titled:
'vfio -- release device lock before userspace requests'

Nevertheless the fix is correct also for the upstream.

Link: https://patchwork.ozlabs.org/project/ubuntu-kernel/patch/20180912085046.3401-2-apw@canonical.com/
Cc: <stable@vger.kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 8d468e0a950a..f476dbc7252b 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -745,9 +745,8 @@ static int mei_cl_device_remove(struct device *dev)
 
 	mei_cl_bus_module_put(cldev);
 	module_put(THIS_MODULE);
-	dev->driver = NULL;
-	return ret;
 
+	return ret;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *a,
-- 
2.25.4

