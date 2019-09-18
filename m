Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EC9B5C01
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfIRGVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729238AbfIRGVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:21:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06FB20678;
        Wed, 18 Sep 2019 06:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787707;
        bh=bwO8NrLUzX5QEkcPRdp7XJubD37gy/0HLOx1LlqE8Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdE6SggwTVFD3Zkg3z+NJYdlZ67ZdyCTN+QqBOeJRVtwq1YbZC9ygpAd/unbY68Zj
         EBxN++uO6yY5MHZwIPFP5vgVHj9kdMj796eE/pGhmaxmWwgSbQnXMBhrrP7/4MMiqK
         jFNZEgX8LMm+ImuTQuBjLbK4gHY0J6+uXlI7PYfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Christian Kellner <ckellner@redhat.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.14 42/45] Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"
Date:   Wed, 18 Sep 2019 08:19:20 +0200
Message-Id: <20190918061227.872848858@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

commit 1ffdb51f28e8ec6be0a2b812c1765b5cf5c44a8f upstream.

This reverts commit a0085f2510e8976614ad8f766b209448b385492f.

This commit has caused regressions in notebooks that support suspend
to idle such as the XPS 9360, XPS 9370 and XPS 9380.

These notebooks will wakeup from suspend to idle from an unsolicited
advertising packet from an unpaired BLE device.

In a bug report it was sugggested that this is caused by a generic
lack of LE privacy support.  Revert this commit until that behavior
can be avoided by the kernel.

Fixes: a0085f2510e8 ("Bluetooth: btusb: driver to enable the usb-wakeup feature")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=200039
Link: https://marc.info/?l=linux-bluetooth&m=156441081612627&w=2
Link: https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/750073/
CC: Bastien Nocera <hadess@hadess.net>
CC: Christian Kellner <ckellner@redhat.com>
CC: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1124,10 +1124,6 @@ static int btusb_open(struct hci_dev *hd
 	}
 
 	data->intf->needs_remote_wakeup = 1;
-	/* device specific wakeup source enabled and required for USB
-	 * remote wakeup while host is suspended
-	 */
-	device_wakeup_enable(&data->udev->dev);
 
 	if (test_and_set_bit(BTUSB_INTR_RUNNING, &data->flags))
 		goto done;
@@ -1191,7 +1187,6 @@ static int btusb_close(struct hci_dev *h
 		goto failed;
 
 	data->intf->needs_remote_wakeup = 0;
-	device_wakeup_disable(&data->udev->dev);
 	usb_autopm_put_interface(data->intf);
 
 failed:


