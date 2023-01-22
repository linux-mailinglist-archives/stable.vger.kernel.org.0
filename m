Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2F676F8D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjAVPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjAVPWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9685922785
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D0FB80B1E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D749C433D2;
        Sun, 22 Jan 2023 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400957;
        bh=wfgiwBe0vJkGjWvp99dVKA4TqU6LY0WQKRH3jdwZ5bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tidbc1nKEYVadSmpSz0+vAOYEAzQncc36AO+DX/vVyU9Lf67opAFXho5M5r37qERu
         I2jDgXKdU/rjlkvFsPN4SQ6Qv54VWe4iCIyPuG8BBOcIsqHhGXmmWLaY4dzxhbbabx
         U7j10ldTeM4Vwyn2wSj1fuv5fKyhGBl7sbR4VEJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ron Lee <ron.lee@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 055/193] usb: acpi: add helper to check port lpm capability using acpi _DSM
Date:   Sun, 22 Jan 2023 16:03:04 +0100
Message-Id: <20230122150248.847553363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cd702d18c882d5a4ea44bbdb38edd5d5577ef640 upstream.

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
Link: https://lore.kernel.org/r/20230116142216.1141605-7-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/usb-acpi.c |   65 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb.h         |    3 ++
 2 files changed, 68 insertions(+)

--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -37,6 +37,71 @@ bool usb_acpi_power_manageable(struct us
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
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -751,11 +751,14 @@ extern struct device *usb_intf_get_dma_d
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


