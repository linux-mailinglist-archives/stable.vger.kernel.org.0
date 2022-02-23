Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64024C0635
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiBWAdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbiBWAdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:33:55 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF8B5C657;
        Tue, 22 Feb 2022 16:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645576409; x=1677112409;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sLOP+uYqXE60s3px7qOY/JHhr42q3bbt4UwDpjHqx5w=;
  b=DDUWmmThNdkSoAGMC/4XSJaghL5zcvYsyC1gZqaO4YFfuKq10ZAMfYxx
   jSQiuwWHwDm9u4n3D3867QWoAL9V/AO0ZFGg3lmlToLAdufONeVW4Sqg2
   SwheyIBd0DfWfpjHtd4ee5SQv3y2UJuTvW81i3B6/0S1cHOvATD/dLSmJ
   xBAJ+rFStOS9JeqnhybpAGnyB1nTp51+67s6WrZ3HfgvATh85bcY8Y3vG
   P5gkqlomvV1J9ZeMbioyDtq3h6NmnHckRFvvixrFcIK7h1xOCKOvepA7n
   mkPmx3N+x9Dosc26GBu0neWmF8fxF7TQxcT+UG+NH+nLQP4i1H3xxsJIe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="232470442"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="232470442"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:33:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="490994834"
Received: from cliu38-mobl3.sh.intel.com ([10.239.147.47])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2022 16:33:27 -0800
From:   Chuansheng Liu <chuansheng.liu@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        rafael@kernel.org, srinivas.pandruvada@linux.intel.com
Subject: [PATCH] thermal: int340x: fix memory leak in int3400_notify()
Date:   Wed, 23 Feb 2022 08:20:24 +0800
Message-Id: <20220223002024.55026-1-chuansheng.liu@intel.com>
X-Mailer: git-send-email 2.25.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is easy to hit the below memory leaks in my TigerLake platform:

--
unreferenced object 0xffff927c8b91dbc0 (size 32):
  comm "kworker/0:2", pid 112, jiffies 4294893323 (age 83.604s)
  hex dump (first 32 bytes):
    4e 41 4d 45 3d 49 4e 54 33 34 30 30 20 54 68 65  NAME=INT3400 The
    72 6d 61 6c 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  rmal.kkkkkkkkkk.
  backtrace:
    [<ffffffff9c502c3e>] __kmalloc_track_caller+0x2fe/0x4a0
    [<ffffffff9c7b7c15>] kvasprintf+0x65/0xd0
    [<ffffffff9c7b7d6e>] kasprintf+0x4e/0x70
    [<ffffffffc04cb662>] int3400_notify+0x82/0x120 [int3400_thermal]
    [<ffffffff9c8b7358>] acpi_ev_notify_dispatch+0x54/0x71
    [<ffffffff9c88f1a7>] acpi_os_execute_deferred+0x17/0x30
    [<ffffffff9c2c2c0a>] process_one_work+0x21a/0x3f0
    [<ffffffff9c2c2e2a>] worker_thread+0x4a/0x3b0
    [<ffffffff9c2cb4dd>] kthread+0xfd/0x130
    [<ffffffff9c201c1f>] ret_from_fork+0x1f/0x30
---

Fix it by calling kfree() accordingly.

Fixes: 38e44da59130 ("thermal: int3400_thermal: process "thermal table
changed" event")

Cc: linux-pm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: rafael@kernel.org
Cc: srinivas.pandruvada@linux.intel.com
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 72acb1f61849..4f478812cb51 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -404,6 +404,10 @@ static void int3400_notify(acpi_handle handle,
 	thermal_prop[3] = kasprintf(GFP_KERNEL, "EVENT=%d", therm_event);
 	thermal_prop[4] = NULL;
 	kobject_uevent_env(&priv->thermal->device.kobj, KOBJ_CHANGE, thermal_prop);
+	kfree(thermal_prop[0]);
+	kfree(thermal_prop[1]);
+	kfree(thermal_prop[2]);
+	kfree(thermal_prop[3]);
 }
 
 static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
-- 
2.25.0.rc2

