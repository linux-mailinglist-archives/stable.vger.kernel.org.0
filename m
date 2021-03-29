Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5242134C97D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhC2I37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234293AbhC2I2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1BEA619D0;
        Mon, 29 Mar 2021 08:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006437;
        bh=sVURH9xQNJTVxxqiD4JO++kz+Hn2GaPDiRIcKKnd0io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRyYWc2+1pd6QDW8a+OMR3TdehKDRBxRJQdrbyyxB/+rf5+RNHDloKNrq/qStcTmg
         MRS88k/E30qgtyW1D7ekOiPKxvcTcTdvqPMHYlhkQGSS5CwL0OoHQ3MhpHRygqn3Ml
         KwJZOPgs5SxfKvH3Vlf7hPTGRDAGsSGMhBi6k5Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 020/254] gpiolib: acpi: Add missing IRQF_ONESHOT
Date:   Mon, 29 Mar 2021 09:55:36 +0200
Message-Id: <20210329075633.814778315@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 495f779b2ab9..1aacd2a5a1fd 100644
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



