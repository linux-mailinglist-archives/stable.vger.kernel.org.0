Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2B06B9DFB
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCNSNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCNSNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:13:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4022056B;
        Tue, 14 Mar 2023 11:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678817579; x=1710353579;
  h=from:to:cc:subject:date:message-id;
  bh=oqXGmQtiMupxkL7i9Ioi1Rh0YrW847lN+KRJps8IgrY=;
  b=Hiw4bW0mbaTm38GHHcmDYd/O4zjAzT5RKCOfLbRKR39cmWKpJg1haWJw
   xzwq3b23kMhbDlfden0soq/saUBd3QRjTA4SFlMvO9aoA2ncbgwaKYlfx
   s3llTwl+w/V+FTyTz6jxKqfmksnnRtb7+k3ic7Rd7TeNkvW8I3a1kfJ39
   fN+uHxT2V1l4VfnQduig3bBwXa+0V5vshdMbVS2x1/3d7hJztnUiLknhi
   4R97BtB+TZQdDHz4NuPj2J8EdhSke3nEMLlx7WhzLXY5yM9fW8q1Po655
   1YF0xa/rAjl5IlelBF+bWOJ7VMOLsDSDXfcL5S6n0awDBOWKcZHbyenKA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402372584"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="402372584"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008524939"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="1008524939"
Received: from wopr.jf.intel.com ([10.54.75.136])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 11:12:57 -0700
From:   Todd Brandt <todd.e.brandt@intel.com>
To:     linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     todd.e.brandt@linux.intel.com, todd.e.brandt@intel.com,
        srinivas.pandruvada@linux.intel.com, jic23@kernel.org,
        jikos@kernel.org, p.jungkamp@gmx.net, stable@vger.kernel.org
Subject: [PATCH v4] HID:hid-sensor-custom: Fix buffer overrun in device name
Date:   Tue, 14 Mar 2023 11:12:56 -0700
Message-Id: <20230314181256.15283-1-todd.e.brandt@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On some platforms there are some platform devices created with
invalid names. For example: "HID-SENSOR-INT-020b?.39.auto" instead
of "HID-SENSOR-INT-020b.39.auto"

This string include some invalid characters, hence it will fail to
properly load the driver which will handle this custom sensor. Also
it is a problem for some user space tools, which parses the device
names from ftrace and dmesg.

This is because the string, real_usage, is not NULL terminated and
printed with %s to form device name.

To address this, initialize the real_usage string with 0s.

Reported-and-tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217169
Fixes: 98c062e82451 ("HID: hid-sensor-custom: Allow more custom iio sensors")
Cc: stable@vger.kernel.org
Suggested-by: Philipp Jungkamp <p.jungkamp@gmx.net>
Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes in v4:
- add the Fixes line
- add patch version change list
Changes in v3:
- update the changelog
- add proper reviewed/signed/suggested links
Changes in v2:
- update the changelog

 drivers/hid/hid-sensor-custom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-custom.c b/drivers/hid/hid-sensor-custom.c
index 3e3f89e01d81..d85398721659 100644
--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -940,7 +940,7 @@ hid_sensor_register_platform_device(struct platform_device *pdev,
 				    struct hid_sensor_hub_device *hsdev,
 				    const struct hid_sensor_custom_match *match)
 {
-	char real_usage[HID_SENSOR_USAGE_LENGTH];
+	char real_usage[HID_SENSOR_USAGE_LENGTH] = { 0 };
 	struct platform_device *custom_pdev;
 	const char *dev_name;
 	char *c;
-- 
2.17.1

