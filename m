Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD81E5855
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgE1HTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1HTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 03:19:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F71207D3;
        Thu, 28 May 2020 07:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590650349;
        bh=i4gLl3Zg5BTNEIw4sQrPxMbPNWXZA+6V96OThYcUN14=;
        h=Subject:To:From:Date:From;
        b=UJnEk6CpIMV7jwGmfD5XwuuGxvLMuPV1KTUanPZhZ+Skyzkvgvl7TjpJpeOzzzpQv
         HVbveB1xf3SWpTuTktbn2fv6IYAMx5Qkj47lXEo4HzN9jX6d++738bQt+5veaDsaE8
         v3BWrFkCzKn8T91NXjPez9suyus96fVs8jUoy4Nw=
Subject: patch "serial: imx: Initialize lock for non-registered console" added to tty-next
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 May 2020 09:19:07 +0200
Message-ID: <159065034721114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: imx: Initialize lock for non-registered console

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 8f065acec7573672dd15916e31d1e9b2e785566c Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 25 May 2020 13:59:52 +0300
Subject: serial: imx: Initialize lock for non-registered console

The commit a3cb39d258ef
("serial: core: Allow detach and attach serial device for console")
changed a bit logic behind lock initialization since for most of the console
driver it's supposed to have lock already initialized even if console is not
enabled. However, it's not the case for Freescale IMX console.

Initialize lock explicitly in the ->probe().

Note, there is still an open question should or shouldn't not this driver
register console properly.

Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 986d902fb7fe..6b078e395931 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2404,6 +2404,9 @@ static int imx_uart_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* We need to initialize lock even for non-registered console */
+	spin_lock_init(&sport->port.lock);
+
 	imx_uart_ports[sport->port.line] = sport;
 
 	platform_set_drvdata(pdev, sport);
-- 
2.26.2


