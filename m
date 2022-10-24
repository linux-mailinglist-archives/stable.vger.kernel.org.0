Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D8C60A608
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJXMb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiJXM3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E81876A6;
        Mon, 24 Oct 2022 05:03:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A22F16126B;
        Mon, 24 Oct 2022 11:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67AFC433C1;
        Mon, 24 Oct 2022 11:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612577;
        bh=yQyto2Ce9b73hWIW5ToDONrZ7wExoMDHWAq3LWLzMCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvyo8utknicJeSyczKAhvruuSe+qyfhaaWnjyFOq9dpPeG5lY5xRbFKEIfcic9X24
         UEa8u+4aw4GtRETNxSn6Ytp8x8n30Plj3XXq8VEuKRaajx9fsTTD3LWBIte8+4v4Ra
         RIwbg8ZpbXe2mDbkaNd+zTZXYi3oHLWDN0gERDZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 039/229] usb: add quirks for Lenovo OneLink+ Dock
Date:   Mon, 24 Oct 2022 13:29:18 +0200
Message-Id: <20221024113000.364453553@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>

commit 37d49519b41405b08748392c6a7f193d9f77ecd2 upstream.

The Lenovo OneLink+ Dock contains two VL812 USB3.0 controllers:
17ef:1018 upstream
17ef:1019 downstream

These hubs suffer from two separate problems:

1) After the host system was suspended and woken up, the hubs appear to
   be in a random state. Some downstream ports (both internal to the
   built-in audio and network controllers, and external to USB sockets)
   may no longer be functional. The exact list of disabled ports (if
   any) changes from wakeup to wakeup. Ports remain in that state until
   the dock is power-cycled, or until the laptop is rebooted.

   Wakeup sources connected to the hubs (keyboard, WoL on the integrated
   gigabit controller) will wake the system up from suspend, but they
   may no longer work after wakeup (and in that case will no longer work
   as wakeup source in a subsequent suspend-wakeup cycle).

   This issue appears in the logs with messages such as:

     usb 1-6.1-port4: cannot disable (err = -71)
     usb 1-6-port2: cannot disable (err = -71)
     usb 1-6.1: clear tt 1 (80c0) error -71
     usb 1-6-port4: cannot disable (err = -71)
     usb 1-6.4: PM: dpm_run_callback(): usb_dev_resume+0x0/0x10 [usbcore] returns -71
     usb 1-6.4: PM: failed to resume async: error -71
     usb 1-7: reset full-speed USB device number 5 using xhci_hcd
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: Cannot enable. Maybe the USB cable is bad?
     usb 1-6.1-port1: cannot disable (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: cannot reset (err = -71)
     usb 1-6.1-port1: Cannot enable. Maybe the USB cable is bad?
     usb 1-6.1-port1: cannot disable (err = -71)

2) Some USB devices cannot be enumerated properly. So far I have only
   seen the issue with USB 3.0 devices. The same devices work without
   problem directly connected to the host system, to other systems or to
   other hubs (even when those hubs are connected to the OneLink+ dock).

   One very reliable reproducer is this USB 3.0 HDD enclosure:
   152d:9561 JMicron Technology Corp. / JMicron USA Technology Corp. Mobius

   I have seen it happen sporadically with other USB 3.0 enclosures,
   with controllers from different manufacturers, all self-powered.

   Typical messages in the logs:

     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     usb 2-1.4: device not accepting address 6, error -62
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     usb 2-1.4: device not accepting address 7, error -62
     usb 2-1-port4: attempt power cycle
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     usb 2-1.4: device not accepting address 8, error -62
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
     usb 2-1.4: device not accepting address 9, error -62
     usb 2-1-port4: unable to enumerate USB device

Through trial and error, I found that the USB_QUIRK_RESET_RESUME solved
the second issue. Further testing then uncovered the first issue. Test
results are summarized in this table:

=======================================================================================
Settings                        USB2 hotplug    USB3 hotplug    State after waking up
---------------------------------------------------------------------------------------

power/control=auto              works           fails           broken

usbcore.autosuspend=-1          works           works           broken
OR power/control=on

power/control=auto              works (1)       works (1)       works
and USB_QUIRK_RESET_RESUME

power/control=on                works           works           works
and USB_QUIRK_RESET_RESUME

HUB_QUIRK_DISABLE_AUTOSUSPEND   works           works           works
and USB_QUIRK_RESET_RESUME

=======================================================================================

In those results, the power/control settings are applied to both hubs,
both on the USB2 and USB3 side, before each test.

>From those results, USB_QUIRK_RESET_RESUME is required to reset the hubs
properly after a suspend-wakeup cycle, and the hubs must not autosuspend
to work around the USB3 issue.

A secondary effect of USB_QUIRK_RESET_RESUME is to prevent the hubs'
upstream links from suspending (the downstream ports can still suspend).
This secondary effect is used in results (1). It is enough to solve the
USB3 problem.

Setting USB_QUIRK_RESET_RESUME on those hubs is the smallest patch that
solves both issues.

Prior to creating this patch, I have used the USB_QUIRK_RESET_RESUME via
the kernel command line for over a year without noticing any side
effect.

Thanks to Oliver Neukum @Suse for explanations of the operations of
USB_QUIRK_RESET_RESUME, and requesting more testing.

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220927073407.5672-1-jflf_kernel@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,6 +438,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
+	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x17ef, 0x1019), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
 	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
 


