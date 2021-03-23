Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4C345E0D
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCWM2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhCWM16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46174619B8;
        Tue, 23 Mar 2021 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502477;
        bh=PfYWdyTlcN2NQFyuwmaJE0W1y9u+3zNFshGZSOve2Q0=;
        h=Subject:To:From:Date:From;
        b=ol2fxu6Gn1URrdF+hdi7aFR4dR/R5s2ZuODhaDbQBR1XF/YxEe8oN77l7yB+rmVdd
         KKfCxur9ZFbQrqfFlp87k2Q6/FhHfHCzyR46UHxjRg5t3YYqqaTQ34+7DPqMIRNeW+
         4yNfewK4kWpj8Dzehu8Jq/jKimLkwfReL9mjvxWk=
Subject: patch "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem" added to usb-linus
To:     vpalatin@chromium.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:27:53 +0100
Message-ID: <16165024738866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0bd860493f81eb2a46173f6f5e44cc38331c8dbd Mon Sep 17 00:00:00 2001
From: Vincent Palatin <vpalatin@chromium.org>
Date: Fri, 19 Mar 2021 13:48:02 +0100
Subject: USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

This LTE modem (M.2 card) has a bug in its power management:
there is some kind of race condition for U3 wake-up between the host and
the device. The modem firmware sometimes crashes/locks when both events
happen at the same time and the modem fully drops off the USB bus (and
sometimes re-enumerates, sometimes just gets stuck until the next
reboot).

Tested with the modem wired to the XHCI controller on an AMD 3015Ce
platform. Without the patch, the modem dropped of the USB bus 5 times in
3 days. With the quirk, it stayed connected for a week while the
'runtime_suspended_time' counter incremented as excepted.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Link: https://lore.kernel.org/r/20210319124802.2315195-1-vpalatin@chromium.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 6ade3daf7858..76ac5d6555ae 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -498,6 +498,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Fibocom L850-GL LTE Modem */
+	{ USB_DEVICE(0x2cb7, 0x0007), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.31.0


