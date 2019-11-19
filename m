Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B79102D8B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfKSU2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfKSU2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 15:28:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 927022240E;
        Tue, 19 Nov 2019 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574195327;
        bh=y5h77RhmistkAXA3Tf21xOZH+Z/rd3Sf8j2GfpN6gcM=;
        h=Subject:To:From:Date:From;
        b=j5bZwyDlqyKmacYml5Xl1fLPSK+OZJgCugutdvez0icXdFwPceufc8DHMwcQa+7/4
         +gD+VA7M1nCg3i28TFjjfYRZ5DTtWoEoaxvjmcwjp09+f23TYAPdPEdtk7n8bgqGj9
         YppAuTEdy2LMHb0zhCtH2JxiKWH9BeX+v/a6tvrc=
Subject: patch "serial: ifx6x60: add missed pm_runtime_disable" added to tty-next
To:     hslester96@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 19 Nov 2019 21:28:36 +0100
Message-ID: <1574195316198173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: ifx6x60: add missed pm_runtime_disable

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 50b2b571c5f3df721fc81bf9a12c521dfbe019ba Mon Sep 17 00:00:00 2001
From: Chuhong Yuan <hslester96@gmail.com>
Date: Mon, 18 Nov 2019 10:48:33 +0800
Subject: serial: ifx6x60: add missed pm_runtime_disable

The driver forgets to call pm_runtime_disable in remove.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191118024833.21587-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ifx6x60.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index ffefd218761e..31033d517e82 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1230,6 +1230,9 @@ static int ifx_spi_spi_remove(struct spi_device *spi)
 	struct ifx_spi_device *ifx_dev = spi_get_drvdata(spi);
 	/* stop activity */
 	tasklet_kill(&ifx_dev->io_work_tasklet);
+
+	pm_runtime_disable(&spi->dev);
+
 	/* free irq */
 	free_irq(gpio_to_irq(ifx_dev->gpio.reset_out), ifx_dev);
 	free_irq(gpio_to_irq(ifx_dev->gpio.srdy), ifx_dev);
-- 
2.24.0


