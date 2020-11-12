Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3252B014E
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 09:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKLIkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 03:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKLIkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 03:40:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF486221FF;
        Thu, 12 Nov 2020 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605170420;
        bh=OMb2plE7JijolIxd8WH3ofSstZrqeW3kqBhjE/3H8b4=;
        h=Subject:To:From:Date:From;
        b=yw8K3cV/n1eN1V6fOmmCRvvOmhDEz/Btx8eORB2FyyAJpabX3eqrExtfenfYuuN0u
         2fv/BKBusgz5/uYaIROOCkX8fl43bDZOxMX9Zi1+kFlNP5ViZ71FSS4vpWZoMyp5lW
         tReZsbxRqWzfvu+nn5CM5mTXDmLqMCe8l/jlZOz8=
Subject: patch "serial: ar933x_uart: disable clk on error handling path in probe" added to tty-linus
To:     zhengzengkai@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Nov 2020 09:41:19 +0100
Message-ID: <160517047919684@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: ar933x_uart: disable clk on error handling path in probe

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 425af483523b76bc78e14674a430579d38b2a593 Mon Sep 17 00:00:00 2001
From: Zheng Zengkai <zhengzengkai@huawei.com>
Date: Wed, 11 Nov 2020 20:44:26 +0800
Subject: serial: ar933x_uart: disable clk on error handling path in probe

ar933x_uart_probe() does not invoke clk_disable_unprepare()
on one error handling path. This patch fixes that.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Link: https://lore.kernel.org/r/20201111124426.42638-1-zhengzengkai@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ar933x_uart.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 0c80a79d7442..c2be7cf91399 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -789,8 +789,10 @@ static int ar933x_uart_probe(struct platform_device *pdev)
 		goto err_disable_clk;
 
 	up->gpios = mctrl_gpio_init(port, 0);
-	if (IS_ERR(up->gpios) && PTR_ERR(up->gpios) != -ENOSYS)
-		return PTR_ERR(up->gpios);
+	if (IS_ERR(up->gpios) && PTR_ERR(up->gpios) != -ENOSYS) {
+		ret = PTR_ERR(up->gpios);
+		goto err_disable_clk;
+	}
 
 	up->rts_gpiod = mctrl_gpio_to_gpiod(up->gpios, UART_GPIO_RTS);
 
-- 
2.29.2


