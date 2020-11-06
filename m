Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5703E2A9967
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKFQY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgKFQY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:24:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB0821556;
        Fri,  6 Nov 2020 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604679864;
        bh=si7u6OxqA3k+Xqp69APSosgUtvStw3FgXkBEtxAw1nw=;
        h=Subject:To:From:Date:From;
        b=EF1tTw7dKCYIlxeUaWcxSNNfKZQOUe2cXk+OcITKdvWB5c6A6IbKdDTylcb+jU9Fe
         5Eh8wH+LDJwfqPpC1MOJbmmNwWKvxq7jNQNeQXbfENuGjc4Zxb3/m+ZMlswHbmJ00Q
         EffLA9LnnsOLXImeIRkJgpcPFk/9+weV99bM4Whs=
Subject: patch "tty: fix crash in release_tty if tty->port is not set" added to tty-linus
To:     hias@horus.com, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 17:25:02 +0100
Message-ID: <160467990267165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: fix crash in release_tty if tty->port is not set

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4466d6d2f80c1193e0845d110277c56da77a6418 Mon Sep 17 00:00:00 2001
From: Matthias Reichl <hias@horus.com>
Date: Thu, 5 Nov 2020 13:34:32 +0100
Subject: tty: fix crash in release_tty if tty->port is not set

Commit 2ae0b31e0face ("tty: don't crash in tty_init_dev when missing
tty_port") didn't fully prevent the crash as the cleanup path in
tty_init_dev() calls release_tty() which dereferences tty->port
without checking it for non-null.

Add tty->port checks to release_tty to avoid the kernel crash.

Fixes: 2ae0b31e0face ("tty: don't crash in tty_init_dev when missing tty_port")
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20201105123432.4448-1-hias@horus.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 7a4c02548fb3..9f8b9a567b35 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1515,10 +1515,12 @@ static void release_tty(struct tty_struct *tty, int idx)
 		tty->ops->shutdown(tty);
 	tty_save_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
-	tty->port->itty = NULL;
+	if (tty->port)
+		tty->port->itty = NULL;
 	if (tty->link)
 		tty->link->port->itty = NULL;
-	tty_buffer_cancel_work(tty->port);
+	if (tty->port)
+		tty_buffer_cancel_work(tty->port);
 	if (tty->link)
 		tty_buffer_cancel_work(tty->link->port);
 
-- 
2.29.2


