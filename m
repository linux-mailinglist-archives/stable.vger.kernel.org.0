Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F33406B9F
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhIJMdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhIJMcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F69C600CC;
        Fri, 10 Sep 2021 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277104;
        bh=GLcMsC3AQA7e/6HQrAVY/mkPJHGUW8yHq8VRphwlg7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4G5qpjBp0pc5hzzswCvn63EdLmU1f8M2gshbXvaWohC59RE83jzEFF9YS9zU6Mur
         r/5gBcK9qIvgU5Hj5YfLgV6XfLWsWT28lThbrY+OD/S3JfTN0Ys7hWyl8tMwr309K3
         t4OrOU58Q3EUogdDWcrEsBIVITxeLViJX3DM6jMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.14 07/23] Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic
Date:   Fri, 10 Sep 2021 14:29:57 +0200
Message-Id: <20210910122916.253761280@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit f4292e2faf522f899b642d2040a2edbcbd455b9f upstream.

Turns out Hans de Goede completed the work I started last year trying to
improve Chinese-clone detection of CSR controller chips. Quirk after quirk
these Bluetooth dongles are more usable now.

Even after a few BlueZ regressions; these clones are so fickle that some
days they stop working altogether. Except on Windows, they work fine.

But this force-suspend initialization quirk seems to mostly do the trick,
after a lot of testing Bluetooth now seems to work *all* the time.

The only problem is that the solution ended up being masked under a very
stringent check; when there are probably hundreds of fake dongle
models out there that benefit from a good reset. Make it so.

Fixes: 81cac64ba258a ("Bluetooth: Deal with USB devices that are faking CSR vendor")
Fixes: cde1a8a992875 ("Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers")
Fixes: d74e0ae7e0303 ("Bluetooth: btusb: Fix detection of some fake CSR controllers with a bcdDevice val of 0x0134")
Fixes: 0671c0662383e ("Bluetooth: btusb: Add workaround for remote-wakeup issues with Barrot 8041a02 fake CSR controllers")

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   63 ++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1899,7 +1899,7 @@ static int btusb_setup_csr(struct hci_de
 		is_fake = true;
 
 	if (is_fake) {
-		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
+		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds and force-suspending once...");
 
 		/* Generally these clones have big discrepancies between
 		 * advertised features and what's actually supported.
@@ -1916,41 +1916,46 @@ static int btusb_setup_csr(struct hci_de
 		clear_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 
 		/*
-		 * Special workaround for clones with a Barrot 8041a02 chip,
-		 * these clones are really messed-up:
-		 * 1. Their bulk rx endpoint will never report any data unless
-		 * the device was suspended at least once (yes really).
+		 * Special workaround for these BT 4.0 chip clones, and potentially more:
+		 *
+		 * - 0x0134: a Barrot 8041a02                 (HCI rev: 0x1012 sub: 0x0810)
+		 * - 0x7558: IC markings FR3191AHAL 749H15143 (HCI rev/sub-version: 0x0709)
+		 *
+		 * These controllers are really messed-up.
+		 *
+		 * 1. Their bulk RX endpoint will never report any data unless
+		 * the device was suspended at least once (yes, really).
 		 * 2. They will not wakeup when autosuspended and receiving data
-		 * on their bulk rx endpoint from e.g. a keyboard or mouse
+		 * on their bulk RX endpoint from e.g. a keyboard or mouse
 		 * (IOW remote-wakeup support is broken for the bulk endpoint).
 		 *
 		 * To fix 1. enable runtime-suspend, force-suspend the
-		 * hci and then wake-it up by disabling runtime-suspend.
+		 * HCI and then wake-it up by disabling runtime-suspend.
 		 *
-		 * To fix 2. clear the hci's can_wake flag, this way the hci
+		 * To fix 2. clear the HCI's can_wake flag, this way the HCI
 		 * will still be autosuspended when it is not open.
+		 *
+		 * --
+		 *
+		 * Because these are widespread problems we prefer generic solutions; so
+		 * apply this initialization quirk to every controller that gets here,
+		 * it should be harmless. The alternative is to not work at all.
 		 */
-		if (bcdDevice == 0x8891 &&
-		    le16_to_cpu(rp->lmp_subver) == 0x1012 &&
-		    le16_to_cpu(rp->hci_rev) == 0x0810 &&
-		    le16_to_cpu(rp->hci_ver) == BLUETOOTH_VER_4_0) {
-			bt_dev_warn(hdev, "CSR: detected a fake CSR dongle using a Barrot 8041a02 chip, this chip is very buggy and may have issues");
-
-			pm_runtime_allow(&data->udev->dev);
-
-			ret = pm_runtime_suspend(&data->udev->dev);
-			if (ret >= 0)
-				msleep(200);
-			else
-				bt_dev_err(hdev, "Failed to suspend the device for Barrot 8041a02 receive-issue workaround");
-
-			pm_runtime_forbid(&data->udev->dev);
-
-			device_set_wakeup_capable(&data->udev->dev, false);
-			/* Re-enable autosuspend if this was requested */
-			if (enable_autosuspend)
-				usb_enable_autosuspend(data->udev);
-		}
+		pm_runtime_allow(&data->udev->dev);
+
+		ret = pm_runtime_suspend(&data->udev->dev);
+		if (ret >= 0)
+			msleep(200);
+		else
+			bt_dev_err(hdev, "CSR: Failed to suspend the device for our Barrot 8041a02 receive-issue workaround");
+
+		pm_runtime_forbid(&data->udev->dev);
+
+		device_set_wakeup_capable(&data->udev->dev, false);
+
+		/* Re-enable autosuspend if this was requested */
+		if (enable_autosuspend)
+			usb_enable_autosuspend(data->udev);
 	}
 
 	kfree_skb(skb);


