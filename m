Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC50C10BFC0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfK0UeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfK0UeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876612154A;
        Wed, 27 Nov 2019 20:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886841;
        bh=VzDAQEYHSJHf9amCtiA923IozZV4zQ8vtwzJFgfKeAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZpHafUWy2EcuoR8Q5iwEhRktbUSVsJQWFXp1LAQ03p4eEFss7FPydNrvvS0pM6Wm
         aUTc5YglPE+nm0UKtwo/cGcD9uUuvVjQ7GkVdoL4r8pu0g4y7T/xKtChfCB3V3DJXh
         MFTpENAKI85udZRbYM0akUWN/TmrKjvz7SL9nu2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Chuan Hsieh <kai.chiuan@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 014/132] platform/x86: asus-wmi: Set specified XUSB2PR value for X550LB
Date:   Wed, 27 Nov 2019 21:30:05 +0100
Message-Id: <20191127202911.771008431@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Chuan Hsieh <kai.chiuan@gmail.com>

[ Upstream commit 8023eff10e7b0327898f17f0b553d2e45c71cef3 ]

The bluetooth adapter Atheros AR3012 can't be enumerated
and make the bluetooth function broken.

T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  5 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3362 Rev=00.02
S:  Manufacturer=Atheros Communications
S:  Product=Bluetooth USB Host Controller
S:  SerialNumber=Alaska Day 2006
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

The error is:

 usb 2-6: device not accepting address 7, error -62
 usb usb2-port6: unable to enumerate USB device

It is caused by adapter's connected port is mapped to xHC
controller, but the xHCI is not supported by the usb device.

The output of 'sudo lspci -nnxxx -s 00:14.0':

 00:14.0 USB controller [0c03]: Intel Corporation 8 Series USB xHCI HC [8086:9c31] (rev 04)
 00: 86 80 31 9c 06 04 90 02 04 30 03 0c 00 00 00 00
 10: 04 00 a0 f7 00 00 00 00 00 00 00 00 00 00 00 00
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 1f 20
 30: 00 00 00 00 70 00 00 00 00 00 00 00 0b 01 00 00
 40: fd 01 36 80 89 c6 0f 80 00 00 00 00 00 00 00 00
 50: 5f 2e ce 0f 00 00 00 00 00 00 00 00 00 00 00 00
 60: 30 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 70: 01 80 c2 c1 08 00 00 00 00 00 00 00 00 00 00 00
 80: 05 00 87 00 0c a0 e0 fe 00 00 00 00 a1 41 00 00
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 a0: 00 01 04 00 00 00 00 00 00 00 00 00 00 00 00 00
 b0: 0f 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 03 c0 30 00 00 00 00 00 03 0c 00 00 00 00 00 00
 d0: f9 01 00 00 f9 01 00 00 0f 00 00 00 0f 00 00 00
 e0: 00 08 00 00 00 00 00 00 00 00 00 00 d8 d8 00 00
 f0: 00 00 00 00 00 00 00 00 b1 0f 04 08 00 00 00 00

By referencing Intel Platform Controller Hub(PCH) datasheet,
the xHC USB 2.0 Port Routing(XUSB2PR) at offset 0xD0-0xD3h
decides the setting of mapping the port to EHCI controller or
xHC controller. And the port mapped to xHC will enable xHCI
during bus resume.

The setting of disabling bluetooth adapter's connected port is
0x000001D9. The value can be obtained by few times 1 bit flip
operation. The suited configuration should have the 'lsusb -t'
result with bluetooth using ehci:

/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/9p, 480M
    |__ Port 5: Dev 2, If 0, Class=Video, Driver=uvcvideo, 480M
    |__ Port 5: Dev 2, If 1, Class=Video, Driver=uvcvideo, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/2p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/8p, 480M
        |__ Port 6: Dev 3, If 0, Class=Wireless, Driver=btusb, 12M
        |__ Port 6: Dev 3, If 1, Class=Wireless, Driver=btusb, 12M

Signed-off-by: Kai-Chuan Hsieh <kai.chiuan@gmail.com>
Acked-by: Corentin Chary <corentin.chary@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
[andy: resolve merge conflict in asus-wmi.h]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 drivers/platform/x86/asus-wmi.c    | 29 +++++++++++++++++++++++++++++
 drivers/platform/x86/asus-wmi.h    |  1 +
 3 files changed, 43 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a619cbe4e852f..7f7d6ca864771 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -116,6 +116,10 @@ static struct quirk_entry quirk_asus_ux303ub = {
 	.wmi_backlight_native = true,
 };
 
+static struct quirk_entry quirk_asus_x550lb = {
+	.xusb2pr = 0x01D9,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	quirks = dmi->driver_data;
@@ -407,6 +411,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_ux303ub,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X550LB",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X550LB"),
+		},
+		.driver_data = &quirk_asus_x550lb,
+	},
 	{},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index de131cf4d2e4d..a2174f01d3122 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -158,6 +158,9 @@ MODULE_LICENSE("GPL");
 #define ASUS_FAN_CTRL_MANUAL		1
 #define ASUS_FAN_CTRL_AUTO		2
 
+#define USB_INTEL_XUSB2PR		0xD0
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
+
 struct bios_args {
 	u32 arg0;
 	u32 arg1;
@@ -1082,6 +1085,29 @@ static int asus_wmi_rfkill_init(struct asus_wmi *asus)
 	return result;
 }
 
+static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
+{
+	struct pci_dev *xhci_pdev;
+	u32 orig_ports_available;
+	u32 ports_available = asus->driver->quirks->xusb2pr;
+
+	xhci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI,
+			NULL);
+
+	if (!xhci_pdev)
+		return;
+
+	pci_read_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
+				&orig_ports_available);
+
+	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
+				cpu_to_le32(ports_available));
+
+	pr_info("set USB_INTEL_XUSB2PR old: 0x%04x, new: 0x%04x\n",
+			orig_ports_available, ports_available);
+}
+
 /*
  * Hwmon device
  */
@@ -2085,6 +2111,9 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (asus->driver->quirks->wmi_backlight_native)
 		acpi_video_set_dmi_backlight_type(acpi_backlight_native);
 
+	if (asus->driver->quirks->xusb2pr)
+		asus_wmi_set_xusb2pr(asus);
+
 	if (acpi_video_get_backlight_type() == acpi_backlight_vendor) {
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 0e19014e9f542..fdff626c3b51b 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -53,6 +53,7 @@ struct quirk_entry {
 	 * and let the ACPI interrupt to send out the key event.
 	 */
 	int no_display_toggle;
+	u32 xusb2pr;
 
 	bool (*i8042_filter)(unsigned char data, unsigned char str,
 			     struct serio *serio);
-- 
2.20.1



