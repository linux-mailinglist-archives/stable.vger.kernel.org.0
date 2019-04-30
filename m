Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03152F872
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfD3Ljw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbfD3Ljv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AFAD21670;
        Tue, 30 Apr 2019 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624390;
        bh=VpZN+ISoJGB1r1M+e+fyvo0X+6AVL+yNLMrCttrsPuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uezX9KKKwbHksK7fyRMFfy2pTp9aQo3vkoQT7G+ukeDsFygAEqsQnWficnAx5UsYZ
         E13k9wiaVgXg4crs1ivye7JLV9c9pJyiphLmCUD2vsWZyQSPhnk75uUGy8WKy7knai
         ZgdLsJspWvf+vwLkScKiDvxErFH52DaPffYQ1ovc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.9 17/41] USB: Add new USB LPM helpers
Date:   Tue, 30 Apr 2019 13:38:28 +0200
Message-Id: <20190430113529.206945883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 7529b2574a7aaf902f1f8159fbc2a7caa74be559 upstream.

Use new helpers to make LPM enabling/disabling more clear.

This is a preparation to subsequent patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org> # after much soaking
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c  |   12 +++++++++++-
 drivers/usb/core/hub.c     |   12 ++++++------
 drivers/usb/core/message.c |    2 +-
 drivers/usb/core/sysfs.c   |    5 ++++-
 drivers/usb/core/usb.h     |   10 ++++++++--
 5 files changed, 30 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1888,7 +1888,7 @@ int usb_runtime_idle(struct device *dev)
 	return -EBUSY;
 }
 
-int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
+static int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
 {
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
 	int ret = -EPERM;
@@ -1905,6 +1905,16 @@ int usb_set_usb2_hardware_lpm(struct usb
 	return ret;
 }
 
+int usb_enable_usb2_hardware_lpm(struct usb_device *udev)
+{
+	return usb_set_usb2_hardware_lpm(udev, 1);
+}
+
+int usb_disable_usb2_hardware_lpm(struct usb_device *udev)
+{
+	return usb_set_usb2_hardware_lpm(udev, 0);
+}
+
 #endif /* CONFIG_PM */
 
 struct bus_type usb_bus_type = {
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3169,7 +3169,7 @@ int usb_port_suspend(struct usb_device *
 
 	/* disable USB2 hardware LPM */
 	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_set_usb2_hardware_lpm(udev, 0);
+		usb_disable_usb2_hardware_lpm(udev);
 
 	if (usb_disable_ltm(udev)) {
 		dev_err(&udev->dev, "Failed to disable LTM before suspend\n.");
@@ -3216,7 +3216,7 @@ int usb_port_suspend(struct usb_device *
  err_ltm:
 		/* Try to enable USB2 hardware LPM again */
 		if (udev->usb2_hw_lpm_capable == 1)
-			usb_set_usb2_hardware_lpm(udev, 1);
+			usb_enable_usb2_hardware_lpm(udev);
 
 		if (udev->do_remote_wakeup)
 			(void) usb_disable_remote_wakeup(udev);
@@ -3500,7 +3500,7 @@ int usb_port_resume(struct usb_device *u
 	} else  {
 		/* Try to enable USB2 hardware LPM */
 		if (udev->usb2_hw_lpm_capable == 1)
-			usb_set_usb2_hardware_lpm(udev, 1);
+			usb_enable_usb2_hardware_lpm(udev);
 
 		/* Try to enable USB3 LTM and LPM */
 		usb_enable_ltm(udev);
@@ -4337,7 +4337,7 @@ static void hub_set_initial_usb2_lpm_pol
 	if ((udev->bos->ext_cap->bmAttributes & cpu_to_le32(USB_BESL_SUPPORT)) ||
 			connect_type == USB_PORT_CONNECT_TYPE_HARD_WIRED) {
 		udev->usb2_hw_lpm_allowed = 1;
-		usb_set_usb2_hardware_lpm(udev, 1);
+		usb_enable_usb2_hardware_lpm(udev);
 	}
 }
 
@@ -5482,7 +5482,7 @@ static int usb_reset_and_verify_device(s
 	 * It will be re-enabled by the enumeration process.
 	 */
 	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_set_usb2_hardware_lpm(udev, 0);
+		usb_disable_usb2_hardware_lpm(udev);
 
 	/* Disable LPM and LTM while we reset the device and reinstall the alt
 	 * settings.  Device-initiated LPM settings, and system exit latency
@@ -5592,7 +5592,7 @@ static int usb_reset_and_verify_device(s
 
 done:
 	/* Now that the alt settings are re-installed, enable LTM and LPM. */
-	usb_set_usb2_hardware_lpm(udev, 1);
+	usb_enable_usb2_hardware_lpm(udev);
 	usb_unlocked_enable_lpm(udev);
 	usb_enable_ltm(udev);
 	usb_release_bos_descriptor(udev);
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1182,7 +1182,7 @@ void usb_disable_device(struct usb_devic
 		}
 
 		if (dev->usb2_hw_lpm_enabled == 1)
-			usb_set_usb2_hardware_lpm(dev, 0);
+			usb_disable_usb2_hardware_lpm(dev);
 		usb_unlocked_disable_lpm(dev);
 		usb_disable_ltm(dev);
 
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -494,7 +494,10 @@ static ssize_t usb2_hardware_lpm_store(s
 
 	if (!ret) {
 		udev->usb2_hw_lpm_allowed = value;
-		ret = usb_set_usb2_hardware_lpm(udev, value);
+		if (value)
+			ret = usb_enable_usb2_hardware_lpm(udev);
+		else
+			ret = usb_disable_usb2_hardware_lpm(udev);
 	}
 
 	usb_unlock_device(udev);
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -84,7 +84,8 @@ extern int usb_remote_wakeup(struct usb_
 extern int usb_runtime_suspend(struct device *dev);
 extern int usb_runtime_resume(struct device *dev);
 extern int usb_runtime_idle(struct device *dev);
-extern int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable);
+extern int usb_enable_usb2_hardware_lpm(struct usb_device *udev);
+extern int usb_disable_usb2_hardware_lpm(struct usb_device *udev);
 
 #else
 
@@ -104,7 +105,12 @@ static inline int usb_autoresume_device(
 	return 0;
 }
 
-static inline int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
+static inline int usb_enable_usb2_hardware_lpm(struct usb_device *udev)
+{
+	return 0;
+}
+
+static inline int usb_disable_usb2_hardware_lpm(struct usb_device *udev)
 {
 	return 0;
 }


