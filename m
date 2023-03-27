Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D7F6CAE07
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjC0S7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 14:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjC0S7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 14:59:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B51BDF;
        Mon, 27 Mar 2023 11:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679943575; x=1711479575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J8mZo/TbVxWX/uWjIzyBbonjfTUCyWDEP+6ELuZQr48=;
  b=A3tysXmwgWwYKsDvMcRTd9dlG1j/7Ty+aSr52KezfYs0QkMfHxuh1Een
   009dkN5pBaZA4X/fJGpP2JQsblq+iZ81lpIAYece14NWmxo6FTD9NUJm6
   5rtyXfVd87O+/VmcQ7SPhKOpp4BeXPWLzhtFd+4NtYCsJ6P3GDTsZXUrZ
   NYqh1SvRnk5SzLjP1uttxOdy01yKuaW0V0+5Fkh8Dbzicaa9RiR0DwHD9
   of8OwNgF35i3JpK7qJDNB790mKSJIcd3QZ+KKMIt3+FebgmN4wI7axNOu
   kipK/mbS+p6KowBvYrzNeoQoSJKwtdmlmeg3+6iAtpx49XZOlj9rP1Esr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="402963111"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="402963111"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 11:59:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="686071006"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="686071006"
Received: from svunnam-mobl.amr.corp.intel.com (HELO tmalhotr-NUC8i7HVKVA.amr.corp.intel.com) ([10.212.92.58])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 11:59:34 -0700
From:   Tanu Malhotra <tanu.malhotra@intel.com>
To:     srinivas.pandruvada@linux.intel.com, jikos@kernel.org
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        even.xu@intel.com, Tanu Malhotra <tanu.malhotra@intel.com>,
        stable@vger.kernel.org, Shaunak Saha <shaunak.saha@intel.com>
Subject: [PATCH v2] HID: intel-ish-hid: Fix kernel panic during warm reset
Date:   Mon, 27 Mar 2023 11:58:38 -0700
Message-Id: <20230327185838.2527560-1-tanu.malhotra@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During warm reset device->fw_client is set to NULL. If a bus driver is
registered after this NULL setting and before new firmware clients are
enumerated by ISHTP, kernel panic will result in the function
ishtp_cl_bus_match(). This is because of reference to
device->fw_client->props.protocol_name.

ISH firmware after getting successfully loaded, sends a warm reset
notification to remove all clients from the bus and sets
device->fw_client to NULL. Until kernel v5.15, all enabled ISHTP kernel
module drivers were loaded right after any of the first ISHTP device was
registered, regardless of whether it was a matched or an unmatched
device. This resulted in all drivers getting registered much before the
warm reset notification from ISH.

Starting kernel v5.16, this issue got exposed after the change was
introduced to load only bus drivers for the respective matching devices.
In this scenario, cros_ec_ishtp device and cros_ec_ishtp driver are
registered after the warm reset device fw_client NULL setting.
cros_ec_ishtp driver_register() triggers the callback to
ishtp_cl_bus_match() to match ISHTP driver to the device and causes kernel
panic in guid_equal() when dereferencing fw_client NULL pointer to get
protocol_name.

Fixes: f155dfeaa4ee ("platform/x86: isthp_eclite: only load for matching devices")
Fixes: facfe0a4fdce ("platform/chrome: chros_ec_ishtp: only load for matching devices")
Fixes: 0d0cccc0fd83 ("HID: intel-ish-hid: hid-client: only load for matching devices")
Fixes: 44e2a58cb880 ("HID: intel-ish-hid: fw-loader: only load for matching devices")
Cc: <stable@vger.kernel.org> # 5.16+
Signed-off-by: Tanu Malhotra <tanu.malhotra@intel.com>
Tested-by: Shaunak Saha <shaunak.saha@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
v2:
- Cleaned up coding indentation
- Updated commit description
- Added stable mailing list to Cc
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 81385ab37fa9..7fc738a22375 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -241,8 +241,8 @@ static int ishtp_cl_bus_match(struct device *dev, struct device_driver *drv)
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(drv);
 
-	return guid_equal(&driver->id[0].guid,
-			  &device->fw_client->props.protocol_name);
+	return(device->fw_client ? guid_equal(&driver->id[0].guid,
+	       &device->fw_client->props.protocol_name) : 0);
 }
 
 /**

base-commit: 1e760fa3596e8c7f08412712c168288b79670d78
-- 
2.34.1

