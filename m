Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3679137FAB9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhEMPcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 691C6613BF;
        Thu, 13 May 2021 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919868;
        bh=3s6a0jBW/IkracNjIscThVREK/A68bs3ujT0I7ce0co=;
        h=Subject:To:From:Date:From;
        b=rX5M07C/5Zd0H8v+RPhdA8egkUXSI0CliY0B7RRsWINN0m0zEEdZTxk93Y40jqvHq
         DyFokPbh//vSPjvu2HUz9PZYJ8eEh/YYwyh6wL+kFg6QM+ccH9H1jmhY3Dl89YHwPO
         2/WuQLKS7RW5qMAfWGUZBavQFgTscLRbwU7G5yq8=
Subject: patch "Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer" added to char-misc-linus
To:     gregkh@linuxfoundation.org, jirislaby@kernel.org, pakki001@umn.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:01 +0200
Message-ID: <1620919861212241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 754f39158441f4c0d7a8255209dd9a939f08ce80 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:32 +0200
Subject: Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer
 dereference"

This reverts commit 32f47179833b63de72427131169809065db6745e.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be not be needed at all as the
change was useless because this function can only be called when
of_match_device matched on something.  So it should be reverted.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: stable <stable@vger.kernel.org>
Fixes: 32f47179833b ("serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference")
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-6-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index e0c00a1b0763..51b0ecabf2ec 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!match)
-		return -ENODEV;
-
 	/* Assume that all UART ports have a DT alias or none has */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (!pdev->dev.of_node || id < 0)
-- 
2.31.1


