Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C939D188764
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 15:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQOYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 10:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQOYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 10:24:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E99C20752;
        Tue, 17 Mar 2020 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584455048;
        bh=pBOBswBSbtKy11rFJhTnc/5twF5aVVIfx38HxjYecKM=;
        h=Subject:To:From:Date:From;
        b=yVYIPATj/iiF1efoNLlvN3mgZiUOnWDJzv5xX8fIzMg5hIc86JVHwxpZrTh0xOoCD
         BP/c/DyKb6VpArMfmuWC2DAnVImE8f45/HDhShGYU3f+2fsaRvQlVJOpFOhXpgEraB
         6RviDMVZ2u70Xp4h7K/xmyM3uCOd+A+5pAYvzSKE=
Subject: patch "serial: sprd: Fix a dereference warning" added to tty-testing
To:     liuhhome@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Mar 2020 15:23:50 +0100
Message-ID: <158445503022839@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sprd: Fix a dereference warning

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From efc176929a3505a30c3993ddd393b40893649bd2 Mon Sep 17 00:00:00 2001
From: Lanqing Liu <liuhhome@gmail.com>
Date: Mon, 16 Mar 2020 11:13:33 +0800
Subject: serial: sprd: Fix a dereference warning

We should validate if the 'sup' is NULL or not before freeing DMA
memory, to fix below warning.

"drivers/tty/serial/sprd_serial.c:1141 sprd_remove()
 error: we previously assumed 'sup' could be null (see line 1132)"

Fixes: f4487db58eb7 ("serial: sprd: Add DMA mode support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lanqing Liu <liuhhome@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e2bd92691538e95b04a2c2a728f3292e1617018f.1584325957.git.liuhhome@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sprd_serial.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 914862844790..509781ee26bf 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1132,14 +1132,13 @@ static int sprd_remove(struct platform_device *dev)
 	if (sup) {
 		uart_remove_one_port(&sprd_uart_driver, &sup->port);
 		sprd_port[sup->port.line] = NULL;
+		sprd_rx_free_buf(sup);
 		sprd_ports_num--;
 	}
 
 	if (!sprd_ports_num)
 		uart_unregister_driver(&sprd_uart_driver);
 
-	sprd_rx_free_buf(sup);
-
 	return 0;
 }
 
-- 
2.25.1


