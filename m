Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA13D55C8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhGZIAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhGZIAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE20260F0F;
        Mon, 26 Jul 2021 08:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627288842;
        bh=nbDV0ijeLM78AorqdZ+qjQD5WD1ApG9D7z51i1I9CH4=;
        h=Subject:To:Cc:From:Date:From;
        b=1nZQxvHT3N93o1gAkKLshQJ8G/lSvWPw3zkEaGkrdBzD+nK0vjmAuJOxtviGViBRF
         7nqvestK2kETDOHGT67JyCPLxJRDEpdROKiKbDjgY1zYr1g0cuFEhxnoO3NzigsP0S
         WUTv3C75wAE2lTiHVq19mZRykZMeUQf9U5yBUrC4=
Subject: FAILED: patch "[PATCH] usb: hub: Fix link power management max exit latency (MEL)" failed to apply to 4.4-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:30:33 +0200
Message-ID: <1627288233173159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1bf2761c837571a66ec290fb66c90413821ffda2 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 15 Jul 2021 18:01:21 +0300
Subject: [PATCH] usb: hub: Fix link power management max exit latency (MEL)
 calculations

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

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d1efc7141333..a35d0bedafa3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -48,6 +48,7 @@
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
+#define USB_PING_RESPONSE_TIME		400	/* ns */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -182,8 +183,9 @@ int usb_device_supports_lpm(struct usb_device *udev)
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
@@ -193,35 +195,37 @@ static void usb_set_lpm_mel(struct usb_device *udev,
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

