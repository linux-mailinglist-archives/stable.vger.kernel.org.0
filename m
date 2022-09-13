Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E095B744E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbiIMPYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbiIMPXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA0D7C75B;
        Tue, 13 Sep 2022 07:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1296D614C0;
        Tue, 13 Sep 2022 14:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E34EC433C1;
        Tue, 13 Sep 2022 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079827;
        bh=FNQL4f90Hhbis1flO43W5RzCiLMjOungG55WPTLAx7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjsKGT3Yks5IFPwkR6J+ic4VSCHhFKxrmxwoa0BgoGOY/29aBBrXr2ojaJ0+5ooSe
         asq7K/ed4Q0f9zEv7SnzW7NNwFdKF/UQrOhcFoMylpM4DweHbD5d9x1lFP7orpwJ/n
         B8nfaSyhNQJvcTu+JYk7DTwp24nhzBcIt8zDpOB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 09/42] xhci: Add grace period after xHC start to prevent premature runtime suspend.
Date:   Tue, 13 Sep 2022 16:07:40 +0200
Message-Id: <20220913140342.750028767@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
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
@@ -1297,6 +1297,17 @@ int xhci_hub_status_data(struct usb_hcd
 
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
@@ -144,9 +144,11 @@ static int xhci_start(struct xhci_hcd *x
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
@@ -1607,7 +1607,7 @@ struct xhci_hcd {
 
 	/* Host controller watchdog timer structures */
 	unsigned int		xhc_state;
-
+	unsigned long		run_graceperiod;
 	u32			command;
 	struct s3_save		s3;
 /* Host controller is dying - not responding to commands. "I'm not dead yet!"


