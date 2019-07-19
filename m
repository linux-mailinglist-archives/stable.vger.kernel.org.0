Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2006DD53
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbfGSELQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388365AbfGSELQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE2E821873;
        Fri, 19 Jul 2019 04:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509474;
        bh=8wTo43N4oBCQdJhdwhoOIgKxVWeenbjo97e7VgmifY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbuY4NHwFRgTN7r9YAv4kCImbkRFGtTrX9d8A/twY3QYu/ZqdehqHwI1JEQM9d9xv
         SjBXnszbXvSjsJlDahzDEVqIUH8FmcryftEMG4oj2atRl9vi2tBuKBKm3+1fjRwW7H
         MpalBh6WTduaHrYrPe5YG3RlhzDvgY7c3SN1Zqcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/60] usb: core: hub: Disable hub-initiated U1/U2
Date:   Fri, 19 Jul 2019 00:10:11 -0400
Message-Id: <20190719041109.18262-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 561759292774707b71ee61aecc07724905bb7ef1 ]

If the device rejects the control transfer to enable device-initiated
U1/U2 entry, then the device will not initiate U1/U2 transition. To
improve the performance, the downstream port should not initate
transition to U1/U2 to avoid the delay from the device link command
response (no packet can be transmitted while waiting for a response from
the device). If the device has some quirks and does not implement U1/U2,
it may reject all the link state change requests, and the downstream
port may resend and flood the bus with more requests. This will affect
the device performance even further. This patch disables the
hub-initated U1/U2 if the device-initiated U1/U2 entry fails.

Reference: USB 3.2 spec 7.2.4.2.3

Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index eddecaf1f0b2..f83a5fb17c3f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3873,6 +3873,9 @@ static int usb_set_lpm_timeout(struct usb_device *udev,
  * control transfers to set the hub timeout or enable device-initiated U1/U2
  * will be successful.
  *
+ * If the control transfer to enable device-initiated U1/U2 entry fails, then
+ * hub-initiated U1/U2 will be disabled.
+ *
  * If we cannot set the parent hub U1/U2 timeout, we attempt to let the xHCI
  * driver know about it.  If that call fails, it should be harmless, and just
  * take up more slightly more bus bandwidth for unnecessary U1/U2 exit latency.
@@ -3927,23 +3930,24 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 		 * host know that this link state won't be enabled.
 		 */
 		hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
-	} else {
-		/* Only a configured device will accept the Set Feature
-		 * U1/U2_ENABLE
-		 */
-		if (udev->actconfig)
-			usb_set_device_initiated_lpm(udev, state, true);
+		return;
+	}
 
-		/* As soon as usb_set_lpm_timeout(timeout) returns 0, the
-		 * hub-initiated LPM is enabled. Thus, LPM is enabled no
-		 * matter the result of usb_set_device_initiated_lpm().
-		 * The only difference is whether device is able to initiate
-		 * LPM.
-		 */
+	/* Only a configured device will accept the Set Feature
+	 * U1/U2_ENABLE
+	 */
+	if (udev->actconfig &&
+	    usb_set_device_initiated_lpm(udev, state, true) == 0) {
 		if (state == USB3_LPM_U1)
 			udev->usb3_lpm_u1_enabled = 1;
 		else if (state == USB3_LPM_U2)
 			udev->usb3_lpm_u2_enabled = 1;
+	} else {
+		/* Don't request U1/U2 entry if the device
+		 * cannot transition to U1/U2.
+		 */
+		usb_set_lpm_timeout(udev, state, 0);
+		hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
 	}
 }
 
-- 
2.20.1

