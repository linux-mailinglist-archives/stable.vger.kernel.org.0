Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE5196419
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC1HMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 03:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgC1HMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 03:12:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE5720714;
        Sat, 28 Mar 2020 07:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585379533;
        bh=TxhPOQBf5e0sgE0Ulz1DahmTCACDeHgvtBK2s4hV5rY=;
        h=Subject:To:From:Date:From;
        b=SUk7UaPFmmJ7szjoMMBDs1XQWKjAl9scJP887YqlZ6JeTXNq7XwJZ7LxAFFxBmTua
         CcaGiVDmSNtbnL9eWWLw9esUNcY3NYix7qxVMsKcj7Xpyr3G+tVG+HhK6FRPqFXmID
         i10BLgqr0dCmd6XdiE+xRQt3eNCTqJ+m6Kwy9SZc=
Subject: patch "USB: cdc-acm: restore capability check order" added to usb-next
To:     hias@horus.com, anthony.mallet@laas.fr, gregkh@linuxfoundation.org,
        oneukum@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 28 Mar 2020 08:12:10 +0100
Message-ID: <1585379530163241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: restore capability check order

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 62d65bdd9d05158aa2547f8ef72375535f3bc6e3 Mon Sep 17 00:00:00 2001
From: Matthias Reichl <hias@horus.com>
Date: Fri, 27 Mar 2020 16:03:50 +0100
Subject: USB: cdc-acm: restore capability check order

commit b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
introduced a regression by changing the order of capability and close
settings change checks. When running with CAP_SYS_ADMIN setting the
close settings to the values already set resulted in -EOPNOTSUPP.

Fix this by changing the check order back to how it was before.

Fixes: b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
Cc: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20200327150350.3657-1-hias@horus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 47f09a6ce7bd..84d6f7df09a4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -923,16 +923,16 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 
 	mutex_lock(&acm->port.mutex);
 
-	if ((ss->close_delay != old_close_delay) ||
-            (ss->closing_wait != old_closing_wait)) {
-		if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN)) {
+		if ((ss->close_delay != old_close_delay) ||
+		    (ss->closing_wait != old_closing_wait))
 			retval = -EPERM;
-		else {
-			acm->port.close_delay  = close_delay;
-			acm->port.closing_wait = closing_wait;
-		}
-	} else
-		retval = -EOPNOTSUPP;
+		else
+			retval = -EOPNOTSUPP;
+	} else {
+		acm->port.close_delay  = close_delay;
+		acm->port.closing_wait = closing_wait;
+	}
 
 	mutex_unlock(&acm->port.mutex);
 	return retval;
-- 
2.26.0


