Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC99E345E01
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCWM1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhCWM1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CEEE619B1;
        Tue, 23 Mar 2021 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502419;
        bh=cYTAvfEc1RuOxHen38MGuDkyq5MxuYOLRx4CeC0PGvI=;
        h=Subject:To:From:Date:From;
        b=kofIU2zDXtEyNykyug/4UFJxhnwJeAH8YwXjR0+I68gC5sHSiL90F0sleSL2ysk5M
         9cEd3SlwDhW3MWO+ZjgBlo4CENHSxrtmPc9XNeNm6dLCNvp52UavQNpLOmyLR3u7cY
         Kszd0wvHbIDZ43B8cvLcUyGtybkfoPftZU4cW9RE=
Subject: patch "USB: cdc-acm: downgrade message to debug" added to usb-linus
To:     oneukum@suse.com, bruno.thomsen@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:26:49 +0100
Message-ID: <161650240917943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: downgrade message to debug

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e4c77070ad45fc940af1d7fb1e637c349e848951 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 11 Mar 2021 14:01:26 +0100
Subject: USB: cdc-acm: downgrade message to debug

This failure is so common that logging an error here amounts
to spamming log files.

Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311130126.15972-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d684cf94b1c0..fd2fce072985 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -659,7 +659,8 @@ static void acm_port_dtr_rts(struct tty_port *port, int raise)
 
 	res = acm_set_control(acm, val);
 	if (res && (acm->ctrl_caps & USB_CDC_CAP_LINE))
-		dev_err(&acm->control->dev, "failed to set dtr/rts\n");
+		/* This is broken in too many devices to spam the logs */
+		dev_dbg(&acm->control->dev, "failed to set dtr/rts\n");
 }
 
 static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
-- 
2.31.0


