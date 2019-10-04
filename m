Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58664CBB27
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 15:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfJDNDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 09:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfJDNDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 09:03:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08FBC222BE;
        Fri,  4 Oct 2019 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570194216;
        bh=J5DhuTfRjjYMFVDIA9Bk0wwadkcWEDAnS1yaUOxJa1M=;
        h=Subject:To:From:Date:From;
        b=K/b+l7XNK/inSFeq78VR8ZlkX4/Abxx0htU2T+Ag2F+khN6nxNTAdCbNa66BZ214c
         WWcQeSDGWwACj+GGwh0GJfmr82t6/Dz3lCRYj1KloPEl2gpN8U1EiF6oRg9QOxp9zx
         HiYLbMXH605bEoeS3TagzV2RIJj5MxEyoycN8Zo8=
Subject: patch "serial: uartlite: fix exit path null pointer" added to tty-linus
To:     rdunlap@infradead.org, gregkh@linuxfoundation.org,
        jacmet@sunsite.dk, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 15:03:15 +0200
Message-ID: <157019419556118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: uartlite: fix exit path null pointer

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a553add0846f355a28ed4e81134012e4a1e280c2 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 16 Sep 2019 16:12:23 -0700
Subject: serial: uartlite: fix exit path null pointer

Call uart_unregister_driver() conditionally instead of
unconditionally, only if it has been previously registered.

This uses driver.state, just as the sh-sci.c driver does.

Fixes this null pointer dereference in tty_unregister_driver(),
since the 'driver' argument is null:

  general protection fault: 0000 [#1] PREEMPT SMP KASAN PTI
  RIP: 0010:tty_unregister_driver+0x25/0x1d0

Fixes: 238b8721a554 ("[PATCH] serial uartlite driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable <stable@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Link: https://lore.kernel.org/r/9c8e6581-6fcc-a595-0897-4d90f5d710df@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/uartlite.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index b8b912b5a8b9..06e79c11141d 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -897,7 +897,8 @@ static int __init ulite_init(void)
 static void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	uart_unregister_driver(&ulite_uart_driver);
+	if (ulite_uart_driver.state)
+		uart_unregister_driver(&ulite_uart_driver);
 }
 
 module_init(ulite_init);
-- 
2.23.0


