Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB743E824B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbhHJSGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239112AbhHJSEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9698361244;
        Tue, 10 Aug 2021 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617718;
        bh=6QtEQO6FOU2PYeSDEe9WRguwYtnQCN8FsNPIhfcXRRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3dYukvMcbpbTmrT8EqqpPT/T1menHzsC5yruFWK+b74TKYRXKfa3EBR7vHPEXG5Q
         mCGl+jKgQHH0erGGNETNR4v7R7FPw1tb7utsCRnkhA5pRQqj0302Qx/E+63OUH4scp
         XJ3Ttl46JGiyiQQGGqu8476TXN6mx7pHubZBMsCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Zaidman <michael.zaidman@gmail.com>,
        "Aaron Jones (FTDI-UK)" <aaron.jones@ftdichip.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 175/175] HID: ft260: fix device removal due to USB disconnect
Date:   Tue, 10 Aug 2021 19:31:23 +0200
Message-Id: <20210810173006.709488122@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit db8d3a21275c807a4047a21bde3b57d49ca55d82 ]

This commit fixes a functional regression introduced by the commit 82f09a637dd3
("HID: ft260: improve error handling of ft260_hid_feature_report_get()")
when upon USB disconnect, the FTDI FT260 i2c device is still available within
the /dev folder.

In my company's product, where the host USB to FT260 USB connection is
hard-wired in the PCB, the issue is not reproducible. To reproduce it, I used
the VirtualBox Ubuntu 20.04 VM and the UMFT260EV1A development module for the
FTDI FT260 chip:

Plug the UMFT260EV1A module into a USB port and attach it to VM.

The VM shows 2 i2c devices under the /dev:
    michael@michael-VirtualBox:~$ ls /dev/i2c-*
    /dev/i2c-0  /dev/i2c-1

The i2c-0 is not related to the FTDI FT260:
    michael@michael-VirtualBox:~$ cat /sys/bus/i2c/devices/i2c-0/name
    SMBus PIIX4 adapter at 4100

The i2c-1 is created by hid-ft260.ko:
    michael@michael-VirtualBox:~$ cat /sys/bus/i2c/devices/i2c-1/name
    FT260 usb-i2c bridge on hidraw1

Now, detach the FTDI FT260 USB device from VM. We expect the /dev/i2c-1
to disappear, but it's still here:
    michael@michael-VirtualBox:~$ ls /dev/i2c-*
    /dev/i2c-0  /dev/i2c-1

And the kernel log shows:
    [  +0.001202] usb 2-2: USB disconnect, device number 3
    [  +0.000109] ft260 0003:0403:6030.0002: failed to retrieve system status
    [  +0.000316] ft260 0003:0403:6030.0003: failed to retrieve system status

It happens because the commit 82f09a637dd3 changed the ft260_get_system_config()
return logic. This caused the ft260_is_interface_enabled() to exit with error
upon the FT260 device USB disconnect, which in turn, aborted the ft260_remove()
before deleting the FT260 i2c device and cleaning its sysfs stuff.

This commit restores the FT260 USB removal functionality and improves the
ft260_is_interface_enabled() code to handle correctly all chip modes defined
by the device interface configuration pins DCNF0 and DCNF1.

Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Acked-by: Aaron Jones (FTDI-UK) <aaron.jones@ftdichip.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ft260.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-ft260.c b/drivers/hid/hid-ft260.c
index f43a8406cb9a..e73776ae6976 100644
--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -742,7 +742,7 @@ static int ft260_is_interface_enabled(struct hid_device *hdev)
 	int ret;
 
 	ret = ft260_get_system_config(hdev, &cfg);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	ft260_dbg("interface:  0x%02x\n", interface);
@@ -754,23 +754,16 @@ static int ft260_is_interface_enabled(struct hid_device *hdev)
 	switch (cfg.chip_mode) {
 	case FT260_MODE_ALL:
 	case FT260_MODE_BOTH:
-		if (interface == 1) {
+		if (interface == 1)
 			hid_info(hdev, "uart interface is not supported\n");
-			return 0;
-		}
-		ret = 1;
+		else
+			ret = 1;
 		break;
 	case FT260_MODE_UART:
-		if (interface == 0) {
-			hid_info(hdev, "uart is unsupported on interface 0\n");
-			ret = 0;
-		}
+		hid_info(hdev, "uart interface is not supported\n");
 		break;
 	case FT260_MODE_I2C:
-		if (interface == 1) {
-			hid_info(hdev, "i2c is unsupported on interface 1\n");
-			ret = 0;
-		}
+		ret = 1;
 		break;
 	}
 	return ret;
@@ -1004,11 +997,9 @@ static int ft260_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 static void ft260_remove(struct hid_device *hdev)
 {
-	int ret;
 	struct ft260_device *dev = hid_get_drvdata(hdev);
 
-	ret = ft260_is_interface_enabled(hdev);
-	if (ret <= 0)
+	if (!dev)
 		return;
 
 	sysfs_remove_group(&hdev->dev.kobj, &ft260_attr_group);
-- 
2.30.2



