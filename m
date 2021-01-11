Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2883D2F1594
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbhAKNMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730952AbhAKNMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E6222BE9;
        Mon, 11 Jan 2021 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370699;
        bh=q3SHbNjSzqmp65jcj52ew86tKxWmzZ1+P7pG1RDWHIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAvgMgwrsz9SLu0kOtNMDoHQYtDaqrRe9K4ZivqRj1yJcEYVH/yj0wY9q69+6MR0B
         Pbx8IXh6RLiRYqyB7+xVQlRHajAjjJIFwtlE7uqYTSkH6MBH1Kqwxbc3h6dsR1sWJc
         TYm5Ehjcbex1CDp5Lj1p++Zjz676nUrc/JuCJgj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 5.4 58/92] USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set
Date:   Mon, 11 Jan 2021 14:02:02 +0100
Message-Id: <20210111130041.942865164@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 5d5323a6f3625f101dbfa94ba3ef7706cce38760 upstream.

The commit 0472bf06c6fd ("xhci: Prevent U1/U2 link pm states if exit
latency is too long") was constraining the xhci code not to allow U1/U2
sleep states if the latency to wake up from the U-states reached the
service interval of an periodic endpoint. This fix was not taking into
account that in case the quirk XHCI_INTEL_HOST is set, the wakeup time
will be calculated and configured differently.

It checks for u1_params.mel/u2_params.mel as a limit. But the code could
decide to write another MEL into the hardware. This leads to broken
cases where not enough bandwidth is available for other devices:

usb 1-2: can't set config #1, error -28

This patch is fixing that case by checking for timeout_ns after the
wakeup time was calculated depending on the quirks.

Fixes: 0472bf06c6fd ("xhci: Prevent U1/U2 link pm states if exit latency is too long")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201215193147.11738-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4642,19 +4642,19 @@ static u16 xhci_calculate_u1_timeout(str
 {
 	unsigned long long timeout_ns;
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
+	else
+		timeout_ns = udev->u1_params.sel;
+
 	/* Prevent U1 if service interval is shorter than U1 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= udev->u1_params.mel) {
+		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
 			dev_dbg(&udev->dev, "Disable U1, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
-	else
-		timeout_ns = udev->u1_params.sel;
-
 	/* The U1 timeout is encoded in 1us intervals.
 	 * Don't return a timeout of zero, because that's USB3_LPM_DISABLED.
 	 */
@@ -4706,19 +4706,19 @@ static u16 xhci_calculate_u2_timeout(str
 {
 	unsigned long long timeout_ns;
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
+	else
+		timeout_ns = udev->u2_params.sel;
+
 	/* Prevent U2 if service interval is shorter than U2 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= udev->u2_params.mel) {
+		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
 			dev_dbg(&udev->dev, "Disable U2, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
-	else
-		timeout_ns = udev->u2_params.sel;
-
 	/* The U2 timeout is encoded in 256us intervals */
 	timeout_ns = DIV_ROUND_UP_ULL(timeout_ns, 256 * 1000);
 	/* If the necessary timeout value is bigger than what we can set in the


