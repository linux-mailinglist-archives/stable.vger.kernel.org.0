Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664C4914F0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245707AbiARCZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245350AbiARCXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54975C06175E;
        Mon, 17 Jan 2022 18:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A43B8122C;
        Tue, 18 Jan 2022 02:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85947C36AE3;
        Tue, 18 Jan 2022 02:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472610;
        bh=P0K1qFpXW6iZLb8fx18FKgzSyX5CF/f0E9RlLpHqlc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZkYDOM3OCn1TkZesEC7cCdWVe38bJ4hXTreIM3uoTfgWhlFYHwEQmeTLWkZ9unkF
         22Kf6gkxcigrJ31DhBzz1Tli0LstM3rK6tyf1+A3b2/SNn40vD98FClPeySjKdyoVt
         wVF6ANaRLIMqHjPI2OfFhI1VapYTBLpG1wYFclQoOC2HD6InCMgLVyUiuPKz4RZZQR
         u/MvAmq4kOTDl5etFyvhLgirGNJKMHBMXo/YMKe6rzO9SzC/qiPx/3lX0C92Da3G/Q
         u1PURoDXY2KD4cLmMFLdQD081gIYKblEHYO6AlPG0mjqNlQV1wg52T7qcVIUKwOPCk
         jCqck6JNj1jBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        andriy.shevchenko@linux.intel.com, johan@kernel.org,
        luzmaximilian@gmail.com, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 069/217] serial: 8250_dw: Add StarFive JH7100 quirk
Date:   Mon, 17 Jan 2022 21:17:12 -0500
Message-Id: <20220118021940.1942199-69-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

[ Upstream commit 57dcb6ec85d59e04285b7dcf10924bb819c8e46f ]

On the StarFive JH7100 RISC-V SoC the UART core clocks can't be set to
exactly 16 * 115200Hz and many other common bitrates. Trying this will
only result in a higher input clock, but low enough that the UART's
internal divisor can't come close enough to the baud rate target.
So rather than try to set the input clock it's better to skip the
clk_set_rate call and rely solely on the UART's internal divisor.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20211116150119.2171-15-kernel@esmil.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 53f57c3b9f42c..1769808031c52 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -414,6 +414,8 @@ static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 
 		if (of_device_is_compatible(np, "marvell,armada-38x-uart"))
 			p->serial_out = dw8250_serial_out38x;
+		if (of_device_is_compatible(np, "starfive,jh7100-uart"))
+			p->set_termios = dw8250_do_set_termios;
 
 	} else if (acpi_dev_present("APMC0D08", NULL, -1)) {
 		p->iotype = UPIO_MEM32;
@@ -696,6 +698,7 @@ static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "cavium,octeon-3860-uart" },
 	{ .compatible = "marvell,armada-38x-uart" },
 	{ .compatible = "renesas,rzn1-uart" },
+	{ .compatible = "starfive,jh7100-uart" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
-- 
2.34.1

