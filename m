Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4119848E63B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiANIZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbiANIWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A744C061392;
        Fri, 14 Jan 2022 00:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 426ADB82432;
        Fri, 14 Jan 2022 08:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDC5C36AEA;
        Fri, 14 Jan 2022 08:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148526;
        bh=ODmlybYA1X7PI5hQpMANYj3jMI3VYtYjGZ0QCd3yevE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOMyZbzWQijPjcSKM6zsD5jVFUUS/TKePwsAU+E9NlkCzatxiobHv5V4xgD4yXSDE
         2evdzwNsicRix3fDaGkg0FdiVI7+VOp8z3zbyDT7bEcy10WoTvpYMrgCqBbBsShrJf
         LCRFM2CceBkX7XHAZWe0q577tmzyWc40P7YcV0UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+3ae6a2b06f131ab9849f@syzkaller.appspotmail.com
Subject: [PATCH 5.16 18/37] USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status
Date:   Fri, 14 Jan 2022 09:16:32 +0100
Message-Id: <20220114081545.446545114@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 1d7d4c07932e04355d6e6528d44a2f2c9e354346 upstream.

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
 drivers/usb/core/hcd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -753,6 +753,7 @@ void usb_hcd_poll_rh_status(struct usb_h
 {
 	struct urb	*urb;
 	int		length;
+	int		status;
 	unsigned long	flags;
 	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
@@ -770,11 +771,17 @@ void usb_hcd_poll_rh_status(struct usb_h
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


