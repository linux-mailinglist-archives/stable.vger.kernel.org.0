Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E011B656
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfLKPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbfLKPNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09CE72465B;
        Wed, 11 Dec 2019 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077226;
        bh=7erlj/cyuiAjAvLgS1p7IRCV+ZNgSm3gNzqjsiQy7jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atr1kah7B0uF7w+t22dPVcIiFXwHkXo+w88zs7fu0Luqqb/HuMWpFMpPhCMcPBuxj
         UWcDCw0VsYafbYOD4u+Wjt2jqOCvmMh/0SuYV3ErX8HhZ4Q5VJ6Ja/cxMFuY7hvbiJ
         SYA/OKz0CIUOe5mVwckM/rYJfAflzO1ryP5B9bm4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 105/134] gpio: lynxpoint: Setup correct IRQ handlers
Date:   Wed, 11 Dec 2019 10:11:21 -0500
Message-Id: <20191211151150.19073-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e9e47c0d5be75..490ce7bae25ec 100644
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

