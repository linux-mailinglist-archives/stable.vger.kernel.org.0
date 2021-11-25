Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5345DFBC
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbhKYRdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349002AbhKYRbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 12:31:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 908C161108;
        Thu, 25 Nov 2021 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637861283;
        bh=4ow3iX5eKLpKUePWw7nQ1tMDAAN3OpWPdIQKbWkkB8Q=;
        h=Subject:To:From:Date:From;
        b=05yf5i8WGN91peANO21kGSwCa4Vsm2m3jVmWzkXzXSXQzRuYbRkJKIh/SOTd1P3pZ
         /tP8W1zpvWUZyWA06vZ5Yqk9H3eRmhkesCatdrmsBCD5l01ggwjOf7JigbDVzLpL/u
         pxC7aUsj5S9jaF/9mz+LWuE89EsdPmfT93nQNtRk=
Subject: patch "serial: liteuart: Fix NULL pointer dereference in ->remove()" added to tty-linus
To:     silia@ethz.ch, gregkh@linuxfoundation.org, johan@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Nov 2021 18:27:02 +0100
Message-ID: <1637861222103190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: liteuart: Fix NULL pointer dereference in ->remove()

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0f55f89d98c8b3e12b4f55f71c127a173e29557c Mon Sep 17 00:00:00 2001
From: Ilia Sergachev <silia@ethz.ch>
Date: Mon, 15 Nov 2021 22:49:44 +0100
Subject: serial: liteuart: Fix NULL pointer dereference in ->remove()

drvdata has to be set in _probe() - otherwise platform_get_drvdata()
causes null pointer dereference BUG in _remove().

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ilia Sergachev <silia@ethz.ch>
Link: https://lore.kernel.org/r/20211115224944.23f8c12b@dtkw
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/liteuart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index dbc0559a9157..f075f4ff5fcf 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -285,6 +285,8 @@ static int liteuart_probe(struct platform_device *pdev)
 	port->line = dev_id;
 	spin_lock_init(&port->lock);
 
+	platform_set_drvdata(pdev, port);
+
 	return uart_add_one_port(&liteuart_driver, &uart->port);
 }
 
-- 
2.34.0


