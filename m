Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABD62A2AC9
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgKBMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbgKBMfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 07:35:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E7C2076E;
        Mon,  2 Nov 2020 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604320554;
        bh=x+FcpbP4yMTRQ4BKyiIinjWUQrKXV2xbjbJ78Yjjh2Y=;
        h=Subject:To:From:Date:From;
        b=OV8Kbr64OGLRkpL1qvHYjZW4OxE6KR161M1niCln+aJWQuF0UyoxpmreLjHxGRvWp
         kg6HN8VC7zAcxG8CpOucalvE611qOiuPFFC2N5dN6WcqcZP28WTt28QgXxWYk+sF1Q
         kYi8UxJkgR7s6BQqvaNAKItwnJvqU0w9ZZb1AGjM=
Subject: patch "usb: dwc3: ep0: Fix delay status handling" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Nov 2020 13:36:42 +0100
Message-ID: <160432060210138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: ep0: Fix delay status handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fa27e2f6c5e674f3f1225f9ca7a7821faaf393bb Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 22 Oct 2020 15:44:59 -0700
Subject: usb: dwc3: ep0: Fix delay status handling

If we want to send a control status on our own time (through
delayed_status), make sure to handle a case where we may queue the
delayed status before the host requesting for it (when XferNotReady
is generated). Otherwise, the driver won't send anything because it's
not EP0_STATUS_PHASE yet. To resolve this, regardless whether
dwc->ep0state is EP0_STATUS_PHASE, make sure to clear the
dwc->delayed_status flag if dwc3_ep0_send_delayed_status() is called.
The control status can be sent when the host requests it later.

Cc: <stable@vger.kernel.org>
Fixes: d97c78a1908e ("usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 7be3903cb842..8b668ef46f7f 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -1058,10 +1058,11 @@ void dwc3_ep0_send_delayed_status(struct dwc3 *dwc)
 {
 	unsigned int direction = !dwc->ep0_expect_in;
 
+	dwc->delayed_status = false;
+
 	if (dwc->ep0state != EP0_STATUS_PHASE)
 		return;
 
-	dwc->delayed_status = false;
 	__dwc3_ep0_do_control_status(dwc, dwc->eps[direction]);
 }
 
-- 
2.29.2


