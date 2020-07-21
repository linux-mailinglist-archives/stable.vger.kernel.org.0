Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15E12288AD
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 21:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGUTAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 15:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgGUTAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 15:00:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C88D2065F;
        Tue, 21 Jul 2020 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595358011;
        bh=9Y5zIvlkVVXABM97ulDy4pLmRGtaEvdheS+/3642Lzs=;
        h=Subject:To:From:Date:From;
        b=js1+YpyvpJN+bcrNM/WiRiWQu7BZQcdCtCk/Mcwt9KFWsLT6VlrIZctc0O158Y4Fg
         QfEfHJ3f1nwQu15snjh42nZeL95+5fopeU2Y/UA+FFerdjEBZ/fgCNz1h4o4oCeG9Y
         0M04Rvu/SM/yKBSfDk3jYKAJjqfrCEeq/C/fBBXQ=
Subject: patch "serial: tegra: fix CREAD handling for PIO" added to tty-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        kyarlagadda@nvidia.com, smohammed@nvidia.com,
        stable@vger.kernel.org, treding@nvidia.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Jul 2020 21:00:18 +0200
Message-ID: <159535801881236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: tegra: fix CREAD handling for PIO

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b374c562ee7ab3f3a1daf959c01868bae761571c Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 10 Jul 2020 15:59:46 +0200
Subject: serial: tegra: fix CREAD handling for PIO

Commit 33ae787b74fc ("serial: tegra: add support to ignore read") added
support for dropping input in case CREAD isn't set, but for PIO the
ignore_status_mask wasn't checked until after the character had been
put in the receive buffer.

Note that the NULL tty-port test is bogus and will be removed by a
follow-on patch.

Fixes: 33ae787b74fc ("serial: tegra: add support to ignore read")
Cc: stable <stable@vger.kernel.org>     # 5.4
Cc: Shardar Shariff Md <smohammed@nvidia.com>
Cc: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20200710135947.2737-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 8de8bac9c6c7..b3bbee6b6702 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -653,11 +653,14 @@ static void tegra_uart_handle_rx_pio(struct tegra_uart_port *tup,
 		ch = (unsigned char) tegra_uart_read(tup, UART_RX);
 		tup->uport.icount.rx++;
 
-		if (!uart_handle_sysrq_char(&tup->uport, ch) && tty)
-			tty_insert_flip_char(tty, ch, flag);
+		if (uart_handle_sysrq_char(&tup->uport, ch))
+			continue;
 
 		if (tup->uport.ignore_status_mask & UART_LSR_DR)
 			continue;
+
+		if (tty)
+			tty_insert_flip_char(tty, ch, flag);
 	} while (1);
 }
 
-- 
2.27.0


