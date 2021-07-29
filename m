Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1CF3D9DC7
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhG2Gok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 02:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhG2Gok (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 02:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 392D36103A;
        Thu, 29 Jul 2021 06:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627541077;
        bh=RHX9JTGkdMLfmWI9+WuU6af06aiyeev/pCmfbjrTROU=;
        h=Subject:To:From:Date:From;
        b=mcL2kdJbeAL4znsENqwmC288zpUVDrKW4TFiyx80On2KDoacBkS8f/jg+TKCoTGrE
         xYcyM4bTFgajm9wivHYwx8qI8YZhGuCYp45hy45idWUaErn6urhqArh5x3tOFeNIZ9
         S4LmAalEzPjsQQxtEQ5KOWiGkIzqugrBFtw3SSwk=
Subject: patch "usb: cdns3: Fixed incorrect gadget state" added to usb-linus
To:     pawell@cadence.com, peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 08:44:35 +0200
Message-ID: <16275410751116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: Fixed incorrect gadget state

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aa35772f61752d4c636d46be51a4f7ca6c029ee6 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Wed, 23 Jun 2021 09:02:47 +0200
Subject: usb: cdns3: Fixed incorrect gadget state

For delayed status phase, the usb_gadget->state was set
to USB_STATE_ADDRESS and it has never been updated to
USB_STATE_CONFIGURED.
Patch updates the gadget state to correct USB_STATE_CONFIGURED.
As a result of this bug the controller was not able to enter to
Test Mode while using MSC function.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210623070247.46151-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
---
 drivers/usb/cdns3/cdns3-ep0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-ep0.c
index 02ec7ab4bb48..e29989d57bef 100644
--- a/drivers/usb/cdns3/cdns3-ep0.c
+++ b/drivers/usb/cdns3/cdns3-ep0.c
@@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		request->actual = 0;
 		priv_dev->status_completion_no_call = true;
 		priv_dev->pending_status_request = request;
+		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
 		spin_unlock_irqrestore(&priv_dev->lock, flags);
 
 		/*
-- 
2.32.0


