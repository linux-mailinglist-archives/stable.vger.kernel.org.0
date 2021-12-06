Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB76A4691B4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhLFIt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:49:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbhLFIt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 03:49:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16E3B8103C
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCFCC341C1;
        Mon,  6 Dec 2021 08:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638780358;
        bh=ZPHbssQ8vkt69xPAAyv3aHALH6STua5bDw/36o80rsg=;
        h=Subject:To:Cc:From:Date:From;
        b=LIbA5vucZnndPljsqESZRre7WhrY7p7MwqApupQaXNb46bdpWzBvZWaDQBX4guHfU
         CBE4gSIqXloukZPG9gr/PT8pC91stiFRjURarcjd/CvQawDkGjI7hj+JGupvB3uRUe
         QOz1XRmcqNY1dJBdyW7ElZ07XJFWcHKgDKQXbVBM=
Subject: FAILED: patch "[PATCH] serial: tegra: Change lower tolerance baud rate limit for" failed to apply to 5.4-stable tree
To:     patrik.john@u-blox.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Dec 2021 09:45:55 +0100
Message-ID: <163878035548236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b40de7469ef135161c80af0e8c462298cc5dac00 Mon Sep 17 00:00:00 2001
From: Patrik John <patrik.john@u-blox.com>
Date: Tue, 23 Nov 2021 14:27:38 +0100
Subject: [PATCH] serial: tegra: Change lower tolerance baud rate limit for
 tegra20 and tegra30

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
 

