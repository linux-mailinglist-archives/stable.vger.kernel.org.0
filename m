Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4F3F605
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfD3Ll7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfD3Ll7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C94A2173E;
        Tue, 30 Apr 2019 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624517;
        bh=4MgvCjtRuPfFLrdr3GFI8lnS+w73hTTvxyrtKECyQss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4YQ7SBxJW+n8wi0ifuRTmINOfzomansryhCUg0NqnaWGiisLvaVhTDt77Z9bacUH
         YTPTDySJsTLwmFRgKye0s0nAfDgqt2er+oxY0hmpbWJ/e9LgFfVCZyy6OnxofYQggz
         igr3yCpHq8qJMsLELB670/yeXK2ECBuBqx8JEatU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.14 23/53] USB: Add new USB LPM helpers
Date:   Tue, 30 Apr 2019 13:38:30 +0200
Message-Id: <20190430113555.368929440@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
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
@@ -1891,7 +1891,7 @@ int usb_runtime_idle(struct device *dev)
 	return -EBUSY;
 }
 
-int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
+static int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
 {
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
 	int ret = -EPERM;
@@ -1908,6 +1908,16 @@ int usb_set_usb2_hardware_lpm(struct usb
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
@@ -3175,7 +3175,7 @@ int usb_port_suspend(struct usb_device *
 
 	/* disable USB2 hardware LPM */
 	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_set_usb2_hardware_lpm(udev, 0);
+		usb_disable_usb2_hardware_lpm(udev);
 
 	if (usb_disable_ltm(udev)) {
 		dev_err(&udev->dev, "Failed to disable LTM before suspend\n.");
@@ -3214,7 +3214,7 @@ int usb_port_suspend(struct usb_device *
  err_ltm:
 		/* Try to enable USB2 hardware LPM again */
 		if (udev->usb2_hw_lpm_capable == 1)
-			usb_set_usb2_hardware_lpm(udev, 1);
+			usb_enable_usb2_hardware_lpm(udev);
 
 		if (udev->do_remote_wakeup)
 			(void) usb_disable_remote_wakeup(udev);
@@ -3498,7 +3498,7 @@ int usb_port_resume(struct usb_device *u
 	} else  {
 		/* Try to enable USB2 hardware LPM */
 		if (udev->usb2_hw_lpm_capable == 1)
-			usb_set_usb2_hardware_lpm(udev, 1);
+			usb_enable_usb2_hardware_lpm(udev);
 
 		/* Try to enable USB3 LTM */
 		usb_enable_ltm(udev);
@@ -4334,7 +4334,7 @@ static void hub_set_initial_usb2_lpm_pol
 	if ((udev->bos->ext_cap->bmAttributes & cpu_to_le32(USB_BESL_SUPPORT)) ||
 			connect_type == USB_PORT_CONNECT_TYPE_HARD_WIRED) {
 		udev->usb2_hw_lpm_allowed = 1;
-		usb_set_usb2_hardware_lpm(udev, 1);
+		usb_enable_usb2_hardware_lpm(udev);
 	}
 }
 
@@ -5492,7 +5492,7 @@ static int usb_reset_and_verify_device(s
 	 * It will be re-enabled by the enumeration process.
 	 */
 	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_set_usb2_hardware_lpm(udev, 0);
+		usb_disable_usb2_hardware_lpm(udev);
 
 	/* Disable LPM and LTM while we reset the device and reinstall the alt
 	 * settings.  Device-initiated LPM settings, and system exit latency
@@ -5602,7 +5602,7 @@ static int usb_reset_and_verify_device(s
 
 done:
 	/* Now that the alt settings are re-installed, enable LTM and LPM. */
-	usb_set_usb2_hardware_lpm(udev, 1);
+	usb_enable_usb2_hardware_lpm(udev);
 	usb_unlocked_enable_lpm(udev);
 	usb_enable_ltm(udev);
 	usb_release_bos_descriptor(udev);
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1183,7 +1183,7 @@ void usb_disable_device(struct usb_devic
 		}
 
 		if (dev->usb2_hw_lpm_enabled == 1)
-			usb_set_usb2_hardware_lpm(dev, 0);
+			usb_disable_usb2_hardware_lpm(dev);
 		usb_unlocked_disable_lpm(dev);
 		usb_disable_ltm(dev);
 
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -508,7 +508,10 @@ static ssize_t usb2_hardware_lpm_store(s
 
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
@@ -89,7 +89,8 @@ extern int usb_remote_wakeup(struct usb_
 extern int usb_runtime_suspend(struct device *dev);
 extern int usb_runtime_resume(struct device *dev);
 extern int usb_runtime_idle(struct device *dev);
-extern int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable);
+extern int usb_enable_usb2_hardware_lpm(struct usb_device *udev);
+extern int usb_disable_usb2_hardware_lpm(struct usb_device *udev);
 
 #else
 
@@ -109,7 +110,12 @@ static inline int usb_autoresume_device(
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


