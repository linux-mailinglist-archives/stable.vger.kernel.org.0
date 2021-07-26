Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE23D6231
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhGZPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233970AbhGZPdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5704660240;
        Mon, 26 Jul 2021 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316031;
        bh=RFeSe3TzQO9QGAIhLo9zT4xH116YiWF1JG4CxgRb2ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA/tg6n4Vza/g1weE7so3uJTRL1CdNTepbgSnrqQfyaq14VTKbD4vpblhy/9XNYm0
         Ldd7konoMnMnyBxBZp3y0fQvYbF48NhskpvZBdPz4K2gO7a8AgTRAL4eZpoPYaP7n0
         5WROkivgo8rpM9jCtVrW2C9iLYDSPrCcspXZouUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@kernel.org
Subject: [PATCH 5.13 162/223] usb: hub: Fix link power management max exit latency (MEL) calculations
Date:   Mon, 26 Jul 2021 17:39:14 +0200
Message-Id: <20210726153851.512031055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 1bf2761c837571a66ec290fb66c90413821ffda2 upstream.

Maximum Exit Latency (MEL) value is used by host to know how much in
advance it needs to start waking up a U1/U2 suspended link in order to
service a periodic transfer in time.

Current MEL calculation only includes the time to wake up the path from
U1/U2 to U0. This is called tMEL1 in USB 3.1 section C 1.5.2

Total MEL = tMEL1 + tMEL2 +tMEL3 + tMEL4 which should additinally include:
- tMEL2 which is the time it takes for PING message to reach device
- tMEL3 time for device to process the PING and submit a PING_RESPONSE
- tMEL4 time for PING_RESPONSE to traverse back upstream to host.

Add the missing tMEL2, tMEL3 and tMEL4 to MEL calculation.

Cc: <stable@kernel.org> # v3.5
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210715150122.1995966-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   52 ++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -48,6 +48,7 @@
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
+#define USB_PING_RESPONSE_TIME		400	/* ns */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -182,8 +183,9 @@ int usb_device_supports_lpm(struct usb_d
 }
 
 /*
- * Set the Maximum Exit Latency (MEL) for the host to initiate a transition from
- * either U1 or U2.
+ * Set the Maximum Exit Latency (MEL) for the host to wakup up the path from
+ * U1/U2, send a PING to the device and receive a PING_RESPONSE.
+ * See USB 3.1 section C.1.5.2
  */
 static void usb_set_lpm_mel(struct usb_device *udev,
 		struct usb3_lpm_parameters *udev_lpm_params,
@@ -193,35 +195,37 @@ static void usb_set_lpm_mel(struct usb_d
 		unsigned int hub_exit_latency)
 {
 	unsigned int total_mel;
-	unsigned int device_mel;
-	unsigned int hub_mel;
 
 	/*
-	 * Calculate the time it takes to transition all links from the roothub
-	 * to the parent hub into U0.  The parent hub must then decode the
-	 * packet (hub header decode latency) to figure out which port it was
-	 * bound for.
-	 *
-	 * The Hub Header decode latency is expressed in 0.1us intervals (0x1
-	 * means 0.1us).  Multiply that by 100 to get nanoseconds.
+	 * tMEL1. time to transition path from host to device into U0.
+	 * MEL for parent already contains the delay up to parent, so only add
+	 * the exit latency for the last link (pick the slower exit latency),
+	 * and the hub header decode latency. See USB 3.1 section C 2.2.1
+	 * Store MEL in nanoseconds
 	 */
 	total_mel = hub_lpm_params->mel +
-		(hub->descriptor->u.ss.bHubHdrDecLat * 100);
+		max(udev_exit_latency, hub_exit_latency) * 1000 +
+		hub->descriptor->u.ss.bHubHdrDecLat * 100;
 
 	/*
-	 * How long will it take to transition the downstream hub's port into
-	 * U0?  The greater of either the hub exit latency or the device exit
-	 * latency.
-	 *
-	 * The BOS U1/U2 exit latencies are expressed in 1us intervals.
-	 * Multiply that by 1000 to get nanoseconds.
+	 * tMEL2. Time to submit PING packet. Sum of tTPTransmissionDelay for
+	 * each link + wHubDelay for each hub. Add only for last link.
+	 * tMEL4, the time for PING_RESPONSE to traverse upstream is similar.
+	 * Multiply by 2 to include it as well.
 	 */
-	device_mel = udev_exit_latency * 1000;
-	hub_mel = hub_exit_latency * 1000;
-	if (device_mel > hub_mel)
-		total_mel += device_mel;
-	else
-		total_mel += hub_mel;
+	total_mel += (__le16_to_cpu(hub->descriptor->u.ss.wHubDelay) +
+		      USB_TP_TRANSMISSION_DELAY) * 2;
+
+	/*
+	 * tMEL3, tPingResponse. Time taken by device to generate PING_RESPONSE
+	 * after receiving PING. Also add 2100ns as stated in USB 3.1 C 1.5.2.4
+	 * to cover the delay if the PING_RESPONSE is queued behind a Max Packet
+	 * Size DP.
+	 * Note these delays should be added only once for the entire path, so
+	 * add them to the MEL of the device connected to the roothub.
+	 */
+	if (!hub->hdev->parent)
+		total_mel += USB_PING_RESPONSE_TIME + 2100;
 
 	udev_lpm_params->mel = total_mel;
 }


