Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCACDF817
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfD3LmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfD3LmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035A221670;
        Tue, 30 Apr 2019 11:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624520;
        bh=XCT8GXs1JCAYz92nzMI+Ekt6dIWDhWYLbdmVybcuI10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugtP/3NcgJuDVUF4GU7t9NtPuKF9WpAthaqH6tQIka8aByK88GyY7+Q+OXEooN4Nu
         iIrLj6aCw1s/ZNBML+k5HV087J0L3L5BaLFWiVmb67LSFWs++vSm8u27h6IBwSBmk+
         cleO9VSkgtDuZmethdSa2oBZSx7LwvrGcxzTY8C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 4.14 24/53] USB: Consolidate LPM checks to avoid enabling LPM twice
Date:   Tue, 30 Apr 2019 13:38:31 +0200
Message-Id: <20190430113555.622596750@linuxfoundation.org>
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

commit d7a6c0ce8d26412903c7981503bad9e1cc7c45d2 upstream.

USB Bluetooth controller QCA ROME (0cf3:e007) sometimes stops working
after S3:
[ 165.110742] Bluetooth: hci0: using NVM file: qca/nvm_usb_00000302.bin
[ 168.432065] Bluetooth: hci0: Failed to send body at 4 of 1953 (-110)

After some experiments, I found that disabling LPM can workaround the
issue.

On some platforms, the USB power is cut during S3, so the driver uses
reset-resume to resume the device. During port resume, LPM gets enabled
twice, by usb_reset_and_verify_device() and usb_port_resume().

Consolidate all checks into new LPM helpers to make sure LPM only gets
enabled once.

Fixes: de68bab4fa96 ("usb: Don't enable USB 2.0 Link PM by default.”)
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org> # after much soaking
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c  |   11 ++++++++---
 drivers/usb/core/hub.c     |   12 ++++--------
 drivers/usb/core/message.c |    3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1896,9 +1896,6 @@ static int usb_set_usb2_hardware_lpm(str
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
 	int ret = -EPERM;
 
-	if (enable && !udev->usb2_hw_lpm_allowed)
-		return 0;
-
 	if (hcd->driver->set_usb2_hw_lpm) {
 		ret = hcd->driver->set_usb2_hw_lpm(hcd, udev, enable);
 		if (!ret)
@@ -1910,11 +1907,19 @@ static int usb_set_usb2_hardware_lpm(str
 
 int usb_enable_usb2_hardware_lpm(struct usb_device *udev)
 {
+	if (!udev->usb2_hw_lpm_capable ||
+	    !udev->usb2_hw_lpm_allowed ||
+	    udev->usb2_hw_lpm_enabled)
+		return 0;
+
 	return usb_set_usb2_hardware_lpm(udev, 1);
 }
 
 int usb_disable_usb2_hardware_lpm(struct usb_device *udev)
 {
+	if (!udev->usb2_hw_lpm_enabled)
+		return 0;
+
 	return usb_set_usb2_hardware_lpm(udev, 0);
 }
 
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3174,8 +3174,7 @@ int usb_port_suspend(struct usb_device *
 	}
 
 	/* disable USB2 hardware LPM */
-	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_disable_usb2_hardware_lpm(udev);
+	usb_disable_usb2_hardware_lpm(udev);
 
 	if (usb_disable_ltm(udev)) {
 		dev_err(&udev->dev, "Failed to disable LTM before suspend\n.");
@@ -3213,8 +3212,7 @@ int usb_port_suspend(struct usb_device *
 		usb_enable_ltm(udev);
  err_ltm:
 		/* Try to enable USB2 hardware LPM again */
-		if (udev->usb2_hw_lpm_capable == 1)
-			usb_enable_usb2_hardware_lpm(udev);
+		usb_enable_usb2_hardware_lpm(udev);
 
 		if (udev->do_remote_wakeup)
 			(void) usb_disable_remote_wakeup(udev);
@@ -3497,8 +3495,7 @@ int usb_port_resume(struct usb_device *u
 		hub_port_logical_disconnect(hub, port1);
 	} else  {
 		/* Try to enable USB2 hardware LPM */
-		if (udev->usb2_hw_lpm_capable == 1)
-			usb_enable_usb2_hardware_lpm(udev);
+		usb_enable_usb2_hardware_lpm(udev);
 
 		/* Try to enable USB3 LTM */
 		usb_enable_ltm(udev);
@@ -5491,8 +5488,7 @@ static int usb_reset_and_verify_device(s
 	/* Disable USB2 hardware LPM.
 	 * It will be re-enabled by the enumeration process.
 	 */
-	if (udev->usb2_hw_lpm_enabled == 1)
-		usb_disable_usb2_hardware_lpm(udev);
+	usb_disable_usb2_hardware_lpm(udev);
 
 	/* Disable LPM and LTM while we reset the device and reinstall the alt
 	 * settings.  Device-initiated LPM settings, and system exit latency
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1182,8 +1182,7 @@ void usb_disable_device(struct usb_devic
 			dev->actconfig->interface[i] = NULL;
 		}
 
-		if (dev->usb2_hw_lpm_enabled == 1)
-			usb_disable_usb2_hardware_lpm(dev);
+		usb_disable_usb2_hardware_lpm(dev);
 		usb_unlocked_disable_lpm(dev);
 		usb_disable_ltm(dev);
 


