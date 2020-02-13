Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4915C2B0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbgBMP3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387819AbgBMP3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:20 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CFA222C2;
        Thu, 13 Feb 2020 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607759;
        bh=JaT4aqIPA7sdBwL/lS10pKXWhXxQ6KJQqjdsG1m/SVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwF8gUyYrgPjXmmjdbpg3i8J7RrjQGbVJziG6PR+T47ItoAfmXXtFKkYgGhuVnBky
         QpiBZfJ23x3M3DXLqHufT3/yNnZgpAVZTVbnYbdNv/Ehwndk+5oXSzYp9J2zf4f2Fw
         9Zl4YkKGZBKAy2m3+Wa+h6pfl2vSrlsYORIvGIjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Gazzillo <paul@pgazz.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.5 114/120] mfd: max77650: Select REGMAP_IRQ in Kconfig
Date:   Thu, 13 Feb 2020 07:21:50 -0800
Message-Id: <20200213151938.589101176@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit cb7a374a5e7a5af3f8c839f74439193add6d0589 upstream.

MAX77650 MFD driver uses regmap_irq API but doesn't select the required
REGMAP_IRQ option in Kconfig. This can cause the following build error
if regmap irq is not enabled implicitly by someone else:

    ld: drivers/mfd/max77650.o: in function `max77650_i2c_probe':
    max77650.c:(.text+0xcb): undefined reference to `devm_regmap_add_irq_chip'
    ld: max77650.c:(.text+0xdb): undefined reference to `regmap_irq_get_domain'
    make: *** [Makefile:1079: vmlinux] Error 1

Fix it by adding the missing option.

Fixes: d0f60334500b ("mfd: Add new driver for MAX77650 PMIC")
Reported-by: Paul Gazzillo <paul@pgazz.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -758,6 +758,7 @@ config MFD_MAX77650
 	depends on OF || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  Say Y here to add support for Maxim Semiconductor MAX77650 and
 	  MAX77651 Power Management ICs. This is the core multifunction


