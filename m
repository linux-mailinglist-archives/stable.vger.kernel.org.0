Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85633182B4E
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 09:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCLIfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 04:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgCLIfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 04:35:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29534206FA;
        Thu, 12 Mar 2020 08:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584002136;
        bh=14bKVCt0AuUvJpWH5NbEv+gT5rYJmBWWCyzVX4dzEiM=;
        h=Subject:To:From:Date:From;
        b=Me8CPaZXm+EV4PhlwsF/DqmMh8fZ/OlZEdblMMNxQK8colmzI8Jrbe8Yl1aBmR6UU
         93QKxPxRIX4BKbOqgw0gnRQU3CT0O4eBch93iJZRVJZbfLCihxyz4JggqEfpzb6RPv
         kObTFYRCx4wU8tFuaH4f1D6A93nEHaEKAYpaAQI0=
Subject: patch "USB: Disable LPM on WD19's Realtek Hub" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Mar 2020 09:35:33 +0100
Message-ID: <1584002133117230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Disable LPM on WD19's Realtek Hub

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b63e48fb50e1ca71db301ca9082befa6f16c55c4 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 5 Feb 2020 19:26:33 +0800
Subject: USB: Disable LPM on WD19's Realtek Hub

Realtek Hub (0bda:0x0487) used in Dell Dock WD19 sometimes drops off the
bus when bringing underlying ports from U3 to U0.

Disabling LPM on the hub during setting link state is not enough, so
let's disable LPM completely for this hub.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200205112633.25995-3-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 2dac3e7cdd97..df6e6156e1d4 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -378,6 +378,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Realtek hub in Dell WD19 (Type-C) */
+	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },
-- 
2.25.1


