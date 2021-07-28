Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEE3D87D5
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 08:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhG1GZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 02:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhG1GZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 02:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED2C60F5E;
        Wed, 28 Jul 2021 06:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627453534;
        bh=WzPBhzhLuGSEX/fw6TfGk5niUxHwdIMeZdyrzkAgGt8=;
        h=Subject:To:From:Date:From;
        b=jK4yYOOkB32Z41ebW1WnCobSAX9VY5Ee1VcwD9I8yZVrWiiwqkcupAu/9t1sob9BE
         sGC5KPBlvFQWo4yBdhfFhihxNVaWpV7EDcoreq+f5nRm52HlnGBgOi4F5qeKR2OccE
         ruc5stE4rtngfglFkXpwXZBaktSKbF2nQMgzKcWw=
Subject: patch "usb: gadget: f_hid: idle uses the highest byte for duration" added to usb-linus
To:     mdevaev@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Jul 2021 08:25:32 +0200
Message-ID: <1627453532178152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_hid: idle uses the highest byte for duration

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fa20bada3f934e3b3e4af4c77e5b518cd5a282e5 Mon Sep 17 00:00:00 2001
From: Maxim Devaev <mdevaev@gmail.com>
Date: Tue, 27 Jul 2021 21:58:00 +0300
Subject: usb: gadget: f_hid: idle uses the highest byte for duration

SET_IDLE value must be shifted 8 bits to the right to get duration.
This confirmed by USBCV test.

Fixes: afcff6dc690e ("usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Link: https://lore.kernel.org/r/20210727185800.43796-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 8d50c8b127fd..bb476e121eae 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -573,7 +573,7 @@ static int hidg_setup(struct usb_function *f,
 		  | HID_REQ_SET_IDLE):
 		VDBG(cdev, "set_idle\n");
 		length = 0;
-		hidg->idle = value;
+		hidg->idle = value >> 8;
 		goto respond;
 		break;
 
-- 
2.32.0


