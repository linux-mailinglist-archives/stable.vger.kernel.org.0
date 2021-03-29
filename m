Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C2B34C650
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhC2IGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232271AbhC2IFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94EDC619AA;
        Mon, 29 Mar 2021 08:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005137;
        bh=sdD4i8whrLRHixwaDFmWa2G1KZpuZnNUZRwWqsqmb08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hjaSK126J25OiVn2B0AHRUbJEIv2LYmdfv+GlhXuSU/Oqo/OSPaQKharTfXHvwwP
         V31Nx5R8V1+qoKEZRtemHmkLd1cTUt/vCEWpCFtWgYS2winEFs+VnZohyA6DFMQ56T
         OPAKZfLIiRGiGAFWTQnKD8f6pEap2Y0YSyse1CwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/59] gpiolib: acpi: Add missing IRQF_ONESHOT
Date:   Mon, 29 Mar 2021 09:57:49 +0200
Message-Id: <20210329075609.201191769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
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
index 7c06f4541c5d..ab5de5196080 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -234,7 +234,7 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 	int ret, value;
 
 	ret = request_threaded_irq(event->irq, NULL, event->handler,
-				   event->irqflags, "ACPI:Event", event);
+				   event->irqflags | IRQF_ONESHOT, "ACPI:Event", event);
 	if (ret) {
 		dev_err(acpi_gpio->chip->parent,
 			"Failed to setup interrupt handler for %d\n",
-- 
2.30.1



