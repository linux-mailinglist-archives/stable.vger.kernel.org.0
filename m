Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA946395E2D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhEaNzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhEaNws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E1261374;
        Mon, 31 May 2021 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467980;
        bh=p4SeauKvWNvBbIefRbr7Lnfw2yPF1ndxnI34Ps1hVpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIEdmzLKpYexqJKOvUf8IcsRNuVt2GI1we5R6nJ3Oc8Vub91BB5PfExvtkscKQDr6
         OKLHcH/XRV+staBZNJUvT+5M0H1kSuLWojBU53qZ9xevCG3w2LDSnfDDUKQA90OXFL
         FxWrSVpIDCzKbuuODtlZwA6TNX4fKVL9R14fL8ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 071/252] serial: 8250_dw: Add device HID for new AMD UART controller
Date:   Mon, 31 May 2021 15:12:16 +0200
Message-Id: <20210531130700.402224806@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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


