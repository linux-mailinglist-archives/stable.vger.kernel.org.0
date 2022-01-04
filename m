Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD559484142
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 12:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiADL7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 06:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiADL7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 06:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745A4C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 03:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBDC261348
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 11:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E62C36AE9;
        Tue,  4 Jan 2022 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641297571;
        bh=MtTxQ2ds5hAehBqVVCan1vU0Z3GpVsarVEp7DDndzYQ=;
        h=Subject:To:From:Date:From;
        b=GgNqsTZJk6Lg7D1UhRg7mnp2Py6Z5hJ6DpdLdSHk4PbleL09eoszMWnL+0a1T154m
         QyC25OWk/6wf2pwPjCi0OdLiW/IN25ls2wIMLX849B3lDo4B7jBKE+1yKutj4HErws
         6qQI1K5DV/RIHh7pj7/e6fCMvyVmar5zRSsQq8U8=
Subject: patch "USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status" added to usb-next
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jan 2022 12:59:18 +0100
Message-ID: <1641297558252152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1d7d4c07932e04355d6e6528d44a2f2c9e354346 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 31 Dec 2021 21:07:12 -0500
Subject: USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

When the USB core code for getting root-hub status reports was
originally written, it was assumed that the hub driver would be its
only caller.  But this isn't true now; user programs can use usbfs to
communicate with root hubs and get status reports.  When they do this,
they may use a transfer_buffer that is smaller than the data returned
by the HCD, which will lead to a buffer overflow error when
usb_hcd_poll_rh_status() tries to store the status data.  This was
discovered by syzbot:

BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
BUG: KASAN: slab-out-of-bounds in usb_hcd_poll_rh_status+0x5f4/0x780 drivers/usb/core/hcd.c:776
Write of size 2 at addr ffff88801da403c0 by task syz-executor133/4062

This patch fixes the bug by reducing the amount of status data if it
won't fit in the transfer_buffer.  If some data gets discarded then
the URB's completion status is set to -EOVERFLOW rather than 0, to let
the user know what happened.

Reported-and-tested-by: syzbot+3ae6a2b06f131ab9849f@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Yc+3UIQJ2STbxNua@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 9ffc63ae65ac..3e01dd6e509b 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -753,6 +753,7 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 {
 	struct urb	*urb;
 	int		length;
+	int		status;
 	unsigned long	flags;
 	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
@@ -770,11 +771,17 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 		if (urb) {
 			clear_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
 			hcd->status_urb = NULL;
+			if (urb->transfer_buffer_length >= length) {
+				status = 0;
+			} else {
+				status = -EOVERFLOW;
+				length = urb->transfer_buffer_length;
+			}
 			urb->actual_length = length;
 			memcpy(urb->transfer_buffer, buffer, length);
 
 			usb_hcd_unlink_urb_from_ep(hcd, urb);
-			usb_hcd_giveback_urb(hcd, urb, 0);
+			usb_hcd_giveback_urb(hcd, urb, status);
 		} else {
 			length = 0;
 			set_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
-- 
2.34.1


