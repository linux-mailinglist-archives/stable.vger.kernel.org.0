Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EFD33E468
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhCQA7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232266AbhCQA7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774C664FBD;
        Wed, 17 Mar 2021 00:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942743;
        bh=x/d2VF/3A3poxqsgLamUeBQ3qhEg9TOMAM6esh+e0qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WI4xWOtyhIr3nnfmI3/Q7pUkYpYbcfAg5ReRBeBVpMrd00mdqGqVxgk6TNyk8nds+
         13+Hng06c2XeFtlrmZxzZInXNvZD+AGLH4JMzx1Imr/ZeQ/1/Bgy0CCrCH8qDFhezf
         tMeZgQ1sqvcsGw2VlkuuEdRezVYOXqo2EK+MUL/KonLLyQqD0ULBvwHFfTU+srF3yR
         wBDbGN3iIDAbXY9nb+sxuMw6GkL8Dx44w+t0z2ScCcwzE/EaqjdJpyYGGYa+biMLN6
         yqCfusU1qR10oJ5AhVbEVPBytAQZZv3w0waf8NArKEv+ytEwfVWbilY9I3bOVGILSY
         xtsholnlNZ+4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/23] gpiolib: acpi: Add missing IRQF_ONESHOT
Date:   Tue, 16 Mar 2021 20:58:36 -0400
Message-Id: <20210317005850.726479-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

