Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E211B5CF0
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgDWNuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgDWNuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:50:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21B302076C;
        Thu, 23 Apr 2020 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649851;
        bh=PBpkL5KEtHbqyZ493sqtVxRmOH3c8FIgigwR/6AcnHI=;
        h=Subject:To:From:Date:From;
        b=p7U1GVAXlTBNMwbUU4ykywq3BlOe5wwwkyGcONgnsinVgeAWtfnHo0Rkulr1plvfZ
         yy260n5jKJ591F2dqIqMDivY95cCrYy7Dds3xizmkIruUD2YN86xjM4kICFaQ6CnJ1
         NvaDbmb9SX0L9GN0p/Vxi7wWodnagpLVcP8Bn3PU=
Subject: patch "tty: rocket, avoid OOB access" added to tty-linus
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:50:41 +0200
Message-ID: <15876498419057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: rocket, avoid OOB access

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7127d24372bf23675a36edc64d092dc7fd92ebe8 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 17 Apr 2020 12:59:59 +0200
Subject: tty: rocket, avoid OOB access

init_r_port can access pc104 array out of bounds. pc104 is a 2D array
defined to have 4 members. Each member has 8 submembers.
* we can have more than 4 (PCI) boards, i.e. [board] can be OOB
* line is not modulo-ed by anything, so the first line on the second
  board can be 4, on the 3rd 12 or alike (depending on previously
  registered boards). It's zero only on the first line of the first
  board. So even [line] can be OOB, quite soon (with the 2nd registered
  board already).

This code is broken for ages, so just avoid the OOB accesses and don't
try to fix it as we would need to find out the correct line number. Use
the default: RS232, if we are out.

Generally, if anyone needs to set the interface types, a module parameter
is past the last thing that should be used for this purpose. The
parameters' description says it's for ISA cards anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20200417105959.15201-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/rocket.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index fbaa4ec85560..e2138e7d5dc6 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -632,18 +632,21 @@ init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	tty_port_init(&info->port);
 	info->port.ops = &rocket_port_ops;
 	info->flags &= ~ROCKET_MODE_MASK;
-	switch (pc104[board][line]) {
-	case 422:
-		info->flags |= ROCKET_MODE_RS422;
-		break;
-	case 485:
-		info->flags |= ROCKET_MODE_RS485;
-		break;
-	case 232:
-	default:
+	if (board < ARRAY_SIZE(pc104) && line < ARRAY_SIZE(pc104_1))
+		switch (pc104[board][line]) {
+		case 422:
+			info->flags |= ROCKET_MODE_RS422;
+			break;
+		case 485:
+			info->flags |= ROCKET_MODE_RS485;
+			break;
+		case 232:
+		default:
+			info->flags |= ROCKET_MODE_RS232;
+			break;
+		}
+	else
 		info->flags |= ROCKET_MODE_RS232;
-		break;
-	}
 
 	info->intmask = RXF_TRIG | TXFIFO_MT | SRC_INT | DELTA_CD | DELTA_CTS | DELTA_DSR;
 	if (sInitChan(ctlp, &info->channel, aiop, chan) == 0) {
-- 
2.26.2


