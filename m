Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F358579546
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbfG2Tkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389184AbfG2Tki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:40:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FB6206DD;
        Mon, 29 Jul 2019 19:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429237;
        bh=lCZ5oIwP5bwvvV48Eg1OMEB3VgrGPYIoZutGWqKmJkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZITAI7vAYXh5eHOPp554ua2odXcnYfZSYPwDI0V9fA8jBr+BDVi3+mCsJWT+6S3xv
         xVaEuTlTd2yeqE+6g1GGCMXfuOUqqn8FF8+u6wyLbnTFKI7Xz57fVwtbKubAQs/ZyS
         mZqs50ZX+Tqp+4FnFwsQce0INVKZBmJigHlj3uoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/113] usb: core: hub: Disable hub-initiated U1/U2
Date:   Mon, 29 Jul 2019 21:21:33 +0200
Message-Id: <20190729190657.217754958@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f4e8e869649a..8018f813972e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3961,6 +3961,9 @@ static int usb_set_lpm_timeout(struct usb_device *udev,
  * control transfers to set the hub timeout or enable device-initiated U1/U2
  * will be successful.
  *
+ * If the control transfer to enable device-initiated U1/U2 entry fails, then
+ * hub-initiated U1/U2 will be disabled.
+ *
  * If we cannot set the parent hub U1/U2 timeout, we attempt to let the xHCI
  * driver know about it.  If that call fails, it should be harmless, and just
  * take up more slightly more bus bandwidth for unnecessary U1/U2 exit latency.
@@ -4015,23 +4018,24 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
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



