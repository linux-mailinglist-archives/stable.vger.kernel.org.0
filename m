Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FB615E1FE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393058AbgBNQVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393051AbgBNQVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CEB246BA;
        Fri, 14 Feb 2020 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697299;
        bh=EJCV+PHusrPDBvv0wSIgAo83qYaeUgJOuXs5GXpqagc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0g0QHjDXtL4XaD+fkqZXzn/G2vAI1JAdxNr3LqvmfpBi10lgKc+vz0hE48LUhRND8
         IV7qz8kKE31Mb+VhIkZbNp769RM59FZMXwNR5P7lCOYKp1xvgrjKLbJ9iQY6ARjzKJ
         OxwiG9WTMFfxnHcx2hiaYT1DekewpsEDYa0+yhpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 013/141] gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()
Date:   Fri, 14 Feb 2020 11:19:13 -0500
Message-Id: <20200214162122.19794-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 7847dd34f86fc..036a78b704270 100644
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

