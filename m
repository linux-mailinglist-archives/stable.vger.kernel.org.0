Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC6498B1C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbiAXTL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:11:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60190 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344119AbiAXTDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 160C3B8121F;
        Mon, 24 Jan 2022 19:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B45C340E5;
        Mon, 24 Jan 2022 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051025;
        bh=7Jxp6D6htDCCccYyU2JW7clNMIT81xHBMJgawc9qhac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wl7eGZzFa3+txvPB5u9IIuX4lUyp6royOSONPSbjxr2HIEc0LgNGz7xScYoHKX/hN
         XCzTFlXjRCsSmPN87Jq+xTypBL92hEAI7ylwNetIq1yJY5rL/LczQbkFsMY/rCC65b
         ikwzVyAQ0cMMJGcNPSkFZichAeO7B9W5NGJl+0tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+3ae6a2b06f131ab9849f@syzkaller.appspotmail.com
Subject: [PATCH 4.14 003/186] USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status
Date:   Mon, 24 Jan 2022 19:41:18 +0100
Message-Id: <20220124183937.218520473@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -761,6 +761,7 @@ void usb_hcd_poll_rh_status(struct usb_h
 {
 	struct urb	*urb;
 	int		length;
+	int		status;
 	unsigned long	flags;
 	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
@@ -778,11 +779,17 @@ void usb_hcd_poll_rh_status(struct usb_h
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


