Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445FB22CDE
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfETH0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbfETH0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 03:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3679220656;
        Mon, 20 May 2019 07:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558337199;
        bh=JY0jJQpAzsmba6A2qVgrL2fCybxze8eTENfrNHkiRIE=;
        h=Subject:To:From:Date:From;
        b=cWwImSTduFlwIAKvG04G0rjU3eDGLp0rR/lFUycnzVMXP7K97Pr+McfEaFWENza/B
         sakfwI4o7KZz8h0qba+f6FJs+GiLuSJKOwVFO2pXnU0LYDNi2hX+WGOAIRCnA16NTj
         7UB2sqEiekmUBU3pFUpwstofsQs7W43PbaWGiWXU=
Subject: patch "staging: wlan-ng: fix adapter initialization failure" added to staging-linus
To:     osdevtc@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 09:26:37 +0200
Message-ID: <155833719721265@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: fix adapter initialization failure

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a67fedd788182764dc8ed59037c604b7e60349f1 Mon Sep 17 00:00:00 2001
From: Tim Collier <osdevtc@gmail.com>
Date: Sat, 11 May 2019 18:40:46 +0100
Subject: staging: wlan-ng: fix adapter initialization failure

Commit e895f00a8496 ("Staging: wlan-ng: hfa384x_usb.c Fixed too long
code line warnings.") moved the retrieval of the transfer buffer from
the URB from the top of function hfa384x_usbin_callback to a point
after reposting of the URB via a call to submit_rx_urb. The reposting
of the URB allocates a new transfer buffer so the new buffer is
retrieved instead of the buffer containing the response passed into
the callback. This results in failure to initialize the adapter with
an error reported in the system log (something like "CTLX[1] error:
state(Request failed)").

This change moves the retrieval to just before the point where the URB
is reposted so that the correct transfer buffer is retrieved and
initialization of the device succeeds.

Signed-off-by: Tim Collier <osdevtc@gmail.com>
Fixes: e895f00a8496 ("Staging: wlan-ng: hfa384x_usb.c Fixed too long code line warnings.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 6fde75d4f064..ab734534093b 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3119,7 +3119,9 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		break;
 	}
 
+	/* Save values from the RX URB before reposting overwrites it. */
 	urb_status = urb->status;
+	usbin = (union hfa384x_usbin *)urb->transfer_buffer;
 
 	if (action != ABORT) {
 		/* Repost the RX URB */
@@ -3136,7 +3138,6 @@ static void hfa384x_usbin_callback(struct urb *urb)
 	/* Note: the check of the sw_support field, the type field doesn't
 	 *       have bit 12 set like the docs suggest.
 	 */
-	usbin = (union hfa384x_usbin *)urb->transfer_buffer;
 	type = le16_to_cpu(usbin->type);
 	if (HFA384x_USB_ISRXFRM(type)) {
 		if (action == HANDLE) {
-- 
2.21.0


