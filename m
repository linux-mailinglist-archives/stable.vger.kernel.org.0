Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4A12F138
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgABWPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgABWOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F030222314;
        Thu,  2 Jan 2020 22:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003294;
        bh=zYCLXWmHDfa1SipQIKdc3r1yJUfAljpCwyDls8BLOgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kq1CMefU8pzHu8JyKWpwPSOJMzIevu9A+opdpYHDawO0lOAuZecwjNwGBBT7zaIQD
         27G2rs5PEeFYFy2BmGbp5uca5vS8YIooZSBHkoVYOOfvSn4t3fDepPIav+BhB20QXd
         9nubIq/GIkObn0TIFy85S940uqQq5VHShl3TpWEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/191] gpio: lynxpoint: Setup correct IRQ handlers
Date:   Thu,  2 Jan 2020 23:06:23 +0100
Message-Id: <20200102215840.765336057@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e272f7ec070d212b9301d5a465bc8952f8dcf908 ]

When commit 75e99bf5ed8f ("gpio: lynxpoint: set default handler to be
handle_bad_irq()") switched default handler to be handle_bad_irq() the
lp_irq_type() function remained untouched. It means that even request_irq()
can't change the handler and we are not able to handle IRQs properly anymore.
Fix it by setting correct handlers in the lp_irq_type() callback.

Fixes: 75e99bf5ed8f ("gpio: lynxpoint: set default handler to be handle_bad_irq()")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20191118180251.31439-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-lynxpoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index e9e47c0d5be7..490ce7bae25e 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -164,6 +164,12 @@ static int lp_irq_type(struct irq_data *d, unsigned type)
 		value |= TRIG_SEL_BIT | INT_INV_BIT;
 
 	outl(value, reg);
+
+	if (type & IRQ_TYPE_EDGE_BOTH)
+		irq_set_handler_locked(d, handle_edge_irq);
+	else if (type & IRQ_TYPE_LEVEL_MASK)
+		irq_set_handler_locked(d, handle_level_irq);
+
 	spin_unlock_irqrestore(&lg->lock, flags);
 
 	return 0;
-- 
2.20.1



