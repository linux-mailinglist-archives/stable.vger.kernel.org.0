Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF134C8CD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhC2IYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhC2IHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F009961999;
        Mon, 29 Mar 2021 08:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005224;
        bh=x/d2VF/3A3poxqsgLamUeBQ3qhEg9TOMAM6esh+e0qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G7th7ajtUJmG4I+sXE53BUIOa32uxO8EvddY1qGv3OJk9XL5fqznLlkgB1Er4PyZ
         YNQfR8gz9DnMS5LGF/45bzDtkt5coXePd4FV2AmAMUdqn7va5Spu/L2T88IKiGlRqf
         r4o0ObiyudmGdu+rw5ui0fkYaREisyhOysI7t3Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/72] gpiolib: acpi: Add missing IRQF_ONESHOT
Date:   Mon, 29 Mar 2021 09:57:46 +0200
Message-Id: <20210329075610.627181065@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 6e5d5791730b55a1f987e1db84b078b91eb49e99 ]

fixed the following coccicheck:
./drivers/gpio/gpiolib-acpi.c:176:7-27: ERROR: Threaded IRQ with no
primary handler requested without IRQF_ONESHOT

Make sure threaded IRQs without a primary handler are always request
with IRQF_ONESHOT

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 18f5973b9697..4ad34c6803ad 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -177,7 +177,7 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 	int ret, value;
 
 	ret = request_threaded_irq(event->irq, NULL, event->handler,
-				   event->irqflags, "ACPI:Event", event);
+				   event->irqflags | IRQF_ONESHOT, "ACPI:Event", event);
 	if (ret) {
 		dev_err(acpi_gpio->chip->parent,
 			"Failed to setup interrupt handler for %d\n",
-- 
2.30.1



