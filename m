Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADF45DFBD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhKYRd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349035AbhKYRb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 12:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CC9D610D1;
        Thu, 25 Nov 2021 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637861296;
        bh=WY0KYshGsPJtYmPkDuLK5Z5OqGj+ZSnLzn7apAcElhY=;
        h=Subject:To:From:Date:From;
        b=YcnnGObLGWb/6/gbB+gFdPEQBRjHGmHiUwzz87JHXn3Ufp7UPrYZ2yKpbB7gJLXOu
         67pOKaBcSLKU0xpfeoBJ9LrcpQEdaKWc20qXMOf1a5XHkjYYiTMHSyP8TabmLNMS83
         INKcraKgwPS5RZQqkamSy1OZaDZUr+QpSi+8wYBw=
Subject: patch "serial: tegra: Change lower tolerance baud rate limit for tegra20 and" added to tty-linus
To:     patrik.john@u-blox.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Nov 2021 18:27:04 +0100
Message-ID: <1637861224103161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: tegra: Change lower tolerance baud rate limit for tegra20 and

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b40de7469ef135161c80af0e8c462298cc5dac00 Mon Sep 17 00:00:00 2001
From: Patrik John <patrik.john@u-blox.com>
Date: Tue, 23 Nov 2021 14:27:38 +0100
Subject: serial: tegra: Change lower tolerance baud rate limit for tegra20 and
 tegra30

The current implementation uses 0 as lower limit for the baud rate
tolerance for tegra20 and tegra30 chips which causes isses on UART
initialization as soon as baud rate clock is lower than required even
when within the standard UART tolerance of +/- 4%.

This fix aligns the implementation with the initial commit description
of +/- 4% tolerance for tegra chips other than tegra186 and
tegra194.

Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Patrik John <patrik.john@u-blox.com>
Link: https://lore.kernel.org/r/sig.19614244f8.20211123132737.88341-1-patrik.john@u-blox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 45e2e4109acd..b6223fab0687 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1506,7 +1506,7 @@ static struct tegra_uart_chip_data tegra20_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
@@ -1517,7 +1517,7 @@ static struct tegra_uart_chip_data tegra30_uart_chip_data = {
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
-- 
2.34.0


