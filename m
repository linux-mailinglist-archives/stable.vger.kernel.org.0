Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B37366C272
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjAPOoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjAPOn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:43:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE0623657;
        Mon, 16 Jan 2023 06:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673878873; x=1705414873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F+uDFJaa32ap3prv7VUFPqZU0SFYlSpH91EjFYxa+vk=;
  b=b3iWgVJqgsQQAWQiYJ1TOVs1D1H4Djitknpo8cDMRCmbawM+8RZf/Aer
   KmG+bpfyOvRYAcJCThYk7hsus1b7U2LC2CMGp0H++hP6LnPOFtkhLwszr
   YHTgXhsoCdT1POc5LKdTo1FoGsCbuhOBdC0yrZH7DYhN6AYSwFwZTLc+j
   PiWC0IO5IiyXHMv7rJQIERvl/CT+kuwO6r86FyUEq/IsdQXRMtdbD9jaY
   px6tV8iF9K42LK4P/VkLCSIsZUwAxiCrq5l11sQQBq8IwHvcY1yJAJ9PI
   hA6iilbwgqgYSgTrCZT+tAtHoyegeevW4tV8SJuvpyiEgZATH0vH4TCvi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312322960"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="312322960"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 06:21:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987817221"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="987817221"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 06:21:11 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org, Ron Lee <ron.lee@intel.com>
Subject: [PATCH 6/7] usb: acpi: add helper to check port lpm capability using acpi _DSM
Date:   Mon, 16 Jan 2023 16:22:15 +0200
Message-Id: <20230116142216.1141605-7-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a helper to evaluate ACPI usb device specific method (_DSM) provided
in case the USB3 port shouldn't enter U1 and U2 link states.

This _DSM was added as port specific retimer configuration may lead to
exit latencies growing beyond U1/U2 exit limits, and OS needs a way to
find which ports can't support U1/U2 link power management states.

This _DSM is also used by windows:
Link: https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/usb-device-specific-method---dsm-

Some patch issues found in testing resolved by Ron Lee

Cc: stable@vger.kernel.org
Tested-by: Ron Lee <ron.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/usb-acpi.c | 65 +++++++++++++++++++++++++++++++++++++
 include/linux/usb.h         |  3 ++
 2 files changed, 68 insertions(+)

diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 6d93428432f1..533baa85083c 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -37,6 +37,71 @@ bool usb_acpi_power_manageable(struct usb_device *hdev, int index)
 }
 EXPORT_SYMBOL_GPL(usb_acpi_power_manageable);
 
+#define UUID_USB_CONTROLLER_DSM "ce2ee385-00e6-48cb-9f05-2edb927c4899"
+#define USB_DSM_DISABLE_U1_U2_FOR_PORT	5
+
+/**
+ * usb_acpi_port_lpm_incapable - check if lpm should be disabled for a port.
+ * @hdev: USB device belonging to the usb hub
+ * @index: zero based port index
+ *
+ * Some USB3 ports may not support USB3 link power management U1/U2 states
+ * due to different retimer setup. ACPI provides _DSM method which returns 0x01
+ * if U1 and U2 states should be disabled. Evaluate _DSM with:
+ * Arg0: UUID = ce2ee385-00e6-48cb-9f05-2edb927c4899
+ * Arg1: Revision ID = 0
+ * Arg2: Function Index = 5
+ * Arg3: (empty)
+ *
+ * Return 1 if USB3 port is LPM incapable, negative on error, otherwise 0
+ */
+
+int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index)
+{
+	union acpi_object *obj;
+	acpi_handle port_handle;
+	int port1 = index + 1;
+	guid_t guid;
+	int ret;
+
+	ret = guid_parse(UUID_USB_CONTROLLER_DSM, &guid);
+	if (ret)
+		return ret;
+
+	port_handle = usb_get_hub_port_acpi_handle(hdev, port1);
+	if (!port_handle) {
+		dev_dbg(&hdev->dev, "port-%d no acpi handle\n", port1);
+		return -ENODEV;
+	}
+
+	if (!acpi_check_dsm(port_handle, &guid, 0,
+			    BIT(USB_DSM_DISABLE_U1_U2_FOR_PORT))) {
+		dev_dbg(&hdev->dev, "port-%d no _DSM function %d\n",
+			port1, USB_DSM_DISABLE_U1_U2_FOR_PORT);
+		return -ENODEV;
+	}
+
+	obj = acpi_evaluate_dsm(port_handle, &guid, 0,
+				USB_DSM_DISABLE_U1_U2_FOR_PORT, NULL);
+
+	if (!obj)
+		return -ENODEV;
+
+	if (obj->type != ACPI_TYPE_INTEGER) {
+		dev_dbg(&hdev->dev, "evaluate port-%d _DSM failed\n", port1);
+		ACPI_FREE(obj);
+		return -EINVAL;
+	}
+
+	if (obj->integer.value == 0x01)
+		ret = 1;
+
+	ACPI_FREE(obj);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usb_acpi_port_lpm_incapable);
+
 /**
  * usb_acpi_set_power_state - control usb port's power via acpi power
  * resource
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7d5325d47c45..04a7e94fb772 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -774,11 +774,14 @@ extern struct device *usb_intf_get_dma_device(struct usb_interface *intf);
 extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable);
 extern bool usb_acpi_power_manageable(struct usb_device *hdev, int index);
+extern int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index);
 #else
 static inline int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable) { return 0; }
 static inline bool usb_acpi_power_manageable(struct usb_device *hdev, int index)
 	{ return true; }
+static inline int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index)
+	{ return 0; }
 #endif
 
 /* USB autosuspend and autoresume */
-- 
2.25.1

