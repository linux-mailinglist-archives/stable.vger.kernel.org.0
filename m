Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793AA37EEAD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348134AbhELWEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390310AbhELVFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:05:52 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72C8C061574;
        Wed, 12 May 2021 14:04:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id p20so7373781ljj.8;
        Wed, 12 May 2021 14:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xvsZIkVWsK5u6BrUMxfQ72wY7XR0DrZQLiaTA4JvD7g=;
        b=XHhvInoouIKbOo2bJOSXvuUedIlnJfLZlRWxJ9dD1qlsVtYSPTKFghcMprKwkHb/83
         RBbcM8rIOShgwC7Ya+8qEMsJNfjbacZZt1X5/O+o6nakLGEP55UhFgbX+7z+gMFreBJf
         GMdTdh/itOlJw1JY2VOdpS1s16Ykl3XBHdzp2ZM9s6EUPGJtuhIDQ4c766pIK7ZtKG0y
         zGc5DiaoDCw03iYF37ImONEebTfiL5LA7IlrYXktWK+1cE8NUOdPXxbNvzuZCE4OBjQH
         t7eGmtGDP0vueSTP4pfltb56+wvvmyn5UJDaaPX8oG/IbGuAZM7ivzPitAy+ZlWT9JA6
         PrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xvsZIkVWsK5u6BrUMxfQ72wY7XR0DrZQLiaTA4JvD7g=;
        b=WjVxDLMVqcy0N6Vyfif4k598Ou5R2JVA8bDtenqBReLLiau4ZMlUSIPkKa5sDAMZxX
         my8kty61RJhNNL37Z/vLXOl4k4UZ9Xdbz6zH/KuiJ2E0g6bme96Kg2AA3rELKqmckj2m
         WCVKSW6btbNn5F2GO5bQ1/a+u72R9a43VOFmyc8yobKffDEJlRNygy/FtZf0pwh/cPDi
         wl7UFVE8nhqtr4llwtMo07RrmEG57GnKeUp4hbOLLQg/IrVkobHzsyg/pSAPXx3JDUwR
         9vZXV94OKOG5siybIar3zpA+urag6qdvZ7uwvaaY8TkHlLve6882E4GptGBqyMfFpn5U
         roVQ==
X-Gm-Message-State: AOAM530BTvleDFdtjfML5tbI3jliPejkTGiX9/YpHthu8MLn4pLvrXUh
        aKauksAZSxKI4AgsLTEeHDM=
X-Google-Smtp-Source: ABdhPJzRZnR8Ei6cnCgoy9dRd7O62EfPYJkfJK6rRlFqhhcFWHai6oGeIxpnmmPZ786vMFzr+qUtFw==
X-Received: by 2002:a2e:8646:: with SMTP id i6mr30471091ljj.391.1620853481256;
        Wed, 12 May 2021 14:04:41 -0700 (PDT)
Received: from xws.localdomain ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id q65sm141755ljb.34.2021.05.12.14.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:04:40 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, stable@vger.kernel.org,
        Sachi King <nakato@nakato.io>
Subject: [PATCH] serial: 8250_dw: Add device HID for new AMD UART controller
Date:   Wed, 12 May 2021 23:04:13 +0200
Message-Id: <20210512210413.1982933-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add device HID AMDI0022 to the AMD UART controller driver match table
and create a platform device for it. This controller can be found on
Microsoft Surface Laptop 4 devices and seems similar enough that we can
just copy the existing AMDI0020 entries.

Cc: <stable@vger.kernel.org> # 5.10+
Tested-by: Sachi King <nakato@nakato.io>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
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

