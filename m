Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD932C08DB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbgKWNCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387772AbgKWMwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4518421534;
        Mon, 23 Nov 2020 12:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135926;
        bh=CQUCjMOfPGAhegIFznBgX0y1aInCAB/EqU5zyAs/fIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSwMYPEw8q54rQ8UZhRr4/f01FBNA5MeH9bLGP7HWw8fUuK/JiVhg89RXGTtkD2ar
         mKafkVcLfJuRUffu7Kol8/1jARVkbYkx3YONORclG57Y8pB/3mRyTZO3UWjYgVniSN
         DOJ5TPlns2RTx9DTvYF5tdRw/ADpUO0bastB4KCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Zengkai <zhengzengkai@huawei.com>
Subject: [PATCH 5.9 216/252] serial: ar933x_uart: disable clk on error handling path in probe
Date:   Mon, 23 Nov 2020 13:22:46 +0100
Message-Id: <20201123121845.994774095@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Zengkai <zhengzengkai@huawei.com>

commit 425af483523b76bc78e14674a430579d38b2a593 upstream.

ar933x_uart_probe() does not invoke clk_disable_unprepare()
on one error handling path. This patch fixes that.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Link: https://lore.kernel.org/r/20201111124426.42638-1-zhengzengkai@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/ar933x_uart.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -789,8 +789,10 @@ static int ar933x_uart_probe(struct plat
 		goto err_disable_clk;
 
 	up->gpios = mctrl_gpio_init(port, 0);
-	if (IS_ERR(up->gpios) && PTR_ERR(up->gpios) != -ENOSYS)
-		return PTR_ERR(up->gpios);
+	if (IS_ERR(up->gpios) && PTR_ERR(up->gpios) != -ENOSYS) {
+		ret = PTR_ERR(up->gpios);
+		goto err_disable_clk;
+	}
 
 	up->rts_gpiod = mctrl_gpio_to_gpiod(up->gpios, UART_GPIO_RTS);
 


