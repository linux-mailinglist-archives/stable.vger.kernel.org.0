Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE16934C8D8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhC2IYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbhC2IRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D79786197C;
        Mon, 29 Mar 2021 08:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005832;
        bh=JQUZyqb78MXj8z49UGNMLLgCd8q5U5XxGdDhNop6REE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fujx+/6oar2UiETR3n0Ziw+q9REbpXbowK53Ukpx0U2AGrlaO6Wy0idu3vwLxAjYi
         HvBEOKI+ktrChjbkxQvh/iY7RkTPSqBV47XAB9iRWKwYm9diAO1AGjdF7RA9uqyS/Q
         RzE7N0BlRyIj7eDNjg2GGvv27qDW9qh33H6o6XhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/221] gpiolib: acpi: Add missing IRQF_ONESHOT
Date:   Mon, 29 Mar 2021 09:55:52 +0200
Message-Id: <20210329075629.895499764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 49a1f8ce4baa..863f059bc498 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -174,7 +174,7 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 	int ret, value;
 
 	ret = request_threaded_irq(event->irq, NULL, event->handler,
-				   event->irqflags, "ACPI:Event", event);
+				   event->irqflags | IRQF_ONESHOT, "ACPI:Event", event);
 	if (ret) {
 		dev_err(acpi_gpio->chip->parent,
 			"Failed to setup interrupt handler for %d\n",
-- 
2.30.1



