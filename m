Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750C72D8588
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438523AbgLLKAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 05:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438524AbgLLKAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 05:00:13 -0500
Subject: patch "USB: serial: keyspan_pda: fix stalled writes" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607767170;
        bh=zENidgJ7fRIOzluCJiWNw2f/ENnt9fOz/ksA1bllCoI=;
        h=To:From:Date:From;
        b=XDOhV3iRUnIjURcjBOCG5oaQo+iXVWzSBohFjmzKWOlkqUNUhGo+0lI3t14qaIsUP
         0BBy5omy+QiAMGU7/cDyPeW2b8tBRMph6bz3xmctoWocIXExEB4PkwOUaqO7XwQHqn
         l6Im06MXRZpEZk5DX/oNc/Yv/INK0ISqYxhN4ksE=
To:     johan@kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Dec 2020 10:59:19 +0100
Message-ID: <1607767159995@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


