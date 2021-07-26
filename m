Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F60A3D5F27
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhGZPRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236789AbhGZPP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD5160FC4;
        Mon, 26 Jul 2021 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314803;
        bh=1aZGpXYfPj5m5swfA8jeYJAxyQseMPTQ7xqNlJlJfNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TICsdp9X91YuM3d/oULnCJqyYLSoKD+0FJWtEboTr6WrfMgE7EsE4TyUTTTmYbQ2
         2/6El3yOSxKkMVUEAJpTa9+TkdAxaxrcPOWfWfNveUrhFqgLWtxgjcbIMjJQnIwNVp
         HR5Hn9BsYh3d6WiGq7BehOF1oH8oIAgxdtBzKde4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 096/120] usb: hub: Disable USB 3 device initiated lpm if exit latency is too high
Date:   Mon, 26 Jul 2021 17:39:08 +0200
Message-Id: <20210726153835.487209342@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 1b7f56fbc7a1b66967b6114d1b5f5a257c3abae6 upstream.

The device initiated link power management U1/U2 states should not be
enabled in case the system exit latency plus one bus interval (125us) is
greater than the shortest service interval of any periodic endpoint.

This is the case for both U1 and U2 sytstem exit latencies and link states.

See USB 3.2 section 9.4.9 "Set Feature" for more details

Note, before this patch the host and device initiated U1/U2 lpm states
were both enabled with lpm. After this patch it's possible to end up with
only host inititated U1/U2 lpm in case the exit latencies won't allow
device initiated lpm.

If this case we still want to set the udev->usb3_lpm_ux_enabled flag so
that sysfs users can see the link may go to U1/U2.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210715150122.1995966-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   68 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3989,6 +3989,47 @@ static int usb_set_lpm_timeout(struct us
 }
 
 /*
+ * Don't allow device intiated U1/U2 if the system exit latency + one bus
+ * interval is greater than the minimum service interval of any active
+ * periodic endpoint. See USB 3.2 section 9.4.9
+ */
+static bool usb_device_may_initiate_lpm(struct usb_device *udev,
+					enum usb3_link_state state)
+{
+	unsigned int sel;		/* us */
+	int i, j;
+
+	if (state == USB3_LPM_U1)
+		sel = DIV_ROUND_UP(udev->u1_params.sel, 1000);
+	else if (state == USB3_LPM_U2)
+		sel = DIV_ROUND_UP(udev->u2_params.sel, 1000);
+	else
+		return false;
+
+	for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
+		struct usb_interface *intf;
+		struct usb_endpoint_descriptor *desc;
+		unsigned int interval;
+
+		intf = udev->actconfig->interface[i];
+		if (!intf)
+			continue;
+
+		for (j = 0; j < intf->cur_altsetting->desc.bNumEndpoints; j++) {
+			desc = &intf->cur_altsetting->endpoint[j].desc;
+
+			if (usb_endpoint_xfer_int(desc) ||
+			    usb_endpoint_xfer_isoc(desc)) {
+				interval = (1 << (desc->bInterval - 1)) * 125;
+				if (sel + 125 > interval)
+					return false;
+			}
+		}
+	}
+	return true;
+}
+
+/*
  * Enable the hub-initiated U1/U2 idle timeouts, and enable device-initiated
  * U1/U2 entry.
  *
@@ -4060,20 +4101,23 @@ static void usb_enable_link_state(struct
 	 * U1/U2_ENABLE
 	 */
 	if (udev->actconfig &&
-	    usb_set_device_initiated_lpm(udev, state, true) == 0) {
-		if (state == USB3_LPM_U1)
-			udev->usb3_lpm_u1_enabled = 1;
-		else if (state == USB3_LPM_U2)
-			udev->usb3_lpm_u2_enabled = 1;
-	} else {
-		/* Don't request U1/U2 entry if the device
-		 * cannot transition to U1/U2.
-		 */
-		usb_set_lpm_timeout(udev, state, 0);
-		hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
+	    usb_device_may_initiate_lpm(udev, state)) {
+		if (usb_set_device_initiated_lpm(udev, state, true)) {
+			/*
+			 * Request to enable device initiated U1/U2 failed,
+			 * better to turn off lpm in this case.
+			 */
+			usb_set_lpm_timeout(udev, state, 0);
+			hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
+			return;
+		}
 	}
-}
 
+	if (state == USB3_LPM_U1)
+		udev->usb3_lpm_u1_enabled = 1;
+	else if (state == USB3_LPM_U2)
+		udev->usb3_lpm_u2_enabled = 1;
+}
 /*
  * Disable the hub-initiated U1/U2 idle timeouts, and disable device-initiated
  * U1/U2 entry.


