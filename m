Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC61333F1
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgAGVCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbgAGVCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB75214D8;
        Tue,  7 Jan 2020 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430925;
        bh=unLuJrYUMC8VjJJgbWqG0S69A83tXxMtHCMPO8y6DcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRUZWN9Gz+ucI4+v2s8/YKcC+BUxcjTg0shm6WyOwbNXoUp0tyChMWS2Lz5g0xsLB
         YoBkgxizBZoog5GzVXBL9ZIndp41e2MQtC9hPuZzR1UtX34OqaJsySOnha2ynWDUzP
         IAPoWdBGB6hs7MZEVrUJLVhhJA0+VxdHG8hGr0XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.4 152/191] watchdog: tqmx86_wdt: Fix build error
Date:   Tue,  7 Jan 2020 21:54:32 +0100
Message-Id: <20200107205341.102689315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 9a6c274ac1c4346f5384f2290caeb42dc674c471 upstream.

If TQMX86_WDT is y and WATCHDOG_CORE is m, building fails:

drivers/watchdog/tqmx86_wdt.o: In function `tqmx86_wdt_probe':
tqmx86_wdt.c:(.text+0x46e): undefined reference to `watchdog_init_timeout'
tqmx86_wdt.c:(.text+0x4e0): undefined reference to `devm_watchdog_register_device'

Select WATCHDOG_CORE to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e3c21e088f89 ("watchdog: tqmx86: Add watchdog driver for the IO controller")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191206124259.25880-1-yuehaibing@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1444,6 +1444,7 @@ config SMSC37B787_WDT
 config TQMX86_WDT
 	tristate "TQ-Systems TQMX86 Watchdog Timer"
 	depends on X86
+	select WATCHDOG_CORE
 	help
 	This is the driver for the hardware watchdog timer in the TQMX86 IO
 	controller found on some of their ComExpress Modules.


