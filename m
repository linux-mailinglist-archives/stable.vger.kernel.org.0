Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27033D0CFF
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhGUKSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239520AbhGUKQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 06:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C926145D;
        Wed, 21 Jul 2021 10:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626864829;
        bh=4Jxmlh4E2WpBT+ULHtIv8iJONdS36VYZSEBmtciSm60=;
        h=Subject:To:From:Date:From;
        b=zJMIPY5X4YZoLl0pWunk74q9nqeSwLMJ0UN8N2ANAFz3F6vNgwofnVY1MLDYLGKTo
         7Ndl+/iSoSD0OdpZw/qDua8nH7jRa7qRQbB5k1LX2RfuZerzdiFfmwfn6lzSQclGCw
         TVHTO7iif1cHxHy57R5kXhvOEFG6c3HZbEicqM3k=
Subject: patch "serial: tegra: Only print FIFO error message when an error occurs" added to tty-linus
To:     jonathanh@nvidia.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, treding@nvidia.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 12:53:47 +0200
Message-ID: <162686482759183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: tegra: Only print FIFO error message when an error occurs

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cc9ca4d95846cbbece48d9cd385550f8fba6a3c1 Mon Sep 17 00:00:00 2001
From: Jon Hunter <jonathanh@nvidia.com>
Date: Wed, 30 Jun 2021 13:56:43 +0100
Subject: serial: tegra: Only print FIFO error message when an error occurs

The Tegra serial driver always prints an error message when enabling the
FIFO for devices that have support for checking the FIFO enable status.
Fix this by displaying the error message, only when an error occurs.

Finally, update the error message to make it clear that enabling the
FIFO failed and display the error code.

Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
Cc: <stable@vger.kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20210630125643.264264-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 222032792d6c..eba5b9ecba34 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
-		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(tup->uport.dev,
+				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
+		}
 	} else {
 		/*
 		 * For all tegra devices (up to t210), there is a hardware
-- 
2.32.0


