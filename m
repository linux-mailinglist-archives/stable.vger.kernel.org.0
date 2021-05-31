Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3C0396177
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhEaOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234077AbhEaOjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 808EA61876;
        Mon, 31 May 2021 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469148;
        bh=p4SeauKvWNvBbIefRbr7Lnfw2yPF1ndxnI34Ps1hVpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOqJ/m+AAEA/CfaWEc7PLNoYm5yIvXTWfkDEeFAQ+pFBXuK/UXGos/JDN4bC27ZmI
         CFu6UHYjzTdj1clmiyvVT5JZ3EcwrjxVDZ8HvlGJQDzEztqLcSM2Y8uBEuGxFuzFWh
         4BKol+JkOT+r/iY4v0Cnq35fTRlOx7gvHImn/b1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.12 086/296] serial: 8250_dw: Add device HID for new AMD UART controller
Date:   Mon, 31 May 2021 15:12:21 +0200
Message-Id: <20210531130706.773522388@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit 3c35d2a960c0077a4cb09bf4989f45d289332ea0 upstream.

Add device HID AMDI0022 to the AMD UART controller driver match table
and create a platform device for it. This controller can be found on
Microsoft Surface Laptop 4 devices and seems similar enough that we can
just copy the existing AMDI0020 entries.

Cc: <stable@vger.kernel.org> # 5.10+
Tested-by: Sachi King <nakato@nakato.io>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com> # for 8250_dw part
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20210512210413.1982933-1-luzmaximilian@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_apd.c           |    1 +
 drivers/tty/serial/8250/8250_dw.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/acpi/acpi_apd.c
+++ b/drivers/acpi/acpi_apd.c
@@ -226,6 +226,7 @@ static const struct acpi_device_id acpi_
 	{ "AMDI0010", APD_ADDR(wt_i2c_desc) },
 	{ "AMD0020", APD_ADDR(cz_uart_desc) },
 	{ "AMDI0020", APD_ADDR(cz_uart_desc) },
+	{ "AMDI0022", APD_ADDR(cz_uart_desc) },
 	{ "AMD0030", },
 	{ "AMD0040", APD_ADDR(fch_misc_desc)},
 	{ "HYGO0010", APD_ADDR(wt_i2c_desc) },
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -714,6 +714,7 @@ static const struct acpi_device_id dw825
 	{ "APMC0D08", 0},
 	{ "AMD0020", 0 },
 	{ "AMDI0020", 0 },
+	{ "AMDI0022", 0 },
 	{ "BRCM2032", 0 },
 	{ "HISI0031", 0 },
 	{ },


