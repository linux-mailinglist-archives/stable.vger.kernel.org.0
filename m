Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92AE231940
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 07:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG2F5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 01:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgG2F5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 01:57:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806DD206D4;
        Wed, 29 Jul 2020 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596002236;
        bh=pH/Jvgs0UETubxIfK7bmO3oomhXo4t6Fdu4wzp1wKIo=;
        h=Subject:To:From:Date:From;
        b=XUzinxZymRv+LeJ1FFj6DNYHYEEQBRzsslk20DAwwflQyYhoxLfH+DKUETv3K36Ls
         CM8JYn1VgFp0KdxMCdwa8sYi29BM2ENl8zmG8mNwECu9GPzRXxVOngaMyVYAwEDdYz
         jsSEi36XcFlVsnMv+BuG5cTi0FrlsjSmwy5KBnYY=
Subject: patch "USB: serial: cp210x: enable usb generic throttle/unthrottle" added to usb-next
To:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 29 Jul 2020 07:56:50 +0200
Message-ID: <15960022105970@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: cp210x: enable usb generic throttle/unthrottle

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4387b3dbb079d482d3c2b43a703ceed4dd27ed28 Mon Sep 17 00:00:00 2001
From: Brant Merryman <brant.merryman@silabs.com>
Date: Fri, 26 Jun 2020 04:22:58 +0000
Subject: USB: serial: cp210x: enable usb generic throttle/unthrottle

Assign the .throttle and .unthrottle functions to be generic function
in the driver structure to prevent data loss that can otherwise occur
if the host does not enable USB throttling.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/57401AF3-9961-461F-95E1-F8AFC2105F5E@silabs.com
[ johan: fix up tags ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f5143eedbc48..bcceb4ad8be0 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -272,6 +272,8 @@ static struct usb_serial_driver cp210x_device = {
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tx_empty		= cp210x_tx_empty,
+	.throttle		= usb_serial_generic_throttle,
+	.unthrottle		= usb_serial_generic_unthrottle,
 	.tiocmget		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_attach,
-- 
2.27.0


