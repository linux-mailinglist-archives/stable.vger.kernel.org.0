Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272962D78FF
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437715AbgLKPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:17:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437769AbgLKPRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:17:01 -0500
Subject: patch "USB: serial: keyspan_pda: fix stalled writes" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607699781;
        bh=l7i8WK6i0I2VTFFoeBBSlbWiDXvShjqoAoB7me+xPOc=;
        h=To:From:Date:From;
        b=TL/psRzfzKHTEAg8udqX2Sab7q3c2pBckJviHc2C0C5xFKloBS0/8wUT3lxgGU4/Y
         dFoNeK2ozx9G74BL60XXkWN+5iN16lh65FSjEyBJUTQ1hmms3nluMrSNLu9KE9HbWN
         9tCecwTmeae0bXDskidNglYB7kZr4WNsscv+RqqQ=
To:     johan@kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 16:17:18 +0100
Message-ID: <160769983843123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan_pda: fix stalled writes

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c01d2c58698f710c9e13ba3e2d296328606f74fd Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Sun, 25 Oct 2020 18:45:49 +0100
Subject: USB: serial: keyspan_pda: fix stalled writes

Make sure to clear the write-busy flag also in case no new data was
submitted due to lack of device buffer space so that writing is
resumed once space again becomes available.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 17b60e5a9f1f..d6ebde779e85 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -548,7 +548,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 
 	rc = count;
 exit:
-	if (rc < 0)
+	if (rc <= 0)
 		set_bit(0, &port->write_urbs_free);
 	return rc;
 }
-- 
2.29.2


