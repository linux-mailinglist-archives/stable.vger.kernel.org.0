Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C33F157AD9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgBJMgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbgBJMgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553C72051A;
        Mon, 10 Feb 2020 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338211;
        bh=CPGUGucDrYuvV2JU3cVeQwqZLl/Am1PKdBmItt36pGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCIDKLUDXCsFSWKiGoyj7YBe9fBQ4+VivbeGeu5ol7FcPzWhPV+V2Kw4p0LqvSYD0
         5phsjxrdBDxW7vTKGQ6jYGfB+2xtnSHAh/BqozHIVyrTiXzFbcfUrrfdIPBEmVCUxl
         WxqP336i4QrRJUNaxKfIeOr2NucVJWTnX6AS20Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 035/309] Bluetooth: btusb: Disable runtime suspend on Realtek devices
Date:   Mon, 10 Feb 2020 04:29:51 -0800
Message-Id: <20200210122409.482139691@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 7ecacafc240638148567742cca41aa7144b4fe1e upstream.

After commit 9e45524a0111 ("Bluetooth: btusb: Fix suspend issue for
Realtek devices") both WiFi and Bluetooth stop working after reboot:
[   34.322617] usb 1-8: reset full-speed USB device number 3 using xhci_hcd
[   34.450401] usb 1-8: device descriptor read/64, error -71
[   34.694375] usb 1-8: device descriptor read/64, error -71
...
[   44.599111] rtw_pci 0000:02:00.0: failed to poll offset=0x5 mask=0x3 value=0x0
[   44.599113] rtw_pci 0000:02:00.0: mac power on failed
[   44.599114] rtw_pci 0000:02:00.0: failed to power on mac
[   44.599114] rtw_pci 0000:02:00.0: leave idle state failed
[   44.599492] rtw_pci 0000:02:00.0: failed to leave ips state
[   44.599493] rtw_pci 0000:02:00.0: failed to leave idle state

That commit removed USB_QUIRK_RESET_RESUME, which not only resets the USB
device after resume, it also prevents the device from being runtime
suspended by USB core. My experiment shows if the Realtek btusb device
ever runtime suspends once, the entire wireless module becomes useless
after reboot.

So let's explicitly disable runtime suspend on Realtek btusb device for
now.

Fixes: 9e45524a0111 ("Bluetooth: btusb: Fix suspend issue for Realtek devices")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3819,6 +3819,10 @@ static int btusb_probe(struct usb_interf
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
+
+		err = usb_autopm_get_interface(intf);
+		if (err < 0)
+			goto out_free_dev;
 	}
 
 	if (id->driver_info & BTUSB_AMP) {


