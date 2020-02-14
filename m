Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47315E813
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394377AbgBNQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404521AbgBNQRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B8F246EA;
        Fri, 14 Feb 2020 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697059;
        bh=7RRHpMykAdOs5O0+EcuC9a2h+AH/pE0k9fVN9Vx7LXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBXtJhyGA2JmUWQT3eW67n4fdJNboQvG04db1ChKg9DuYbw+cA9baUu3ChpTsxjuE
         jb1AZlyngQa7UjT9AMOek7gNmWcWtq6QAWHfR6s6UTBSWOMBPpcn8nDuKIT4pNu+xy
         PPO0WzsNhyDvHZSpLdSp7JUmg1HW1E3iRQILchPI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 018/186] gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()
Date:   Fri, 14 Feb 2020 11:14:27 -0500
Message-Id: <20200214161715.18113-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e36eaf94be8f7bc4e686246eed3cf92d845e2ef8 ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/gpio/gpio-grgpio.c, 261:
	request_irq in grgpio_irq_map
drivers/gpio/gpio-grgpio.c, 255:
	_raw_spin_lock_irqsave in grgpio_irq_map

drivers/gpio/gpio-grgpio.c, 318:
	free_irq in grgpio_irq_unmap
drivers/gpio/gpio-grgpio.c, 299:
	_raw_spin_lock_irqsave in grgpio_irq_unmap

request_irq() and free_irq() can sleep at runtime.

To fix these bugs, request_irq() and free_irq() are called without
holding the spinlock.

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20191218132605.10594-1-baijiaju1990@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 6544a16ab02e9..7541bd327e6c5 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -259,17 +259,16 @@ static int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
 	lirq->irq = irq;
 	uirq = &priv->uirqs[lirq->index];
 	if (uirq->refcnt == 0) {
+		spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 		ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
 				  dev_name(priv->dev), priv);
 		if (ret) {
 			dev_err(priv->dev,
 				"Could not request underlying irq %d\n",
 				uirq->uirq);
-
-			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
-
 			return ret;
 		}
+		spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 	}
 	uirq->refcnt++;
 
@@ -315,8 +314,11 @@ static void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 	if (index >= 0) {
 		uirq = &priv->uirqs[lirq->index];
 		uirq->refcnt--;
-		if (uirq->refcnt == 0)
+		if (uirq->refcnt == 0) {
+			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 			free_irq(uirq->uirq, priv);
+			return;
+		}
 	}
 
 	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
-- 
2.20.1

