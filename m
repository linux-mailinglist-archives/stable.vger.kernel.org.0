Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50D15AEA1A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiIFNhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbiIFNhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:37:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423F5BC02;
        Tue,  6 Sep 2022 06:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF900B81636;
        Tue,  6 Sep 2022 13:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2133AC433D6;
        Tue,  6 Sep 2022 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471267;
        bh=qtB+aJVlpSYbn4x8TBMybS0G9wFa1htqzUS2oOQ3oZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm0LVSJzJG/OCngkug112e0N7WwHgBscOR3Uj6d2UgxAx7oqujvATocH7GUvyHfUb
         de2B5V+5I7qn4ll9Lwx8KIxRj80nVOQWSXUKxexlkLiL1xtLtITG8YKxFUEmuxR0L2
         GtDtQjbpXOwzGdFmMjH/fc26jYa/dRMObjoqY2rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 51/80] xhci: Add grace period after xHC start to prevent premature runtime suspend.
Date:   Tue,  6 Sep 2022 15:30:48 +0200
Message-Id: <20220906132819.155465063@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 33e321586e37b642ad10594b9ef25a613555cd08 upstream.

After xHC controller is started, either in probe or resume, it can take
a while before any of the connected usb devices are visible to the roothub
due to link training.

It's possible xhci driver loads, sees no acivity and suspends the host
before the USB device is visible.

In one testcase with a hotplugged xHC controller the host finally detected
the connected USB device and generated a wake 500ms after host initial
start.

If hosts didn't suspend the device duringe training it probablty wouldn't
take up to 500ms to detect it, but looking at specs reveal USB3 link
training has a couple long timeout values, such as 120ms
RxDetectQuietTimeout, and 360ms PollingLFPSTimeout.

So Add a 500ms grace period that keeps polling the roothub for 500ms after
start, preventing runtime suspend until USB devices are detected.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220825150840.132216-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |   11 +++++++++++
 drivers/usb/host/xhci.c     |    4 +++-
 drivers/usb/host/xhci.h     |    2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1561,6 +1561,17 @@ int xhci_hub_status_data(struct usb_hcd
 
 	status = bus_state->resuming_ports;
 
+	/*
+	 * SS devices are only visible to roothub after link training completes.
+	 * Keep polling roothubs for a grace period after xHC start
+	 */
+	if (xhci->run_graceperiod) {
+		if (time_before(jiffies, xhci->run_graceperiod))
+			status = 1;
+		else
+			xhci->run_graceperiod = 0;
+	}
+
 	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC | PORT_CEC;
 
 	/* For each port, did anything change?  If so, set that bit in buf. */
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -149,9 +149,11 @@ int xhci_start(struct xhci_hcd *xhci)
 		xhci_err(xhci, "Host took too long to start, "
 				"waited %u microseconds.\n",
 				XHCI_MAX_HALT_USEC);
-	if (!ret)
+	if (!ret) {
 		/* clear state flags. Including dying, halted or removing */
 		xhci->xhc_state = 0;
+		xhci->run_graceperiod = jiffies + msecs_to_jiffies(500);
+	}
 
 	return ret;
 }
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1816,7 +1816,7 @@ struct xhci_hcd {
 
 	/* Host controller watchdog timer structures */
 	unsigned int		xhc_state;
-
+	unsigned long		run_graceperiod;
 	u32			command;
 	struct s3_save		s3;
 /* Host controller is dying - not responding to commands. "I'm not dead yet!"


