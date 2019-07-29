Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F89795BD
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfG2Tp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfG2Tp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5C72054F;
        Mon, 29 Jul 2019 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429527;
        bh=X8iQNc3afEQ2OhOlW3llgTWiwQzhs3Ceh8IaOxaBiik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Nv0OTR4XNvTha2OJGiSg00JC7ah1EgVbY1cztgeDjc+vSnwYper1nci3G5WxIHEY
         fHycNGM0q6Mwcb/eTdw1oLr0YAf23BB3cdOmIrXh8GiBHSJ+DpRF5Wdh5NUo78ShtW
         tzB0GM1vQtUQ8LiV6gjQUPFM/OjwKEr+l7WO84bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 013/215] usb: core: hub: Disable hub-initiated U1/U2
Date:   Mon, 29 Jul 2019 21:20:09 +0200
Message-Id: <20190729190741.810717959@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
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
index 2c8e60c7dbd8..2844366dc173 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4002,6 +4002,9 @@ static int usb_set_lpm_timeout(struct usb_device *udev,
  * control transfers to set the hub timeout or enable device-initiated U1/U2
  * will be successful.
  *
+ * If the control transfer to enable device-initiated U1/U2 entry fails, then
+ * hub-initiated U1/U2 will be disabled.
+ *
  * If we cannot set the parent hub U1/U2 timeout, we attempt to let the xHCI
  * driver know about it.  If that call fails, it should be harmless, and just
  * take up more slightly more bus bandwidth for unnecessary U1/U2 exit latency.
@@ -4056,23 +4059,24 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
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



