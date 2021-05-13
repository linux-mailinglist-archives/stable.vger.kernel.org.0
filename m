Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAD637FA4C
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhEMPK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhEMPKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7421610F7;
        Thu, 13 May 2021 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620918554;
        bh=7B8V0SrxzBip6YndCeDQE14QGGKuxMKhwlHkL2YpryE=;
        h=Subject:To:From:Date:From;
        b=sxE6MhqFVsZJafWwXTIsRVfXMwlcZJcEr5TsDJVTk6UfR+QV2E1Gtub+1u7FVWJJ1
         aKINqYsjrBV+4EYOSS+VJI/ShNLPqiM6hMknF8xI7CXTDeRobl5X/DAeEMabGJ15tH
         AFViX2HrsC0R3RGN2APnGS9bk38HOvnuODffDMU4=
Subject: patch "serial: 8250_dw: Add device HID for new AMD UART controller" added to tty-linus
To:     luzmaximilian@gmail.com, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, nakato@nakato.io,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:09:01 +0200
Message-ID: <1620918541213100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_dw: Add device HID for new AMD UART controller

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3c35d2a960c0077a4cb09bf4989f45d289332ea0 Mon Sep 17 00:00:00 2001
From: Maximilian Luz <luzmaximilian@gmail.com>
Date: Wed, 12 May 2021 23:04:13 +0200
Subject: serial: 8250_dw: Add device HID for new AMD UART controller

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
 drivers/acpi/acpi_apd.c           | 1 +
 drivers/tty/serial/8250/8250_dw.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
index 0ec5b3f69112..6e02448d15d9 100644
--- a/drivers/acpi/acpi_apd.c
+++ b/drivers/acpi/acpi_apd.c
@@ -226,6 +226,7 @@ static const struct acpi_device_id acpi_apd_device_ids[] = {
 	{ "AMDI0010", APD_ADDR(wt_i2c_desc) },
 	{ "AMD0020", APD_ADDR(cz_uart_desc) },
 	{ "AMDI0020", APD_ADDR(cz_uart_desc) },
+	{ "AMDI0022", APD_ADDR(cz_uart_desc) },
 	{ "AMD0030", },
 	{ "AMD0040", APD_ADDR(fch_misc_desc)},
 	{ "HYGO0010", APD_ADDR(wt_i2c_desc) },
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 9e204f9b799a..a3a0154da567 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -714,6 +714,7 @@ static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "APMC0D08", 0},
 	{ "AMD0020", 0 },
 	{ "AMDI0020", 0 },
+	{ "AMDI0022", 0 },
 	{ "BRCM2032", 0 },
 	{ "HISI0031", 0 },
 	{ },
-- 
2.31.1


