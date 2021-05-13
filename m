Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157EB37FA49
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhEMPKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhEMPKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB825613BF;
        Thu, 13 May 2021 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620918541;
        bh=dwj65/Fc4kGTnBbTwaLenfqPP5+VX1dl/1mVbsGQ214=;
        h=Subject:To:From:Date:From;
        b=hR4KO8njDRbss9qwg1FbHIEhpmP369CWSIDxN2j+jb1/0gOXDr1l2LYPuvuIaKPem
         zDRBWeCT9YHwIiQoaeWhHaZ6iAqsEC/k5Hy3g888SPB6sDOSNgiu68ejG3dRXOJpmD
         ZY5PApJ8Env7xZrRTo4dWk8Qs6X1a5zQksAyjKlI=
Subject: patch "serial: tegra: Fix a mask operation that is always true" added to tty-linus
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:08:58 +0200
Message-ID: <16209185381180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: tegra: Fix a mask operation that is always true

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3ddb4ce1e6e3bd112778ab93bbd9092f23a878ec Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Mon, 26 Apr 2021 11:55:14 +0100
Subject: serial: tegra: Fix a mask operation that is always true

Currently the expression lsr | UART_LSR_TEMT is always true and
this seems suspect. I believe the intent was to mask lsr with UART_LSR_TEMT
to check that bit, so the expression should be using the & operator
instead. Fix this.

Fixes: b9c2470fb150 ("serial: tegra: flush the RX fifo on frame error")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426105514.23268-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index bbae072a125d..222032792d6c 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -338,7 +338,7 @@ static void tegra_uart_fifo_reset(struct tegra_uart_port *tup, u8 fcr_bits)
 
 	do {
 		lsr = tegra_uart_read(tup, UART_LSR);
-		if ((lsr | UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
+		if ((lsr & UART_LSR_TEMT) && !(lsr & UART_LSR_DR))
 			break;
 		udelay(1);
 	} while (--tmout);
-- 
2.31.1


