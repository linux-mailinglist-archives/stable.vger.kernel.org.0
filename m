Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E33451491
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbhKOUKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344703AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FEE56336D;
        Mon, 15 Nov 2021 19:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002957;
        bh=Z2Bkfk7ldib36KvCzZmd63iuvwRrE+by1EVfv5cMvNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv3VST6wxH13Wp8mFqMD0J2q9iBJp9wCu+16yn1k4icASLZJiaorlmbntPq08PC4N
         faJ/kQL3vyJ9gPpXYhKqMltuV0d41k1IrwQ+34qf5wFbX73ji/KtDHTSem7Tf53rW6
         PY6R64GILn6+UOB/y34wsQAKUUyYpsja1beLXHM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 758/917] gpio: realtek-otto: fix GPIO line IRQ offset
Date:   Mon, 15 Nov 2021 18:04:13 +0100
Message-Id: <20211115165454.616882314@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 585a07079909ba9061ddd88214c36653e1aef71a ]

The irqchip uses one domain for all GPIO lines, so the line offset
should be determined w.r.t. the first line of the first port, not the
first line of the triggered port.

Fixes: 0d82fb1127fb ("gpio: Add Realtek Otto GPIO support")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-realtek-otto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-realtek-otto.c b/drivers/gpio/gpio-realtek-otto.c
index eeeb39bc171dc..bd75401b549d1 100644
--- a/drivers/gpio/gpio-realtek-otto.c
+++ b/drivers/gpio/gpio-realtek-otto.c
@@ -205,7 +205,7 @@ static void realtek_gpio_irq_handler(struct irq_desc *desc)
 		status = realtek_gpio_read_isr(ctrl, lines_done / 8);
 		port_pin_count = min(gc->ngpio - lines_done, 8U);
 		for_each_set_bit(offset, &status, port_pin_count)
-			generic_handle_domain_irq(gc->irq.domain, offset);
+			generic_handle_domain_irq(gc->irq.domain, offset + lines_done);
 	}
 
 	chained_irq_exit(irq_chip, desc);
-- 
2.33.0



