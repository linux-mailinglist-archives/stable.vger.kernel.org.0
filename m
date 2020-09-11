Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C1266671
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgIKR1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgIKM6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8632224E;
        Fri, 11 Sep 2020 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828920;
        bh=QVdzqYJERNYRtJmuQaJEbs6c3WcsGmTTOuf7J3MmMTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVWUOM7qk0sep5DlD4ZqSFVSAGfC7X2F0QStWmFnnDTpsVVDb2C95c4znMmyLap6U
         DWyhiaDkbwCskEjM7EBETq0nidnhyNUmbAOm27bzeA8QEYFAjT/qDjiI8tX1q8kSuh
         DVmQFTdJWaVDjlkS2FHj6oYnINr2eOoSyzqzBdhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/62] net: qmi_wwan: MDM9x30 specific power management
Date:   Fri, 11 Sep 2020 14:46:12 +0200
Message-Id: <20200911122503.848342627@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 93725149794d3d418cf1eddcae60c7b536c5faa1 ]

MDM9x30 based modems appear to go into a deeper sleep when
suspended without "Remote Wakeup" enabled.  The QMI interface
will not respond unless a "set DTR" control request is sent
on resume. The effect is similar to a QMI_CTL SYNC request,
resetting (some of) the firmware state.

We allow userspace sessions to span multiple character device
open/close sequences.  This means that userspace can depend
on firmware state while both the netdev and the character
device are closed.  We have disabled "needs_remote_wakeup" at
this point to allow devices without remote wakeup support to
be auto-suspended.

To make sure the MDM9x30 keeps firmware state, we need to
keep "needs_remote_wakeup" always set. We also need to
issue a "set DTR" request to enable the QMI interface.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 4391430e25273..b8b15deb94bdb 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -223,6 +223,20 @@ err:
 	return rv;
 }
 
+/* Send CDC SetControlLineState request, setting or clearing the DTR.
+ * "Required for Autoconnect and 9x30 to wake up" according to the
+ * GobiNet driver. The requirement has been verified on an MDM9230
+ * based Sierra Wireless MC7455
+ */
+static int qmi_wwan_change_dtr(struct usbnet *dev, bool on)
+{
+	u8 intf = dev->intf->cur_altsetting->desc.bInterfaceNumber;
+
+	return usbnet_write_cmd(dev, USB_CDC_REQ_SET_CONTROL_LINE_STATE,
+				USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+				on ? 0x01 : 0x00, intf, NULL, 0);
+}
+
 static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int status = -1;
@@ -280,6 +294,24 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 		usb_driver_release_interface(driver, info->data);
 	}
 
+	/* disabling remote wakeup on MDM9x30 devices has the same
+	 * effect as clearing DTR. The device will not respond to QMI
+	 * requests until we set DTR again.  This is similar to a
+	 * QMI_CTL SYNC request, clearing a lot of firmware state
+	 * including the client ID allocations.
+	 *
+	 * Our usage model allows a session to span multiple
+	 * open/close events, so we must prevent the firmware from
+	 * clearing out state the clients might need.
+	 *
+	 * MDM9x30 is the first QMI chipset with USB3 support. Abuse
+	 * this fact to enable the quirk.
+	 */
+	if (le16_to_cpu(dev->udev->descriptor.bcdUSB) >= 0x0201) {
+		qmi_wwan_manage_power(dev, 1);
+		qmi_wwan_change_dtr(dev, true);
+	}
+
 	/* Never use the same address on both ends of the link, even if the
 	 * buggy firmware told us to. Or, if device is assigned the well-known
 	 * buggy firmware MAC address, replace it with a random address,
@@ -307,6 +339,12 @@ static void qmi_wwan_unbind(struct usbnet *dev, struct usb_interface *intf)
 	if (info->subdriver && info->subdriver->disconnect)
 		info->subdriver->disconnect(info->control);
 
+	/* disable MDM9x30 quirk */
+	if (le16_to_cpu(dev->udev->descriptor.bcdUSB) >= 0x0201) {
+		qmi_wwan_change_dtr(dev, false);
+		qmi_wwan_manage_power(dev, 0);
+	}
+
 	/* allow user to unbind using either control or data */
 	if (intf == info->control)
 		other = info->data;
-- 
2.25.1



