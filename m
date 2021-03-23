Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB47D345DFB
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCWM0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhCWMZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 429A8619B1;
        Tue, 23 Mar 2021 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502353;
        bh=pt7a3dzQatoHMv2bJe2xSY0xC3/va8eDu1OcEN7F+wU=;
        h=Subject:To:From:Date:From;
        b=JFBtsdK3HtgQtclR74lsk2OPU6aHwqacapZJkgwkzLKstCNyOCpo88c8mIe3SpgzQ
         DGHLcB5d5SNG5dVHWShJ0ocoWjxJU3pYyRsfqFG2J8T0noHWMJn9vmJXOoA3r4LkhL
         elWw/5kHFSrDxFdwoXGoSR1N6qqCBqOatFP014vw=
Subject: patch "cdc-acm: fix BREAK rx code path adding necessary calls" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:25:51 +0100
Message-ID: <161650235147138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    cdc-acm: fix BREAK rx code path adding necessary calls

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 08dff274edda54310d6f1cf27b62fddf0f8d146e Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 11 Mar 2021 14:37:14 +0100
Subject: cdc-acm: fix BREAK rx code path adding necessary calls

Counting break events is nice but we should actually report them to
the tty layer.

Fixes: 5a6a62bdb9257 ("cdc-acm: add TIOCMIWAIT")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210311133714.31881-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 39ddb5585ded..b013671261a2 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -313,8 +313,10 @@ static void acm_process_notification(struct acm *acm, unsigned char *buf)
 			acm->iocount.dsr++;
 		if (difference & ACM_CTRL_DCD)
 			acm->iocount.dcd++;
-		if (newctrl & ACM_CTRL_BRK)
+		if (newctrl & ACM_CTRL_BRK) {
 			acm->iocount.brk++;
+			tty_insert_flip_char(&acm->port, 0, TTY_BREAK);
+		}
 		if (newctrl & ACM_CTRL_RI)
 			acm->iocount.rng++;
 		if (newctrl & ACM_CTRL_FRAMING)
-- 
2.31.0


